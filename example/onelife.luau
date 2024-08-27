-- author: blackshibe
-- version: 0.23.0 dev
-- description: custom gamemode. once you die, you can only respawn in Freecam.

local dead_players = {}

local player_died = on_player_died:Connect(function(name, killer_data, stats_counted)
	local player = get_player(name)

	dead_players[name] = true

	player.set_camera_mode("Freecam")
	player.set_speed(0)
end)

local chat_messaged = chat.player_chatted:Connect(function(sender, channel, content)
	if content == "reset_onelife" then
		if sender ~= sharedvars.vip_owner then
			chat.send_announcement("only the VIP owner can reset the gamemode.")
			chat.send_announcement(`the VIP owner is ${sharedvars.vip_owner}`)
			return
		end

		chat.send_announcement(`respawning...`)
		for _, player in pairs(get_players()) do
			-- this MAYBE yields? i don't remember
			-- but the script was broken
			task.spawn(function()
				player.set_camera_mode("Default")
				player.set_speed(1)
				player.spawn()
			end)

			dead_players[player.name] = nil
		end
	end
end)

if shared.onelife_data then
	warn("onelife script already loaded, disconnecting")

	shared.onelife_data.player_died:Disconnect()
	shared.onelife_data.chat_messaged:Disconnect()
else
	gamemode.force_set_gamemode("none")
end

shared.onelife_data = {
	player_died = player_died,
	chat_messaged = chat_messaged,
}

info("")
info("one life gamemode loaded!")
info("once you die, you can only respawn in Freecam.")
info("to reset the gamemode, type 'reset_onelife' in the chat.")
info("only the VIP owner can reset the gamemode.")
