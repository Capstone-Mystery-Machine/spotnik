![spotnik banner](./.assets/spotnik-banner.png)

> **Not the project you were looking for?** The backend for Spotnik is called _Fetchka_ and has [its own repository](https://github.com/Capstone-Mystery-Machine/fetchka).

## WINNING PROJECT OF PENN STATE HARRISBURG'S 2026 CAPSTONE DESIGN CONFERENCE!

![capstone-2026-win](./.assets/project-win.webp)

> https://www.psu.edu/news/harrisburg/story/harrisburg-students-awarded-2026-capstone-projects

## Overview

Spotnik allows end-users to point their mobile devices up at the sky to view satellites in orbit around them.

## Demonstrations

### Main Menu

https://github.com/user-attachments/assets/3267a362-cb3f-41a8-b372-051a63767c3f

> Scene Transition Chain of: Boot -> Main Menu Scene -> Viewer Scene

https://github.com/user-attachments/assets/d15aa002-e337-4d73-992a-18e907dc7e49

> Main Menu Planetoid Animation

### Viewer Scene

https://github.com/user-attachments/assets/3100e42a-9364-4f43-a6db-6ca98b571ed7

> Skybox Simulation

https://github.com/user-attachments/assets/c6df3be8-046d-4c5b-93e5-13bfdd897a51

> Satellite Simulation and Details

https://github.com/user-attachments/assets/8ff328f7-ef84-452c-a69d-0275db3c055b

> User Configurations Options via Options Menu

### User Input

https://github.com/user-attachments/assets/714fab70-e8fd-4cd2-9045-74281cbb9e4b

> Desktop Click'n'Drag Pan

https://github.com/user-attachments/assets/c3159b0c-e159-4823-9eff-51ebadd45d54

> Mobile Tap'n'Drag Pan

https://github.com/user-attachments/assets/b2ea9fbf-7309-4fd9-9ce0-55bd120efe96

> Mobile Motion Control Pan

## Assets Used

- Fonts
  - `fonts/ComicNeue-Bold.ttf` — https://fonts.google.com/specimen/Comic+Neue
  - `fonts/ComicNeue-Regular.ttf` — https://fonts.google.com/specimen/Comic+Neue
  - `fonts/JetBrainsMono-Bold.ttf` — https://fonts.google.com/specimen/JetBrains+Mono
  - `fonts/JetBrainsMono-BoldItalic.ttf` — https://fonts.google.com/specimen/JetBrains+Mono
  - `fonts/JetBrainsMono-ExtraBold.ttf` — https://fonts.google.com/specimen/JetBrains+Mono
  - `fonts/JetBrainsMono-ExtraBoldItalic.ttf` — https://fonts.google.com/specimen/JetBrains+Mono
  - `fonts/JetBrainsMono-ExtraLight.ttf` — https://fonts.google.com/specimen/JetBrains+Mono
  - `fonts/JetBrainsMono-ExtraLightItalic.ttf` — https://fonts.google.com/specimen/JetBrains+Mono
  - `fonts/JetBrainsMono-Italic.ttf` — https://fonts.google.com/specimen/JetBrains+Mono
  - `fonts/JetBrainsMono-Light.ttf` — https://fonts.google.com/specimen/JetBrains+Mono
  - `fonts/JetBrainsMono-LightItalic.ttf` — https://fonts.google.com/specimen/JetBrains+Mono
  - `fonts/JetBrainsMono-Medium.ttf` — https://fonts.google.com/specimen/JetBrains+Mono
  - `fonts/JetBrainsMono-MediumItalic.ttf` — https://fonts.google.com/specimen/JetBrains+Mono
  - `fonts/JetBrainsMono-Regular.ttf` — https://fonts.google.com/specimen/JetBrains+Mono
  - `fonts/JetBrainsMono-SemiBold.ttf` — https://fonts.google.com/specimen/JetBrains+Mono
  - `fonts/JetBrainsMono-SemiBoldItalic.ttf` — https://fonts.google.com/specimen/JetBrains+Mono
  - `fonts/JetBrainsMono-Thin.ttf` — https://fonts.google.com/specimen/JetBrains+Mono
  - `fonts/JetBrainsMono-ThinItalic.ttf` — https://fonts.google.com/specimen/JetBrains+Mono
  - `fonts/Michroma-Regular.ttf` — https://fonts.google.com/specimen/Michroma
- Icons
  - `textures/icon_gear_fill.svg` — https://phosphoricons.com
  - `textures/icon_x_light.svg` — https://phosphoricons.com
- Illustrations
  - `textures/illustration_rotate_device.svg` — https://thenounproject.com/icon/rotate-your-smartphone-1817993 _(CC BY 3.0, Berkah Icon)_
  - `textures/illustration_touch_screen.svg` — https://thenounproject.com/icon/touch-screen-1817999 _(CC BY 3.0, Berkah Icon)_
- Textures
  - `textures/skybox_nebulae_a.png` — https://tools.wwwtyro.net/space-3d/index.html

## Supported Platforms

- Android _(version unknown)_
- Linux _(version unknown)_
- macOS _(version unknown)_
- Windows _(version unknown)_

## Prerequisites

- [Godot 4.5.1](https://github.com/Capstone-Mystery-Machine/documentation-and-resources/issues/5)
- [Godot 4.5.1 Templates](https://github.com/Capstone-Mystery-Machine/documentation-and-resources/issues/5)
- [Git](https://github.com/Capstone-Mystery-Machine/documentation-and-resources/issues/1)
- [Git LFS](https://github.com/Capstone-Mystery-Machine/documentation-and-resources/issues/6)
- **(Optional)** [Android Development Tools](https://github.com/Capstone-Mystery-Machine/documentation-and-resources/issues/7)

## Development Installation

- Clone repository.
- Import repository in Godot IDE.
- Open repository in Godot IDE.

## Project Directory

- `addons/` — Contains any Godot / Godot IDE addons from the ecosystem.
- `data/` — Contains pre-built datasets. Mainly used for debug builds.
- `nodes/` — Contains general purpose, non-system specific `Node`s.
- `resources/` — Contains `Resource`-based `Node`s which are used for configuration of other `Node`s.
- `scenes/` — Contains primary scene files which are used as root scene `Node`s.
- `shaders/` — Contains GPU shaders for effects.
- `singletons/` — Contains application-wide APIs accessible from any script.
- `skyboxes/` — Contains `SkyboxSettings`-based configurations for different skyboxes the end-user can experience.
- `tasks/` — Contains bootstrap tasks that can be executed when switching between primary scenes.
- `textures/` — Contains binary and textual textures which as used as visuals in meshes and user interfaces.

## API Documentation

There is no pre-built documentation website. Please use Godot's built-in documentation browser to view custom APIs. Or, read the source code directly.

## Project Planner

Project road map and issue tracking are managed in Capstone Mystery Machine's [Project Planner](https://github.com/orgs/Capstone-Mystery-Machine/projects/3).
