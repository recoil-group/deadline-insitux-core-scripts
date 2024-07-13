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
