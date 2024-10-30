# Terrain

To export terrain, you have to have only one map in the mod. In that map's properties, do this:

```lua
return {
	code = "... your map code ...",

	-- for maps with terrain:
	load_terrain = true,
    -- ...
```

This will make the game load the terrain.

** THIS DOESN'T WORK RIGHT NOW. **
