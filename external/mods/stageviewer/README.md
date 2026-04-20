# Stage Viewer Mode (I.K.E.M.E.N. GO Module)

***Stage Viewer*** originally created by Yoshin222 for M.U.G.E.N (inspired from ***Project Justice: Rival Schools 2***) is a pre-loaded character that allows view the background graphics of each stage loaded and unlocked.

> [!NOTE]
> This mode is detectable by [GameMode](https://github.com/ikemen-engine/Ikemen-GO/wiki/Triggers-(new)#gamemode) trigger as:
> - stageviewer

## Installation

### 1) Install the module
Copy the entire `stageviewer` directory into:
`Ikemen_GO/external/mods/`

Ikemen GO will load the module automatically on startup.

### 2) Add the menu item to your screenpack
Add the below entry to your main `system.def` file, under **`[Title Info]`**, alongside other `menu.itemname.*` entries. Place it where you want it to be grouped/ordered in the menu (grouping rules: https://github.com/ikemen-engine/Ikemen-GO/wiki/Screenpack-features#menus).
Without this, the mode won't show up in main menu.

```ini
[Title Info]
;Stage Viewer Mode
menu.itemname.stageviewer = "STAGE VIEWER"
````

## Optional Screenpack / `system.def` customization

```ini
[Select Info]
title.stageviewer.text = "Stage Viewer"
````

```ini
[StageViewer Pause Menu] ;Custom Pause Menu
menu.itemname.back = "Continue"
menu.itemname.commandlist = 
menu.itemname.menuinput = "Button Config"
menu.itemname.menuinput.keyboard = "Key Config"
menu.itemname.menuinput.gamepad = "Joystick Config"
menu.itemname.menuinput.spacer = "-"
menu.itemname.menuinput.inputdefault = "Default"
menu.itemname.menuinput.back = "Back"
menu.itemname.characterchange = "Stage Change"
menu.itemname.exit = "Exit"
````

## BASIC COMMANDS 

This character can fly around the screen with the directional buttons
- A = displays a visual effect to help you track the current cursor position while the button is held
- B = disables the foreground layer
- C = disables the background layer
- X = reduces your movement speed
- Y = increases your movement speed
- Z = locks your position to the enemy character while the button is held. There's a config option
to turn the click sound upon input on or off. Can't be done against itself
