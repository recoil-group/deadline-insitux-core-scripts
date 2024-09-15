-- author: blackshibe
-- version: 0.23.0 dev
-- description: custom gamemode. Implements king of the hill in luau. don't ask me how any of self works

-- THIS DOESN'T WORK

local GamemodeKingOfTheHill = {}
GamemodeKingOfTheHill.__index = GamemodeKingOfTheHill

function GamemodeKingOfTheHill.new(get_head_cframe)
	local self = {
		title = "King Of The Hill",
		id = gamemode.koth,
		finished = false,
		finished_fired = false,
		maid = Maid.new(),

		heartbeat_timer = Timer.new(1 / 30),
		cumulative_delta_time = 0,
		started = Timer.new(10),

		leaderboard_overhead = self.title,

		time_tracker = TimeTracker.new(self, 60 * SHARED_STATE.gm_match_time_minutes.value),
		capture_tracker = CaptureTracker.new(self),
		point_tracker = PointTracker.new(self, self.time_tracker, self.capture_tracker),
	}

	return setmetatable(self, GamemodeKingOfTheHill)
end

function GamemodeKingOfTheHill:map_changed()
	self.capture_tracker.clear_points()

	local hill = workspace.ignore.gamemode.FindFirstChild("koth_capture")
	if hill and hill.IsA("BasePart") then
		self.capture_tracker.assign_point({
			adornee = hill,
			capture_balance = 0,
			capture_progress = 0,
			capture_progress_delta = 0,
			capture_status = pointCapture.none,
			point_type = captureTrackerPointType.twoTeam,
		})

		self.state.value.capture = self.capture_tracker.state
		self.state.notify_change()
	else
		print("[gamemode] no hill for koth")
	end
end

function GamemodeKingOfTheHill:start()
	print("[gamemode] gamemode created titled", self.title)

	self.started.reset()
	self.map_changed()

	start_match()
end

function GamemodeKingOfTheHill:attempt_spawn(player: serverPlayer)
	return ServerFramework.create_character(player)
end

function GamemodeKingOfTheHill:get_spawn_position(team: playerTeam): CFrame
	local start_cframe
	local attackers = self.state.value.attackers

	if team == attackers then
		local children = workspace.ignore.WaitForChild("attack_spawns").WaitForChild("default").GetChildren()
		local picked = children[math.random(0, #children)]

		start_cframe = picked and picked.CFrame.ToWorldSpace(CFrame.new(0, 3, 0)) or CFrame.new(0, 150, 0)
	else
		local children = workspace.ignore.WaitForChild("defend_spawns").WaitForChild("default").GetChildren()
		local picked = children[math.random(0, #children)]

		start_cframe = picked and picked.CFrame.ToWorldSpace(CFrame.new(0, 3, 0)) or CFrame.new(0, 150, 0)
	end

	return start_cframe
end

function GamemodeKingOfTheHill:player_killed(
	player: serverPlayer,
	hit_type: playerHitType,
	killer_data: playerKillerData | undefined,
	count_stats: boolean
)
	self.point_tracker.player_killed(player, hit_type, killer_data, count_stats)
end

function GamemodeKingOfTheHill:finish()
	print("gamemode ending titled", self.title, "with id", self.id)
	print("finished", self.title)

	self.finished = true
	local match_results = {
		leaderboard = {},
		time = Timescale.get_time(),
		winning_team = self.point_tracker.decide_winner(),
	}

	for _, value in pairs(ServerData.players) do
		local profile = value.profile.getState()
		match_results.leaderboard.push({
			deaths = profile.match.deaths,
			kills = profile.match.kills,
			name = value.instance.Name,
			player_team = value.match.team.value,
		})
	end

	finish_match(match_results)

	self.maid.DoCleaning()
end

function GamemodeKingOfTheHill:force_finish()
	print("gamemode force-ending titled", self.title, "with id", self.id)
	self.finished = true
	self.finish()
end

function GamemodeKingOfTheHill:update(delta_time: number)
	if self.heartbeat_timer.expired() then
		self.heartbeat_timer.reset()

		delta_time = self.cumulative_delta_time
		self.cumulative_delta_time = 0
		self.fixed_update(delta_time)
	else
		self.cumulative_delta_time += delta_time
	end
end

function GamemodeKingOfTheHill:fixed_update(delta_time: number)
	self.announce_tracker.update()

	local hill = self.capture_tracker.state.points[0]
	local should_replicate = false
	if hill and hill.capture_status == pointCapture.taken then
		if hill.capture_progress == 1 then
			should_replicate = true
			self.point_tracker.state.attacker_points += delta_time * SHARED_STATE.gm_points_per_second.value
		else
			should_replicate = true
			self.point_tracker.state.defender_points += delta_time * SHARED_STATE.gm_points_per_second.value
		end

		if should_replicate then
			self.point_tracker.replicate_points()
		end
	end

	if self.time_tracker.match_is_over() and not self.finished then
		self.finish()
	end
end
