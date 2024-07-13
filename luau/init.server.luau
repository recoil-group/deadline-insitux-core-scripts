-- This script runs when every deadline server starts

-- require() has a domain to make things easier
-- it doesn't exist on the client
set_require_domain("https://raw.githubusercontent.com/blackshibe/deadline-insitux-core-scripts/master/luau/")

-- manages game and map voting
require("server/gamemode_setup.luau")

-- chat bot
local bot = require("server/vip_command_bot.luau")
require(bot.__HELLO_WORLD)

-- Console.clear()
