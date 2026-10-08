# Shop Mode (I.K.E.M.E.N. GO Module)

***Item Shop*** is a dedicated menu to spend In-Game Currency and Unlock Content.
[![Alt text](https://i.ytimg.com/vi/fKo6Ag_lZO4/maxresdefault.jpg)](https://www.youtube.com/watch?v=fKo6Ag_lZO4)

> [!NOTE]
> - This module requires a [Currency System](https://github.com/CableDorado2/IkemenGO-GameModes-Tweaks/tree/main/external/mods/currency) module to work.
>
> - [Palette Select Plus+](https://github.com/dionednd/paletteselect-plus) module by dionednd, is recommended to setup characters palette/color unlocks.

> [!CAUTION]
> In Network/Netplay (Online Mode), as happens with Game Settings, a desynchronization may occur
> if the host and client have not unlocked the same content.
>
> Due to current engine limitations, to manage this case [netPlay()](https://github.com/ikemen-engine/Ikemen-GO/wiki/Lua#netplay) function has been added
> to the shop item examples that will temporarily cause the content to be unlocked
> (even if online partner has purchased it), only during online session.
>
> Following the engine's wiki recommendation:
> https://github.com/ikemen-engine/Ikemen-GO/wiki/Lua#example-allow-unlocks-during-netplay

## Installation

### 1) Install the module
Copy the entire `shop` directory into:
`Ikemen_GO/external/mods/`

Ikemen GO will load the module automatically on startup.

### 2) Add the menu item to your screenpack
Add the below entry to your main `system.def` file, under **`[Title Info]`**, alongside other `menu.itemname.*` entries. Place it where you want it to be grouped/ordered in the menu (grouping rules: https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features#menus).
Without this, the mode won't show up in main menu.

```ini
[Title Info]
;Shop Mode
menu.itemname.shop = SHOP
````

## Screenpack / `system.def` defaults

The module includes its own `shopMenu.def` (next to the script) with **default values for the 720p ikemen1 motif**.

You can leave these defaults in the module or overwrite as your needs.

## `items.def` customization

A dedicated [items.def](https://github.com/CableDorado2/IkemenGO-GameModes-Tweaks/blob/main/external/mods/shop/items.def) file is provided with instructions to setup and adding items to purchase.
