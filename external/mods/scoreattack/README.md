# Score Attack Mode (I.K.E.M.E.N. GO Module)

***Score Attack*** is a special challenge where player fight multiple opponents consecutively and tries to beat their previous best score.

> [!NOTE]
> This mode is detectable by [GameMode](https://github.com/ikemen-engine/Ikemen-GO/wiki/Triggers-(new)#gamemode) trigger as:
> - scoreattack
> - scoreattackcoop
> - netplayscoreattackcoop

## Installation

### 1) Install the module
Copy the entire `scoreattack` directory into:
`Ikemen_GO/external/mods/`

Ikemen GO will load the module automatically on startup.

### 2) Add the menu item to your screenpack
Add the below entry to your main `system.def` file, under **`[Title Info]`**, alongside other `menu.itemname.*` entries. Place it where you want it to be grouped/ordered in the menu (grouping rules: https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features#menus).
Without this, the mode won't show up in main menu.

```ini
[Title Info]
;Score Attack Modes
menu.itemname.scoreattack = SCORE ATTACK
menu.itemname.scoreattackcoop = SCORE ATTACK CO-OP
menu.itemname.server.netplayscoreattackcoop = SCORE ATTACK CO-OP
````

## Screenpack / `system.def` defaults

The module includes its own `system.def` (next to the script) with **default values for the 720p ikemen1 motif**.

You can leave these defaults in the module or overwrite as your needs.

## `select.def` customization

### Limit the number of matches (optional)

Optionally set a maximum number of matches before Score Attack ends:

```ini
[Options]
;Maximum number of normal and ratio matches to fight before game ends in Score Attack mode.
;Leave it empty to fight all characters (the "order" parameter is still respected).

scoreattack.maxmatches = 6,1,1,0,0,0,0,0,0,0
````
