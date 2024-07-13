---@diagnostic disable: undefined-global

set_require_domain("https://raw.githubusercontent.com/blackshibe/deadline-insitux-core-scripts/master/")

require("luau/server/gamemode_setup.lua")
require("luau/server/vip_command_bot.lua")

clear_console()
print("Running Luau v.", _VERSION)
