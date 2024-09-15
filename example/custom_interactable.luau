-- author: blackshibe
-- version: 0.23.0 dev
-- description: custom interactable. Kills you.

local CustomInteractable = {}
CustomInteractable.__index = CustomInteractable

function CustomInteractable.new(instance)
	local self = {
		players_killed = 0,
		instance = instance,
	}

	return setmetatable(self, CustomInteractable)
end

function CustomInteractable:interact(player)
	self.players_killed += 1
	player.explode()
	player.kill()
	chat.send_announcement(`{self.players_killed} players killed total`)
end

-- replaces all ammo refill interactables in usual maps with this custom logic
-- doors use "door"
register_interactable("ammo_refill", CustomInteractable)
register_interactable("capture_refill", CustomInteractable)

-- any model that has an Attachment instance named display_point, and an attribute called
-- "interactable_type" set to "part_killer" will have a pop up UI show that runs this code
-- when interacted with
register_interactable("part_killer", CustomInteractable)

-- the map has to be reloaded before they work
map.set_map("misc_shooting_range")
