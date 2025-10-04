# Escape Blocks
Can be played at https://wojtekmal.itch.io/escape-blocks  

# Escape Blocks - Code Documentation

## 1. Project Overview

This document outlines the technical structure of **Escape Blocks**, a 2D puzzle-platformer game developed using the **Godot Engine**. The game is primarily written in **GDScript**, with a C++ component for procedural level generation.

The core gameplay mechanic involves navigating a player character to an exit. The unique twist is the ability to rotate the entire game world, which causes movable blocks to fall according to the new direction of gravity, creating new paths and blocking old ones.

## 2. Directory Structure

The project is organized within the `engine/` directory, which serves as the root of the Godot project.

- **`/engine/scripts/`**: Contains all the GDScript files that drive the game's logic. This is where the main gameplay mechanics, UI interactions, and entity behaviors are defined.

- **`/engine/scenes/`**: This is not a single directory, but a collection of directories that store Godot scenes (`.tscn` files).
    - **`/board_stuff/`**: Contains scenes for all interactive objects on the game board, such as `Player.tscn`, `MovingBlock8x8.tscn`, `Door.tscn`, and `Button.tscn`.
    - **`/levels/`**: Holds all the game levels. Each level is its own scene, typically inheriting from `LevelTemplate.tscn`. The levels are further organized into subdirectories by their creators.
    - **`/menu_stuff/`**, **`/hud_stuff/`**, **`/map_stuff/`**, **`/settings_stuff/`**: These directories contain scenes for the user interface, including the main menu, level selection map, in-game HUD, and settings panels.

- **`/engine/board_generator/`**: A command-line utility written in C++ for procedurally generating and solving game levels. It is a standalone tool and not part of the game's runtime.

- **`/engine/assets/`**: A collection of asset directories.
    - **`/textures/`**: Image files for sprites and UI elements.
    - **`/sound/`**: Audio files, including background music and sound effects.
    - **`/fonts/`**: Font files used for in-game text.
    - **`/shaders/`**: Custom GLSL shaders for visual effects.

- **`project.godot`**: The main Godot project file, which contains project settings, input mappings, and autoload script configurations.

## 3. Core Gameplay (GDScript)

The in-game logic is handled entirely by GDScript.

### `LevelTemplate.gd` - The Heart of the Level

This is the most important script, acting as a controller for each level.
- **Level Loading**: At startup, it procedurally spawns all game entities (player, blocks, etc.) based on the layout defined in a `TileMap` node named `Walls`. It can also parse a text-based representation of a level from its `walls_source` property, which is used for randomly generated levels.
- **Custom Physics**: The script implements its own grid-based physics. In `_physics_process`, it iterates through all `interacting_entities`, calculates their "gravity", and handles their falling behavior. It does not use Godot's built-in physics engine for the core block-falling mechanic.
- **Rotation Mechanic**: It manages the world rotation. When the player initiates a rotation, it smoothly animates all board elements and snaps them to their new grid positions upon completion in the `rotation_ended` function.

### Entities

Game objects like the player and blocks are `Area2D` based nodes. Their behavior is mostly orchestrated by the `LevelTemplate.gd` script, which directly updates their position and state.

- **`Player.gd`**: The player character is controlled like a simple platformer character, with left/right movement and jumping. The `LevelTemplate` script constrains its movement within the game world.
- **`Button.gd` & `Door.gd`**: These implement a simple circuit system. Buttons and doors are linked by being in the same group (e.g., "button 1", "door 1"). When all buttons of a specific "color" (ID) are pressed, the corresponding doors open. Doors can be configured to close again if a button is released.

### `global.gd` - Global State Manager

This is an autoloaded script that acts as a singleton, accessible from anywhere in the game.
- **Persistence**: It manages the game's state, including level progression, unlocked levels, and collected parts. It handles saving this data to a file (`global.dat`) and loading it back when the game starts.
- **Game Settings**: All player settings (e.g., audio volume, control preferences) are stored and managed here.
- **Level Data**: It contains a master dictionary of all levels, their scene paths, and metadata like unlock requirements.
- **Device Features**: It includes helper functions to detect the runtime environment, such as `is_mobile()`, and manages screen orientation on mobile devices.

## 4. Level Generation (C++)

For rapid creation of complex and solvable puzzles, the project includes a powerful C++ command-line tool located in `/engine/board_generator/`.

- **`Board.h`**: This header defines a `Board` class that represents the game's logic in C++. It can simulate rotations, apply gravity, and check for a solved state. It is highly optimized for performance.
- **Solver**: The tool has a built-in puzzle solver that uses Breadth-First Search (BFS) to find the optimal (shortest) solution for any given level layout. It uses a unique ID for each board state to avoid getting stuck in cycles.
- **Generation Process**: The `main.cpp` and `MEGA_RANDOM.cpp` files contain the logic for generating new levels. The process involves:
    1. Creating a random arrangement of blocks.
    2. Running the solver to see if the level is possible.
    3. Evaluating the solution's "interestingness" based on its length and complexity.
    4. Saving the most interesting levels to text files.

These text files can then be loaded into the game engine using the `LevelTemplate`'s `walls_source` property.

## 5. Scene and Asset Pipeline

- **Levels**: A new level is created by inheriting from `LevelTemplate.tscn`. The layout of static blocks, moving blocks, buttons, and the player start position is defined by placing tiles in the `Walls` `TileMap` node.
- **UI**: The user interface is built using Godot's standard Control nodes. Key UI scenes include:
    - `menu_2.tscn`: The main menu.
    - `level_map.tscn`: A traversable map for level selection.
    - `settings.tscn`: A tabbed menu for adjusting game settings.
- **Autoloads**: The project uses Godot's autoload feature to provide globally accessible functionality. `global.gd` is the most significant one, but it's also used for global music and sensor access.