---@diagnostic disable: undefined-global

-- LuauInLuau & Fiu is used to run code in the client console
-- regular globals aren't exposed. the game global is not available

print("This server is in", sharedvars.sv_location)
print("Player running code:", local_player)

local event
local total_time = 0

-- delta_time is affected by Timescale
event = time.heartbeat("hello world", function(delta_time)
	total_time = total_time + delta_time

	if total_time > 5 then
		print("5 seconds have passed")
		event:Disconnect()
	end
end)
