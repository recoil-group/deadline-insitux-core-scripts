-- LuauInLuau & Fiu is used to run code in the client console
-- regular globals aren't exposed. the game global is not available

local dl_client = get_dl_client()

local SharedState = dl_client.SharedState
local Timescale = dl_client.Timescale

print("This server is in", SharedState.sv_location.value)
print("Player running code:", dl_client.local_player)

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
