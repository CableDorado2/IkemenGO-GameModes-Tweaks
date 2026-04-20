# Events Mode (I.K.E.M.E.N. GO Module)

***Event Match*** is a series of special challenges (inspired from ***[Super Smash Bros. Series](https://www.ssbwiki.com/Event_match)***) where player fight in custom matches. Beating all events clears the mode.

> [!NOTE]
> This mode is detectable by [GameMode](https://github.com/ikemen-engine/Ikemen-GO/wiki/Triggers-(new)#gamemode) trigger as the **id** assigned per event item via [events.def](https://github.com/CableDorado2/IkemenGO-GameModes-Tweaks/blob/main/external/mods/events/events.def)

## Installation

### 1) Install the module
Copy the entire `events` directory into:
`Ikemen_GO/external/mods/`

Ikemen GO will load the module automatically on startup.

### 2) Add the menu item to your screenpack
Add the below entry to your main `system.def` file, under **`[Title Info]`**, alongside other `menu.itemname.*` entries. Place it where you want it to be grouped/ordered in the menu (grouping rules: https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features#menus).
Without this, the mode won't show up in main menu.

```ini
[Title Info]
;Events Mode
menu.itemname.events = "EVENTS"
````

## Screenpack / `system.def` defaults

The module includes its own `eventsMenu.def` (next to the script) with **default values for the 720p ikemen1 motif**.

You can leave these defaults in the module or overwrite as your needs.

## `events.def` customization

A dedicated [events.def](https://github.com/CableDorado2/IkemenGO-GameModes-Tweaks/blob/main/external/mods/events/events.def) file is provided with instructions to setup and adding event matches.
