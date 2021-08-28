# Xact
**Xact** is an unofficial open-source osu! port on lua using LÖVE2D framework.

## How to play?
### Playing from source
#### Windows
* Firstly you need to download an [LÖVE2D framework](https://love2d.org/).
* Then add LÖVE2D directory to path or copy all files from LÖVE2D to source directory.
* Go to the source folder and write `love.exe .` in command prompt.
* Also you can use any IDE that works with lua and LÖVE2D framework.

### Beatmaps
* You need to download beatmaps to play this game.
* You can get them from [osu! official website](https://osu.ppy.sh/) or any mirror like [bloodcat](https://chimu.moe/en/beatmaps).
* Download them, then move to `Songs` folder and make folder exact same name as `.osz` file and extract everything there.

### Skins
* Xact have already default skin (mixed by XAKCOH). If you don't like it, you can change to your favourite but do not delete default one.

### Settings
* If you want change game resolution then edit in `conf.lua` theese options: 
```lua
t.window.width = 1024
t.window.height = 600
```
* If you want change key bindings then open in `config.cfg` file then find `firstKey` and `secondKey` options.
* If you don't have `config.cfg` file then open Xact and that file will appear.

## Features
- Simple skin support
- Almost all beatmap support (execpt 2B maps)
- Hardrock, easy, doubletime, halftime, autoplay, relax mods
- Custom AR, CS, OD options

## TODO list (from most important to least important)
- [ ] Full slider support
- [ ] Spinner support
- [ ] Fix rendering
- [ ] Healthbar
- [ ] Proper scoring system
- [ ] Star calculation
- [ ] Combo colours support
- [ ] Proper doubletime and halftime (they're sounds like nightcore and daycore)
- [ ] Settings
- [ ] Full skin support
- [ ] Custom beatmap hitsound support
- [ ] Get rid of [imgui](https://github.com/ocornut/imgui) libary
- [ ] Maybe multiplayer support

## Issues
* If you have any error appeared then please write in that form:
```
OS:
How to get that error or bug:
Additional info (if required):
```

## Note
* Please keep in mind that this port is very very unstable and is very unoptimized.

## Screenshots
![Mainmenu](https://user-images.githubusercontent.com/50211092/131225126-862fd58d-2211-4c74-b626-043b4ad13996.png)
![Gameplay](https://user-images.githubusercontent.com/50211092/131225129-e0b58591-c3be-4ade-a34b-67e5d7b539a5.png)

## License
Xact is licensed under GNU General Public License v3.0. Full text you can find [here](https://github.com/edmundosik/Xact/blob/main/LICENSE).
