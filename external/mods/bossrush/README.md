# Boss Rush Mode Tweaks (I.K.E.M.E.N. GO Module)

Add the following Personal Improvements for [K4thos Boss Rush Module](https://github.com/ikemen-engine/modules/tree/main/external/mods/bossrush):

- Enables the "Here Comes a New Challenger" Intermission
- VS Screen Restored
- Adds Co-Op and Netplay Variant
- main.t_bossChars renamed to main.t_bossRushChars for planned Single Boss Fight variant like Bonus Games Mode

> [!NOTE]
> - **This module overwrites the [original](https://github.com/ikemen-engine/modules/tree/main/external/mods/bossrush) Boss Rush module**, so if you're using it, make a backup.
> - **Only characters with select.def "boss = 1" parameter assigned are valid for this mode.**
> - If boss characters are not detected, the Game Mode will not be playable.
> 
> This mode is detectable by [GameMode](https://github.com/ikemen-engine/Ikemen-GO/wiki/Triggers-(new)#gamemode) trigger as:
>- bossrush
>- bossrushcoop
>- netplaybossrushcoop

## Installation

### 1) Install the module
Copy the entire `bossrush` directory into:
`Ikemen_GO/external/mods/`

Ikemen GO will load the module automatically on startup.

### 2) Add the menu item to your screenpack
Add the below entry to your main `system.def` file, under **`[Title Info]`**, alongside other `menu.itemname.*` entries. Place it where you want it to be grouped/ordered in the menu (grouping rules: https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features#menus).
Without this, the mode won't show up in main menu.

```ini
[Title Info]
;Boss Rush Modes
menu.itemname.bossrush = BOSS RUSH
menu.itemname.bossrushcoop = BOSS RUSH CO-OP
menu.itemname.server.netplaybossrushcoop = BOSS RUSH CO-OP
````

## Screenpack / `system.def` defaults

The module includes its own `system.def` (next to the script) with **default values for the 720p ikemen1 motif**.

You can leave these defaults in the module or overwrite as your needs.

## `select.def` customization

### Limit the number of matches (optional)

Optionally set a maximum number of matches before Boss Rush ends:

```ini
[Characters]
; - boss
;   IKEMEN feature: Set the paramvalue to 1 to include this character in "Boss Rush" mode.
;   At least 1 character needs this parameter for the mode to be playable.

;Examples:
Suave Dude, stages/stageboss.def, boss=1, order=8
Gouki, boss=1, order=9, ai=8, hidden=1

[Options]
;Maximum number of normal and ratio matches to fight before game ends in Boss Rush mode.
;Leave it empty to fight all boss characters (the "order" parameter is still respected).

bossrush.maxmatches = 3,2,1,0,0,0,0,0,0,0
````
