# Gallery Mode (I.K.E.M.E.N. GO Module)

This module allows add **Artworks**, **Storyboards** and **Music** to play in a customizable grid.

## Installation

### 1) Install the module
Copy the entire `gallery` directory into:
`Ikemen_GO/external/mods/`

Ikemen GO will load the module automatically on startup.

### 2) Add the menu item to your screenpack
Add the below entry to your main `system.def` file, under **`[Title Info]`**, alongside other `menu.itemname.*` entries. Place it where you want it to be grouped/ordered in the menu (grouping rules: https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features#menus).
Without this, the mode won't show up in main menu.

```ini
[Title Info]
;Gallery Mode
menu.itemname.gallery` = "GALLERY"
````

## Screenpack / `system.def` defaults

The module includes its own `galleryMenu.def` (next to the script) with **default values for the 720p ikemen1 motif**.

You can leave these defaults in the module or overwrite as your needs.

## `Item grid` customization

A dedicated:
[artworks.def](https://github.com/CableDorado2/IkemenGO-GameModes-Tweaks/blob/main/external/mods/gallery/artworks.def)
[storyboards.def](https://github.com/CableDorado2/IkemenGO-GameModes-Tweaks/blob/main/external/mods/gallery/storyboards.def)
[music.def](https://github.com/CableDorado2/IkemenGO-GameModes-Tweaks/blob/main/external/mods/gallery/music.def)
files are provided with instructions to setup and adding content to each gallery category.

## ARTWORK VIEWER COMMANDS 

When a image inside "Artworks" category is selected, player can control Artworks with the following customizable default keys:

- UP = Move the Image Up
- DOWN = Move the Image Down
- LEFT = Move the Image to the Left
- RIGHT = Move the Image to the Right
- W = Next Item
- D = Previous Item
- B / MENU = Return to Gallery Menu
- START = Hide UI (Affects **only** ArtViewerBG **layerno = 1**)
- Y = Zoom-In
- X = Zoom-Out
- A = Reset Position
- C = Slot Page Change (Not implemented yet)
