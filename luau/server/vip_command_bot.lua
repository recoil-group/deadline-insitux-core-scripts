---@diagnostic disable: undefined-global

-- author: blackshibe
-- version: 0.23.0 dev
-- description: runs a VIP server bot

if not is_private_server() and not is_studio() then
	return
end

local prefix = "-"
local commands

local map_list = map.get_maps()
local override_setup

commands = {
	help = function()
		local result = "Commands: "
		for command, _ in pairs(commands) do
			result = result .. command .. ", "
		end

		return result:sub(1, -3)
	end,

	lighting = function(lighting)
		if not config.lighting_presets[lighting] then
			local str = "Invalid lighting. Available lighting presets:"
			for name, _ in pairs(config.lighting_presets) do
				str = str .. " " .. name
			end

			return str
		end

		map.set_preset(lighting)

		return "Lighting set to " .. lighting
	end,

	map = function(map_name)
		if not table.find(map_list, map_name) then
			local str = "Invalid map. Available maps:"
			for _, map_name in pairs(map_list) do
				str = str .. " " .. map_name
			end

			return str
		end

		map.set_map(map_name)

		return "Map set to " .. map_name
	end,

	gamespeed = function(speed)
		speed = tonumber(speed)

		if not speed then
			return "Invalid speed"
		end

		sharedvars.sv_timescale = speed

		return "Game speed set to " .. speed
	end,

	pvp = function()
		sharedvars.plr_pvp = not sharedvars.plr_pvp

		return "PvP " .. (sharedvars.plr_pvp and "enabled" or "disabled")
	end,

	gravity = function(gravity)
		if not gravity then
			return "Please provide a gravity value"
		end

		gravity = tonumber(gravity)
		if not gravity then
			return "Invalid gravity"
		end

		sharedvars.sv_gravity = gravity

		return "Time set to " .. gravity
	end,

	nogunlimits = function(gravity)
		sharedvars.editor_compatibility_checks = false
		sharedvars.editor_mount_anything = true
		return "Disabled gun limits"
	end,

	time = function(time)
		if not time then
			return "Please provide a time"
		end

		time = tonumber(time)
		if not time then
			return "Invalid time"
		end

		map.set_time(time)

		return "Time set to " .. time
	end,

	outfit = function(outfits)
		local allowed = {
			"orchids_shark_set",
			"orchids_pbr_set",
			"main",
		}

		if not table.find(allowed, outfits) then
			local str = "Invalid outfit. Available outfits:\n"
			for _, outfit in pairs(allowed) do
				str = str .. outfit .. " "
			end

			return str
		end

		sharedvars.plr_model = outfits

		return "Outfit set to " .. outfits
	end,

	spawngun = function(args)
		local args_split = args:split(" ")
		local weapon = args_split[1]
		local code = args_split[2]

		if not weapon then
			return "Please provide a weapon"
		end

		if not code then
			return "Please provide a weapon and setup code, e.g. -spawngun M4A1 3z4n-0230-aqb6-6acg-h27f-a37g-ded5-3mhf"
		end

		local setup = weapons.get_setup_from_code(code)
		if setup.status ~= "_" then
			return "Invalid weapon setup code"
		end

		override_setup = {
			data = setup.data,
			weapon = weapon,
		}

		return "Set spawning weapon"
	end,
}

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
	if not commands[command] then
		return
	end

	local result = commands[command](content:sub(#command + 3, -1))
	chat.send_announcement(result)
end)

on_player_spawned:Connect(function(name)
	if not override_setup then
		return
	end

	local player = players.get(name)
	player.set_weapon("primary", override_setup.weapon, override_setup.data)
end)

chat.send_announcement('type "-help" to view VIP server commands')
print("the default vip server script is running. type -help in the chat to view VIP server commands.")
