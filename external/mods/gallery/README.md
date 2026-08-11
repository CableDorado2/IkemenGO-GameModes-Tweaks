# Gallery Mode (I.K.E.M.E.N. GO Module)

This module allows add Artworks, Storyboards and Music to play in a customizable grid.
During Artwork Viewer, player can control Artworks with the following customizable default keys:

Move Up = UP
Move Down = DOWN
Move Left = LEFT
Move Right = RIGHT
Next Item = W
Previous Item = D
Return to Gallery = B / MENU
Hide UI (Affects Layer 1 Only) = START
Zoom-In = Y
Zoom-Out = X
Reset Position = A
Slot Change = C (Not implemented yet)

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
