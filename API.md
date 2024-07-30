# API reference

This is a list of the functions available in Deadline's Luau environment.

## Internal workings

The environment is a recent version of Luau compiled back into Luau and ran with a virtual machine.
Only some globals are exposed, meaning `game` is not available. Instead you have to use sandboxed functions.
Below is a list of them.

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

### console

```luau
print("hello world") -- self explanatory
console_clear() -- clears the console output
```

## Server

### require

```luau
-- sets the domain for all require() calls
set_require_domain("https://raw.githubusercontent.com/blackshibe/deadline-insitux-core-scripts/master/")

-- actually requires https://raw.githubusercontent.com/blackshibe/deadline-insitux-core-scripts/master/luau/server/gamemode_setup.lua
require("luau/server/gamemode_setup.lua")
require("luau/server/vip_command_bot.lua")
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

### mods

```luau
load_modfile("DATA") --> loads a modfile to the game
```

## Client

```

```
