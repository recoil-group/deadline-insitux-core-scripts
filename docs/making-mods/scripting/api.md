# API

What you want to to might be already implemented. Just Ctrl+F on this page or use the search feature on the wiki.

## Shared globals

### classes

```lua

-- the timer class
-- it allows you to fire an event once per 5 seconds while running in renderstep
local timer = Timer.new(5)
local connection;

connection = time.renderstep("my script label", function(delta_time)
	if timer:expired() then
		timer:reset()
		connection:Disconnect()

		print('5 seconds passed')
	end
end)

-- spring class
-- it's just a spring implementation
local spring = Spring.new(0.8, 40, 6, 1.9)
spring:shove(Vector3.new(10, 0, 0))
spring:update(delta_time)

```

### time

```lua
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

-- replacement for task.wait() affected by game speed
time.wait(5)
```

### tags

```lua

-- you can access the position and size data of CollectionService tagged instances in your maps with the tags namespace.

print(tags.get_tags()) --> returns a list of every tag used by the game
print(tags.get_tagged("_killbox")) --> returns a list of every part tagged with _killbox.
-- parts will have position, name, orientation, position, and size defined
-- everything else only has name at the moment

```

### instance

```lua

-- there is a wrapped luau instance which allows editing most properties of instances
-- returns a metatable with some functions

local sound = tags.get_tagged("sound_alarm")[1]
sound.play() -- for playing sound

-- works
sound.Volume = 0.5

-- method and instance properties don't work
print(sound.Parent)

-- attributes and tags can be set
sound.add_tag("tag")
sound.remove_tag("tag")

sound.set_attribute("attribute", true)
sound.get_attribute("attribute")
```

### sharedvars

```lua

-- The game has a list of variables that control the game settings for different players. They are called in a table called shared state.
-- sharedvars and sharedvars_descriptions exposes this in a simple API
-- the game has over 100 changeable settings. Check them to make sure
-- what you might want to do isn't already configurable.

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

```lua

-- this is just persistent script storage
shared.value = 5

-- from another script
print(shared.value) --> 5

```

### console

```lua
print("hello world") -- self explanatory
clear_console() -- clears the console output
```

## Server globals

### require

```lua
-- sets the domain for all require() calls
set_require_domain("https://raw.githubusercontent.com/blackshibe/deadline-insitux-core-scripts/master/")

-- actually requires https://raw.githubusercontent.com/blackshibe/deadline-insitux-core-scripts/master/luau/server/gamemode_setup.lua
require("luau/server/gamemode_setup.lua")
require("luau/server/vip_command_bot.lua")
```

### map

```lua

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

```lua

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

```lua

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

chat.set_spawning_disabled_reason("Reason why spawning is disabled") --> when players can't spawn this text will show up filtered in a prompt
sharedvars.sv_spawning_enabled = false

-- sends an ingame notification text to players
chat.send_ingame_notification("Hello world")

-- lol
sound.play_sick_riff()

```

### players

```lua

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
		for _, player in pairs(players.get_all()) do -- or players.get_alive
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

local player = players.get("MyName")

-- functions:
player.kill()
player.explode()
player.kick()
player.set_team("defender")
player.set_team("attacker")
print(player.get_team()) --> attacker
player.spawn() -- spawns the player if they are not already spawned
player.respawn() -- force respawns the player, even if they are already spawned

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

player.equip_weapon("secondary", true) -- immediately forces the player to equip their secondary
player.equip_weapon("throwable1") -- forces the player to switch to their 1st grenade

print(player.get_profile_stats()) -- lets you get player profile stats
print(player.get_leaderboard_stats()) -- returns player leaderboard stats

on_player_spawned:Connect(function(name)
	print("player spawned:", name)
end)

on_player_joined:Connect(function(name)
	print("player joined:", name)
end)

on_player_left:Connect(function(name)
	print("player left:", name)
end)

on_player_died:Connect(function(name, killer_data, stats_counted)
	-- mostly same data the game uses

	print(name, "died to", killer_data.type) -- can be burning, drowning, firearm, grenade, map_reset, other, reset
end)

-- import weapon from a code
local setup = weapons.get_setup_from_code("4f42-02212-zh1g-3oaa-ozhz-z3nb-caa9-61wo") -- setup only works in dev branch

if setup.status ~= "_" then
    warn("setup is not valid")
else
	-- 1st argument is primary, secondary, throwable1, throwable2
    player.set_weapon("primary", "M4A1", setup.data)
end

-- you can check if it's broken with get_setup_status
local setup = weapons.get_setup_from_code("cn8q-0231-31bq-zg6d-8m54-g906-o50c-m1f7")
local status = weapons.get_setup_status(setup.data)

print(status)
if type(status) ~= "string" then
	-- all problems unrelated to picatinny
	for i, v in pairs(status.state) do
		print(i, v)
	end

	-- rail problems
	for _, entry in pairs(status.rail_state.failures) do
		for i, v in pairs(entry) do
			print(i, v)
		end
	end
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

-- or you can just remove their gun
player.set_weapon("secondary", "nothing")

-- spawns an M67 grenade explosion
spawning.explosion(Vector3.new(0, 100, 0))

-- deletes all ragdolls
players.reset_ragdolls()

```

### spawning

```lua

-- you can spawn game objects

-- spawns an M67 grenade explosion
spawning.explosion(Vector3.new(0, 100, 0))

-- spawns a bot
-- they are treated like regular players, but right now don't do anything but walk towards people
local bot_name = spawning.bot()

-- ...

```

### config

```lua

-- config has most game configs

for name, data in pairs(config.maps) do
    print(name)
end

