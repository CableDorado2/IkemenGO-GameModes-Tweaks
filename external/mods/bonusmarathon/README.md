# Bonus Marathon Mode (I.K.E.M.E.N. GO Module)

***Bonus Marathon*** is a special challenge where player face multiple bonus characters consecutively and tries to beat their previous best score.

> [!NOTE]
> **Only characters with select.def "bonus = 1" parameter assigned are valid for this mode.**
>
>Includes a Co-Op and Netplay variant!
>This mode is detectable by [GameMode](https://github.com/ikemen-engine/Ikemen-GO/wiki/Triggers-(new)#gamemode) trigger as:
>- bonusmarathon
>- bonusmarathoncoop
>- netplaybonusmarathoncoop

## Installation

### 1) Install the module
Copy the entire `bonusmarathon` directory into:
`Ikemen_GO/external/mods/`

Ikemen GO will load the module automatically on startup.

### 2) Add the menu item to your screenpack
Add the below entry to your main `system.def` file, under **`[Title Info]`**, alongside other `menu.itemname.*` entries. Place it where you want it to be grouped/ordered in the menu (grouping rules: https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features#menus).
Without this, the mode won't show up in main menu.

```ini
[Title Info]
;Bonus Marathon Modes
menu.itemname.bonusmarathon = "BONUS MARATHON"
menu.itemname.bonusmarathoncoop = "BONUS MARATHON CO-OP"
menu.itemname.server.netplaybonusmarathoncoop = "BONUS MARATHON CO-OP"
````

## Screenpack / `system.def` defaults

The module includes its own `system.def` (next to the script) with **default values for the 720p ikemen1 motif**.

You can leave these defaults in the module or overwrite as your needs.

## `select.def` customization

### Limit the number of matches (optional)

Optionally set a maximum number of matches before Bonus Marathon ends:

```ini
[Characters]
; - bonus
;   IKEMEN feature: Set the paramvalue to 1 to include this character in Bonus Marathon mode.
;	At least 1 character needs this parameter for the mode to be playable.

[Options]
;Maximum number of normal and ratio matches to play before game ends in Bonus Marathon mode.
;Leave it empty to face all bonus characters (the "order" parameter is still respected).

bonusmarathon.maxmatches = 6,1,1,0,0,0,0,0,0,0
````
