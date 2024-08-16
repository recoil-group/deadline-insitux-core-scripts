---@diagnostic disable: undefined-global

-- author: blackshibe
-- version: 0.23.0
-- description: runs once for every game server

set_require_domain("https://raw.githubusercontent.com/blackshibe/deadline-insitux-core-scripts/master/")

-- require("luau/server/gamemode_setup.lua") -- not ready yet
require("luau/server/vip_command_bot.lua")

clear_console()
set_require_domain("") -- probably good practice. I wasn't really thinking when adding this

info(_VERSION)
info("Type Luau code below and press Enter to run it.")
info("You need to be in your own private server to do so.")
info("This tab runs code for the server.")
