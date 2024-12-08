# Introduction

There's a new Luau scripting tool available in VIP servers in the dev branch as well as 0.23.0 game versions and onward that exposes functions used by the game directly.

## Running code

VIP servers can run code in the console. You can also use autorun, which is a script that will run
every time the VIP server starts, allowing you to have servers set themselves up without your involvement.
[More info about autorun here.](../mapping/autorun.md)

The client can also change sounds played by the game, create custom UI widgets, load map/attachment mods, talk to the server, etc.

## Example

```lua
---@diagnostic disable: undefined-global

if not is_private_server() and not is_studio() then
    return
end

local prefix = "/"

-- when player sends something in the chat, check if it's a command
chat.player_chatted:Connect(function(sender, channel, content)
    local command = content:split(" ")[1]
    local first_letter = command:sub(1, 1)

    -- if the first letter is the prefix, then it's a command
    if first_letter ~= prefix then
        return
    end

    -- use the command without the prefix
    command = command:sub(2, -1)

    local str = string.format("hi, %s! Ran command: %s", sender, command)
    chat.send_announcement(str, Color3.fromRGB(227, 93, 244))
end)
```
