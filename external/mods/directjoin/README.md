# Netplay Direct Join (I.K.E.M.E.N. GO Module)

***Netplay Direct Join*** restores **S-SIZE I.K.E.M.E.N.** netplay Guest/Client behavior, allowing Player 2 to enter an IP address and connect immediately to Player 1 (Host).

## Installation

### 1) Install the module
Copy the entire `directjoin` directory into:
`Ikemen_GO/external/mods/`

Ikemen GO will load the module automatically on startup.

### 2) Add the menu item to your screenpack
Add the below entry to your main `system.def` file, under **`[Title Info]`**, alongside other `menu.itemname.*` entries. Place it where you want it to be grouped/ordered in the menu (grouping rules: https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features#menus).
Without this, the mode won't show up in main menu.

```ini
[Title Info]
;Netplay Direct Join
menu.itemname.menunetwork.directjoin = DIRECT JOIN
````
