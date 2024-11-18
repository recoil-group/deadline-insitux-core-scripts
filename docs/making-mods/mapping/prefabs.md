# Prefabs

Some more functional models (range targets, ammo boxes) can't be done with modding support and should rather be placed in by the game.
Simply drop in the bricks in [the prefabs model](file/prefabs-0.23.rbxm) into your map and they should export correctly.

If you want more prefab models added, ask in the Deadline Discord

## Caveats

-   Test orientations yourself. I can't automatically generate previews for them
-   Changing the size of the bricks does nothing. They are just shaped with the models for ease of use
-   Internally, they work based on the `dl_prefab` tag and `prefab_name` attribute. Don't edit them.
