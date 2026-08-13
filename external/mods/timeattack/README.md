# Time Attack Mode Tweaks (I.K.E.M.E.N. GO Module)

This module adds the following personal improvements, to make the Time Attack Mode that comes by default with engine, more faithful to Commercial Games:

- Enables the "Here Comes a New Challenger" Intermission
- Set 1 Round to Win
- Set Infinite Round Time
- Disable Continue Screen
- Adds Co-Op and Netplay Variant

> [!NOTE]
> The New Co-Op modes are detectable by [GameMode](https://github.com/ikemen-engine/Ikemen-GO/wiki/Triggers-(new)#gamemode) trigger as:
> - timeattackcoop
> - netplaytimeattackcoop

## Installation

### 1) Install the module
Copy the entire `timeattack` directory into:
`Ikemen_GO/external/mods/`

Ikemen GO will load the module automatically on startup.

### 2) Add the menu item to your screenpack
Add the below entry to your main `system.def` file, under **`[Title Info]`**, alongside other `menu.itemname.*` entries. Place it where you want it to be grouped/ordered in the menu (grouping rules: https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features#menus).
Without this, the mode won't show up in main menu.

```ini
[Title Info]
;New Time Attack Modes
menu.itemname.timeattackcoop = TIME ATTACK CO-OP
menu.itemname.server.netplaytimeattackcoop = TIME ATTACK CO-OP
````

## Screenpack / `system.def` defaults

The module includes its own `system.def` (next to the script) with **default values for the 720p ikemen1 motif**.

You can leave these defaults in the module or overwrite as your needs.
