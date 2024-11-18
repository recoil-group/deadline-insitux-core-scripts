# Lighting Presets

Deadline sets the game lighting based on "lighting presets". Every map has a custom one, and these lighting presets can also now change material variants, relabel materials, and change custom fog settings.

## Creating new lighting presets

You need a ModuleScript inside the lighting_presets folder with correct data. Once created, it can be set either in the map properties or with `map.set_preset("YOUR_PRESET")`. There is an example mod with a custom lighting preset available to see how this works.
