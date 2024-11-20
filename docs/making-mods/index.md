# Index

Scripts are written in barebones Luau with Deadline-only globals (game is replaced with game modules). Modfiles are developed in Roblox Studio, so download that if you want to make maps

## How-to

Generally, you want to

-   Install the plugin
    -   Get the plugin from [here](https://github.com/recoil-group/deadline-modfile-plugin/releases). there's a place file you can view a test mod from as well
    -   Open the template mod place provided in the releases page
    -   Go to plugins, click "Plugins Folder", drop the `Plugin.rbxmx` file in there
    -   Restart Studio
    -   If you go to the Plugins tab after opening a place in Roblox Studio, you should see a button called "Deadline modding"
    -   Click it to open the plugin window
-   Get a mod studio place you can work on ([examples here](https://github.com/recoil-group/deadline-modfile-packager/tree/master/examples/source))
    -   Download one and open it with Roblox Studio
-   Export the mod
    -   Open the output (View->Output) to see any errors when exporting
    -   Open the plugin (Plugins->DeadlineSDK in Studio), click on workspace.DeadlineTestMod in the explorer, or the mod folder you have
    -   Click "export selected model as mod" in the plugin menu
-   Save the mod
    -   The plugin either prompts you a URL, or prompts to save to a file.
    -   The URL is a link to your mod source that you can load **ONLY ONCE.**. CTRl+A the contents of it and save it somewhere else.
    -   If it's a file, it's already saved where you chose to do it.
-   Get a private Deadline server
    -   Dev branch and 0.23.0 VIP servers are free
-   Load the mod
    -   Copy-paste the contents of the mod to the server console tab
    -   The game will probably freeze. Once done, press enter and the mod will load