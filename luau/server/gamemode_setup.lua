---@diagnostic disable: undefined-global

-- this script loads the map configuration for every match

local shooting_range_config = config.map.SHOOTING_RANGE_CONFIGURATION
local map_config = config.map.MAP_CONFIGURATION
local studio_config = config.map.STUDIO_CONFIGURATION

local function random_value_in_map(map)
	local entries = {}

	for key in pairs(map) do
		table.insert(entries, key)
	end

	local key = entries[math.random(1, #entries)]

	return map[key]
end

if config.map.place_config == "Match" then
	print("Using shooting range map configuration")
	config.map.set_map_from_config(shooting_range_config)
else
	config.map.set_map_from_config(is_studio() and studio_config() or random_value_in_map(map_config))
	gamemode.gamemode_finished:Connect(function(avoid_resetting_map)
		if avoid_resetting_map then
			return
		end

		chat.send_announcement("20s Intermission between matches...")

		sharedvars.sv_spawning_enabled = false
		set_spawning_disabled_reason("Intermission between matches")

		if SharedState.sv_map_voting.value then
			local voted_map = map.run_vote()
			map.set_map_from_config(map_config[voted_map])
		else
			map.set_map_from_config(random_value_in_map(map_config))
		end

		sharedvars.sv_spawning_enabled = true
		set_spawning_disabled_reason("")
	end)
end
