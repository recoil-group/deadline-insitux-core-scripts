# API reference

There's a new Luau scripting tool available in VIP servers in the dev branch as well as 0.23.0 game versions and onward that exposes functions used by the game directly. Example:

```luau
---@diagnostic disable: undefined-global

if not is_private_server() and not is_studio() then
    return
end

local prefix = "/"

-- when player sends something in the chat, check if it's a command
chat.player_chatted:Connect(function(sender, channel, content)
    local command = content:split(" ")[1]
    local first_letter = command:sub(1, 1)

    -- if the first letter is the prefix, then it's a command
    if first_letter ~= prefix then
        return
    end

    -- use the command without the prefix
    command = command:sub(2, -1)

    local str = string.format("hi, %s! Ran command: %s", sender, command)
    chat.send_announcement(str, Color3.fromRGB(227, 93, 244))
end)
```

There is one for the client and server. The client can change sounds played by the game, create custom UI widgets, load map/attachment mods, talk to the server, etc.

# How to

-   Get a VIP server in the development branch or main game (0.23.0 or above)
-   Press ` when ingame
-   Go to server/client console
-   Write your scripts in the "enter code here" textbox

# Internal workings

The environment is a recent version of Luau compiled back into Luau and ran with a virtual machine.
Only some globals are exposed, meaning `game` is not available. Instead you have to use sandboxed functions.
Below is a list of them.

# Errors

Errors made by the VM are currently far less readable than default Luau output.

## Shared globals

### time

```luau
-- Timescale, used internally by the game

-- this is a replacement for RenderStepped. delta_time is multiplied by game speed
local c = time.renderstep("my script label", function(delta_time)

end)

c:Disconnect()

-- this is a replacement for Heartbeat. delta_time is multiplied by game speed
time.renderstep("my script label", function(delta_time)

end)

time.local_timescale_changed:Connect(function()
    print('timescale has changed')
end) -- fires when timescale changes. Only used at the match ending

time.set_local_timescale(1) -- set local timescale, only used by the client
time.get_speed() -- gets current game speed

-- this is a replacement for task.delay affected by game_speed
time.delay(5, function()

end)

-- this is a replacement for Sound.Play() that affects sound speed by the game speed
time.play_sound(sound_instance)

-- replacement for task.wait() affected by game speed
time.wait(5)
```

### tags

```luau

-- you can access the position and size data of CollectionService tagged instances in your maps with the tags namespace.

print(tags.get_tags()) --> returns a list of every tag used by the game
print(tags.get_tagged("_killbox")) --> returns a list of every part tagged with _killbox.
-- parts will have position, name, orientation, position, and size defined
-- everything else only has name at the moment

```

### sharedvars

```luau

-- The game has a list of variables that control the game settings for different players. They are called in a table called shared state.
-- sharedvars and sharedvars_descriptions exposes this in a simple API

for name, description in pairs(sharedvars_descriptions) do
    print(name, description) --> prints every sharedvars value
end

for name, description in pairs(sharedvars) do
    -- iterating over sharedvars doesn't work because it's a metatable
    -- this will do nothing
    print(name, description)
end

sharedvars.chat_tips_enabled = false -- disables chat tips, only works on the server
print(sharedvars.chat_tips_enabled) -- false

```

### shared

```luau

-- this is just persistent script storage
shared.value = 5

-- from another script
print(shared.value) --> 5

```

### console

```luau
print("hello world") -- self explanatory
console_clear() -- clears the console output
```

## Server globals

### require

```luau
-- sets the domain for all require() calls
set_require_domain("https://raw.githubusercontent.com/blackshibe/deadline-insitux-core-scripts/master/")

-- actually requires https://raw.githubusercontent.com/blackshibe/deadline-insitux-core-scripts/master/luau/server/gamemode_setup.lua
require("luau/server/gamemode_setup.lua")
require("luau/server/vip_command_bot.lua")
```

### map

```luau

-- ServerMap - for managing the maps

map.set_map("shipment") -- changes the map immediately, kills all players
map.set_preset("shipment") -- changes the preset. available presets are in config.lighting_presets

local voted_map = map.run_vote() -- runs a vote for a random map. returns a game config for that map
map.set_map_from_config(config.maps.MAP_CONFIGURATION[voted_map]); -- sets the map, gamemode, and time from a config

map.set_time(10) -- sets the time 10AM (not including sharedvars.sv_time_offset)
sharedvars.sv_time_offset = 10 -- moves the time by 10 hours

-- show available maps
for name, value in map.get_maps() do
    print(name, value)
end

```

### gamemode

```luau

gamemode.set_gamemode("koth") -- sets the gamemode
gamemode.force_set_gamemode("koth") -- sets the gamemode without changing the map(?)

-- show available gamemodes
for name in gamemode.available_gamemodes do
    print(name)
end

gamemode.finished:Connect(function(avoid_resetting_map)
end) -- fires when a game ends

gamemode.started:Connect(function()
end) -- fires when a game starts

```

### chat, text

```luau

-- ChatManager - for managing the chat
chat.player_chatted:Connect(function(sender, channel, content)
	local command = content:split(" ")[1]
	local first_letter = command:sub(1, 1)

	-- if the first letter is the prefix, then it's a command
	if first_letter ~= prefix then
		return
	end

	-- use the command without the prefix
	command = command:sub(2, -1)

	local str = string.format("hi, %s! Ran command: %s", sender, command)
	chat.send_announcement(str, Color3.fromRGB(227, 93, 244)) -- chat.send_announcement - sends an announcement in the chat
end)

