-- this script loads the map configuration for every match

local shooting_range_config = MapConfig.SHOOTING_RANGE_CONFIGURATION
local map_config = MapConfig.MAP_CONFIGURATION

local function random_value_in_map(map)
	local entries = {}

	for key in pairs(map) do
		table.insert(entries, key)
	end
	
    local key = random_in_list(entries)
	
    return map[key]
end

if (SharedState.place_config === "Match") {
    print("Using shooting range map configuration")
	ServerMap.set_map_from_config(shooting_range_config);
} else {
	if (RunService.IsStudio()) ServerMap.set_map_from_config(STUDIO_CONFIGURATION());
	else ServerMap.set_map_from_config(random_value_in_map(map_config));

	GamemodeManager.gamemode_finished.Connect((avoid_resetting_map) => {
		if (avoid_resetting_map) return;

		ChatManager.send_announcement("20s Intermission between matches...");

		SHARED_STATE.sv_spawning_enabled.set(false);
		set_readonly_value(SHARED_STATE.ro_spawning_disabled_reason, "Intermission between matches");

		if (SHARED_STATE.sv_map_voting.value) {
			const voted_map = ServerMapVote.run_vote();
			ServerMap.set_map_from_config(map_config[voted_map]);
		} else ServerMap.set_map_from_config(random_value_in_map(map_config));

		SHARED_STATE.sv_spawning_enabled.set(true);
		set_readonly_value(SHARED_STATE.ro_spawning_disabled_reason, "");
	});
}

