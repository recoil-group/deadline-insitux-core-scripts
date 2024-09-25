---@diagnostic disable: undefined-global

-- author: blackshibe
-- version: 0.23.0
-- description: runs once for every game server

clear_console()
info(_VERSION)
info("Type Luau code below and press Enter to run it.")
info("You need to be in your own private server to do so.")
info("This tab runs code for the server.")

set_require_domain("https://raw.githubusercontent.com/blackshibe/deadline-insitux-core-scripts/master/")
require("luau/server/vip_command_bot.lua")
set_require_domain("") -- probably good practice. I wasn't really thinking when adding this
