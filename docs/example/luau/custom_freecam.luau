-- author: blackshibe
-- version: 0.23.0 dev
-- description: custom camera mode that allows for free movement and rotation

local CustomFreecam = {}
CustomFreecam.__index = CustomFreecam

function CustomFreecam.new(get_head_cframe)
	local self = {
		get_head_cframe = get_head_cframe,

		cam_position = CFrame.new(-35.25, 135.662, 8.242),
		rot_x = 0,
		rot_y = 0,

		min_roll = -math.pi / 2 + 0.2,
		max_roll = math.pi / 2 - 0.2,
	}

	return setmetatable(self, CustomFreecam)
end

function CustomFreecam:update(delta_time)
	local mouse_delta = input.get_mouse_delta() * 0.0075 * input.get_mouse_sensitivity()
	local camera_cframe = self.cam_position

	self.rot_y -= mouse_delta.Y
	self.rot_y = math.clamp(self.rot_y, self.min_roll, self.max_roll)
	self.rot_x -= mouse_delta.X

	camera_cframe *= CFrame.Angles(0, self.rot_x, 0) * CFrame.Angles(self.rot_y, 0, 0) * CFrame.Angles(
		0,
		0,
		-self.roll or 0
	)

	camera_cframe = camera_cframe:ToWorldSpace(
		CFrame.new(
			-self.input.movementX * delta_time * 90,
			self.input.movementZ * delta_time * 90,
			-self.input.movementY * delta_time * 90
		)
	)

	self.camera_cframe = camera_cframe
	self.cam_position = CFrame.new(camera_cframe.Position)
end

register_camera_mode("CustomFreecam", CustomFreecam)
