# Score Challenge Mode Tweaks (I.K.E.M.E.N. GO Module)

Add the following Personal Improvements for [K4thos Score Challenge Module](https://github.com/ikemen-engine/modules/tree/main/external/mods/scorechallenge):

- Enables the "Here Comes a New Challenger" Intermission
- Score Record now is Saved in Ranking only if player wins
- Adds Co-Op and Netplay Variant

> [!NOTE]
> - **This module overwrites the [original](https://github.com/ikemen-engine/modules/tree/main/external/mods/scorechallenge) Score Challenge module**, so if you're using it, make a backup.
> 
> This mode is detectable by [GameMode](https://github.com/ikemen-engine/Ikemen-GO/wiki/Triggers-(new)#gamemode) trigger as:
>- scorechallenge
>- scorechallengecoop
>- netplayscorechallengecoop

## Installation

### 1) Install the module
Copy the entire `scorechallenge` directory into:
`Ikemen_GO/external/mods/`

Ikemen GO will load the module automatically on startup.

### 2) Add the menu item to your screenpack
Add the below entry to your main `system.def` file, under **`[Title Info]`**, alongside other `menu.itemname.*` entries. Place it where you want it to be grouped/ordered in the menu (grouping rules: https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features#menus).
Without this, the mode won't show up in main menu.

```ini
[Title Info]
;Score Challenge Modes
menu.itemname.scorechallenge = "SCORE CHALLENGE"
menu.itemname.scorechallengecoop = "SCORE CHALLENGE CO-OP"
menu.itemname.server.netplayscorechallengecoop = "SCORE CHALLENGE CO-OP"
````

## Screenpack / `system.def` defaults

The module includes its own `system.def` (next to the script) with **default values for the 720p ikemen1 motif**.

You can leave these defaults in the module or overwrite as your needs.