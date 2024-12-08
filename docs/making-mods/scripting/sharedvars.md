# Sharedvars

The game has a list of variables that control the game settings for different players. They are called in a table called shared state.
They are split into read-only and readable. They also have different data types

## Finding the one you want and changing it

Run this in the server console:

```lua
for name, description in pairs(sharedvars_descriptions) do
    print(name, description) --> prints every sharedvars value
end
```

It will print the contents of the table with _every_ shared variable. You can then look to see if there is anything related to what you need.
You then set it with `sharedvars.name = value`. Generally,

-   text is set as strings (e.g. `sharedvars.plr_model = "main"`)
-   numbers as numbers (e.g. `sharedvars.plr_recoil = 2`)
-   bools (e.g. `sharedvars.plr_team_kill = true`)
-   with some exceptions like night vision color (e.g. `sharedvars.plr_nv_color = Color3.new(1, 0, 0)`)

## Some examples

-   Game time: you can change game time with `sharedvars.sv_time_offset = 10`
-   Teamkilling: enabled with `sharedvars.plr_team_kill = true`
-   Making the entire game slower: `sharedvars.sv_timescale = 0.5`
-   Disabling editor limits: `sharedvars.editor_compatibility_checks = false; sharedvars.editor_mount_anything = true;`
