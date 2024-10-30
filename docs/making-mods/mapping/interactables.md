# Interactables

Interactables are objects you can press F on. The game currently has a few.

## How-to

To create an interactable object, make a model with the following interactable_type attribute:

-   ammo_refill
    -   Refills your ammo instantly
-   capture_refill
    -   Refills your ammo if the given point is captured (defined with interactable_domination_point, 0 for Alpha, 1 for Beta and so on)
    -   Has a cooldown
-   door
    -   Door. Has a very specific, undocumented structure
    -   Example: [door.rbxm](door.rbxm)
-   light_switch
    -   When interacted with, toggles all lights inside the model. Structure is undocumented
-   custom
    -   You can create your own interactable logic. Check the custom_interactable.luau mod in the mod manifest.
-   weapon_switch
    -   Switches your weapon. Currently requires the setup as JSON, which makes it useless for modding. You can create a custom interactable that replaces weapon_switch instead.

To define the interaction point, create an attachment called "display_point" anywhere inside the model. After that your interactable should work.