-- opens the map configuration used in studio
map.set_map_from_config(config.maps.STUDIO_CONFIGURATION())

-- these can be used with map.set_preset("name")
-- on the client, you can modify them directly
-- on the server, you may load new ones for players to use with modfiles
for name, data in pairs(config.lighting_presets) do
    print(name)
end

-- these can be used for maps' sound_preset property
for name, data in pairs(config.sound_presets) do
    print(name)
end

-- every weapon in the game
for _, name in pairs(config.weapon_names) do
    print(name)
end

-- every utility in the game
for _, name in pairs(config.utility_items) do
    print(name)
end

```

### game data

```lua

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

```lua
load_modfile("DATA") --> loads a modfile to the game
```

### networking

```lua

-- ...from the client
fire_server(1)

-- ...on the server
on_client_event:Connect(function(player, args)
	print(player, args)
end)

-- ... from the server
players.get("me").fire_client(123)

-- ... on the client
on_server_event:Connect(function(args)
	print(args)
end)

```

## Client globals

### general

```lua
print(local_player) -- prints the local_player's name
```

### config

```lua

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

### inputs

```lua
-- this module abstracts game input

print(input.get_mouse_delta()) -- equivalent to UserInputService:GetMouseDelta()
print(input.get_mouse_sensitivity()) -- gets the player sensitivity settings

-- InputGroup is also exposed, as well as ClientInputGroup
-- the input code is a table index to config.keybinds

-- ClientInputGroup uses client settings
local client_input_group = ClientInputGroup.new()
local input_group = InputGroup.new()

client_input_group:bind_user_setting(function()
	print("started pressing W")
end, InputType.Began, "move_forward")

client_input_group:bind_user_setting(function()
	print("stopped pressing W")
end, InputType.Ended, "move_forward")

input_group:bind_key(function()
		print("pressed f")
	end,
	InputType.Began,
	false,           -- ignore game processed
	Enum.KeyCode.F   -- keycode
)

input_group:bind_key(function()
		print("stopped pressing f")
	end,
	InputType.Ended,
	false,           -- ignore game processed
	Enum.KeyCode.F   -- keycode
)

client_input_group:disconnect_all_binds()
input_group:disconnect_all_binds()
```

### interactables

```lua
-- the game has interactable items such as ammo refills, doors, light switches and weapons (wip)
-- you can override their behavior or create new ones here

local CustomInteractable = {}
CustomInteractable.__index = CustomInteractable

function CustomInteractable.new(instance)
	local self = {
		players_killed = 0,
		instance = instance,
	}

	return setmetatable(self, CustomInteractable)
end

function CustomInteractable:interact(player)
	self.players_killed += 1
	player.explode()
	player.kill()
	chat.send_announcement(`{self.players_killed} players killed total`)
end

-- replaces all ammo refill interactables in usual maps with this custom logic
-- doors use "door"
register_interactable("ammo_refill", CustomInteractable)
register_interactable("capture_refill", CustomInteractable)

-- any model that has an Attachment instance named display_point, and an attribute called
-- "interactable_type" set to "part_killer" will have a pop up UI show that runs this code
-- when interacted with
register_interactable("part_killer", CustomInteractable)

-- the map has to be reloaded before they work
map.set_map("misc_shooting_range")
```

### camera control

```lua

-- you can register a custom camera controller
-- author: blackshibe
-- version: 0.23.0 dev
-- description: creates a class and registers it as a custom camera controller component

local CustomFreecam = {}
CustomFreecam.__index = CustomFreecam

function CustomFreecam.new(get_head_cframe)
	local self = {
		get_head_cframe = get_head_cframe,

		cam_position = CFrame.new(-35.25, 135.662, 8.242),
		rot_x = 0,
		rot_y = 0,

		min_roll = -math.pi / 2 + 0.2,
		max_roll = math.pi / 2 - 0.2,
	}

	return setmetatable(self, CustomFreecam)
end

function CustomFreecam:update(delta_time)
	local mouse_delta = input.get_mouse_delta() * 0.0075 * input.get_mouse_sensitivity()
	local camera_cframe = self.cam_position

	self.rot_y -= mouse_delta.Y
	self.rot_y = math.clamp(self.rot_y, self.min_roll, self.max_roll)
	self.rot_x -= mouse_delta.X

	camera_cframe *= CFrame.Angles(0, self.rot_x, 0) * CFrame.Angles(self.rot_y, 0, 0) * CFrame.Angles(
		0,
		0,
		-self.roll or 0
	)

	camera_cframe = camera_cframe:ToWorldSpace(
		CFrame.new(
			-self.input.movementX * delta_time * 90,
			self.input.movementZ * delta_time * 90,
			-self.input.movementY * delta_time * 90
		)
	)

	self.camera_cframe = camera_cframe
	self.cam_position = CFrame.new(camera_cframe.Position)
end

-- can also use Default to overwrite default cameramode
register_camera_mode("CustomFreecam", CustomFreecam)

-- on the server
players.get("me").set_custom_camera_mode("CustomFreecam")
```

### ui

```lua

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
                    clear_console()
					-- can also do network comms here
					fire_server("clear console idk")
				end,
			},
		},
	},
})

-- iris is also included
-- https://michael-48.github.io/Iris/
iris:Connect(function()
	iris.Window({"My Second Window"})
		iris.Text({"The current time is: " .. tick()})

		iris.InputText({"Enter Text"})

		if iris.Button({"Click me"}).clicked() then
			print("button was clicked")
		end

		iris.InputColor4()

		iris.Tree()
			for i = 1,8 do
				iris.Text({"Text in a loop: " .. i})
			end
		iris.End()
	iris.End()
end)
```
