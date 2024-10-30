-- author: blackshibe
-- version: 0.23.0 dev
-- description: kills anyone who steps inside a part tagged with "kill_box". works on custom maps

local function is_point_inside_part(point, part)
	local offset = part.CFrame:pointToObjectSpace(point)
	return math.abs(offset.X) <= part.Size.X / 2
		and math.abs(offset.Y) <= part.Size.Y / 2
		and math.abs(offset.Z) <= part.Size.Z / 2
end

time.heartbeat("check_killbox", function()
	for _, killbox in pairs(tags.get_tagged("kill_box")) do
		for _, player in pairs(get_players()) do
			local position = player.get_position()

			if not position then
				continue
			end

			if is_point_inside_part(position, killbox) then
				player.kill()
			end
		end
	end
end)
