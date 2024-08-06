---@diagnostic disable: undefined-global

if not is_private_server() and not is_studio() then
	return
end

local prefix = "-"
local commands

local map_list = map.get_maps()

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

chat.send_announcement('type "-help" to view VIP server commands')
