-- this script loads the map configuration for every match

local dl_server = get_dl_server()

local ServerMap = dl_server.ServerMap
local ServerMapVote = dl_server.ServerMapVote
local ChatManager = dl_server.ChatManager
local GamemodeManager = dl_server.GamemodeManager
local SharedState = dl_server.SharedState
local MapConfig = dl_server.MapConfig

local shooting_range_config = MapConfig.SHOOTING_RANGE_CONFIGURATION
local map_config = MapConfig.MAP_CONFIGURATION

local function random_value_in_map(map)
	local entries = {}

	for key in pairs(map) do
		table.insert(entries, key)
	end

	local key = entries[math.random(1, #entries)]

	return map[key]
end

if SharedState.place_config == "Match" then
	print("Using shooting range map configuration")
	ServerMap.set_map_from_config(shooting_range_config)
else
	if dl_server.is_studio() then
		ServerMap.set_map_from_config(MapConfig.STUDIO_CONFIGURATION())
	else
		ServerMap.set_map_from_config(random_value_in_map(map_config))
	end

	GamemodeManager.gamemode_finished.Connect((avoid_resetting_map) => {
		if (avoid_resetting_map) return;

		ChatManager.send_announcement("20s Intermission between matches...");

		SharedState.sv_spawning_enabled.set(false);
		set_readonly_value(SharedState.ro_spawning_disabled_reason, "Intermission between matches");

		if (SharedState.sv_map_voting.value) {
			const voted_map = ServerMapVote.run_vote();
			ServerMap.set_map_from_config(map_config[voted_map]);
		} else ServerMap.set_map_from_config(random_value_in_map(map_config));

		SharedState.sv_spawning_enabled.set(true);
		set_readonly_value(SharedState.ro_spawning_disabled_reason, "");
	});
end