set_spawning_disabled_reason("Reason why spawning is disabled") --> when players can't spawn this text will show up filtered in a prompt
sharedvars.sv_spawning_enabled = false

```

### players

```luau

-- you can access player data from luau
-- this script kills anyone who steps inside a part tagged with "deleteme"

local function is_point_inside_part(point, part)
	local offset = part.cframe:pointToObjectSpace(point)
	return math.abs(offset.X) <= part.size.X / 2
		and math.abs(offset.Y) <= part.size.Y / 2
		and math.abs(offset.Z) <= part.size.Z / 2
end

time.heartbeat("check_killbox", function()
	for _, killbox in pairs(tags.get_tagged("kill_box")) do
		for _, player in pairs(get_players()) do -- or get_alive_players
			local position = player.get_position() -- returns nil if the player is dead

			if not position then
				continue
			end

			if is_point_inside_part(position, killbox) then
				player.kill()
                print("killed", player.name)
			end
		end
	end
end)

local player = get_player("MyName")

-- functions:
player.kill()
player.explode()
player.kick()
player.set_team("defender")
player.set_team("attacker")
player.spawn() -- spawns the player if they are not already spawned

-- overrides
player.set_position(Vector3.new(0, 1000, 0))
player.set_position(tags.get_tagged("spawn_point")[0].position)

player.set_speed(5)
player.set_health(200)
player.set_initial_health(200) -- doesn't work immediately
player.set_camera_mode("Freecam")
player.set_model("orchids_pbr_set")
player.ban_from_server() -- works same as votekicking someone
player.refill_ammo()

on_player_spawned:Connect(function(name)
	print("played spawned:", name)
end)

-- import weapon from a code
local setup = get_setup_from_code("4f42-02212-zh1g-3oaa-ozhz-z3nb-caa9-61wo") -- setup only works in dev branch

if setup.status ~= "_" then
    warn("setup is not valid")
else
	-- 1st argument is primary, secondary, throwable1, throwable2
    player.set_weapon("primary", "M4A1", setup.data)
end

-- or from the player loadout
-- 1st argument is loadout number, starts from 0, 1 is 2nd loadout
-- 2nd argument is primary, secondary, throwable1, throwable2
local loadout_data = player.get_weapon_from_loadout(1, "primary")
player.set_weapon("secondary", loadout_data.weapon, loadout_data.data)

-- or you can just save the setup to a string
-- this doesn't work right now because you can't copy the setup after printing it lmao
local data = "... JSON"
player.set_weapon("secondary", "M4A1", data)
```

### config

```luau

-- config has most game configs

for name, data in pairs(config.maps) do
    print(name)
end

-- opens the map configuration used in studio
map.set_map_from_config(config.maps.STUDIO_CONFIGURATION())

-- these can be used with map.set_preset("name")
for name, data in pairs(config.lighting_presets) do
    print(name)
end

-- these can be used for maps' sound_preset property
for name, data in pairs(config.sound_presets) do
    print(name)
end
```

### game data

```luau

-- game data includes current game state (map, gamemode, so on)
print(game_data.lighting.value) -- print current lighting
print(game_data.map_properties.lighting_preset) -- or this way

print(game_data.map_properties.map_config) -- print map config

-- to show all values
for name, data in pairs(game_data) do
    print(name)
end
```

### mods

```luau
load_modfile("DATA") --> loads a modfile to the game
```

### networking

```luau

-- ...from the client
fire_server(1)

-- ...on the server
on_client_event:Connect(function(player, args)
	print(player, args)
end)

```

## Client globals

### general

```luau
print(local_player) -- prints the local_player's name
```

### config

```luau

-- the config table is different on the client. it has sounds that can be replaced directly
for name, value in pairs(config.gunshots) do
	print(name, value)
	config.gunshots[name] = "rbxassetid://funny sound" -- it can be replaced
end

-- same for most game sounds
for name, value in pairs(config.game_sounds) do
	print(name, value) -- table of tables
end

```

### ui

```luau

-- you can render simple UIs on the client
ui.clear()
ui.render({
	{
		type = "widget",
		id = "widget_id",
		title = "helo",
		members = {
			{
				type = "text",
				text = "hi",
			},
			{
				type = "button",
				callback = function()
					print("button clicked")
				end,
			},
			{
				type = "textbox",
				changed = function(value)
					print(value)
				end,
				text = "slider",
			},
			{
				type = "slider",
				id = "slider1",
				changed = function(value)
					-- you can declare ids on objects to change their properties on the fly
					-- the slider won't move unless you do this in the changed event
					ui.patch_by_id("slider1", {
						value = value,
					})
				end,
			},
		},
	},
	{
		type = "floating_widget",
		id = "widget_id_2",
		title = "floating hello",
		size = { 200, 100 },
		visible = true,
		members = {
			{
				type = "text",
				text = "hi",
			},
			{
				type = "button",
                text = "clear console",
				callback = function()
                    console_clear()
					-- can also do network comms here
					fire_server("clear console idk")
				end,
			},
		},
	},
})
```
