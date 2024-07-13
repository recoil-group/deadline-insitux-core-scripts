-- LuauInLuau & Fiu is used to run code in the client console
-- regular globals aren't exposed. the game global is not available

-- Deadline namespace globals are exposed:

-- SharedState - universal server config (if something is changed on the server, it's changed for all clients)
-- Timescale - time speed control and events
print("This server is in", SharedState.sv_location.value)
print("Player running code:", Client.local_player)

local event
local total_time = 0

-- delta_time is affected by Timescale
event = Timescale.heartbeat("hello world", function(delta_time)
	total_time += delta_time

	if total_time > 5 then
		print("5 seconds have passed")
		event:Disconnect()
	end
end)
