local dl_server = get_dl_server()

local ChatManager = dl_server.ChatManager

if not dl_server.is_private_server() and not dl_server.is_studio() then
	return
end

local prefix = "/"
ChatManager.chatted:Connect(function(sender, channel, content)
	local command = content:split(" ")[1]

	if command:sub(1, 1) == prefix then
		command = command:sub(2, -1)
		ChatManager.send_announcement(`hi, {sender}! Ran command: {command}`, Color3.fromRGB(227, 93, 244))
	end
end)
