# Luanos Engine
<img src="repo/LuanosEngineCard.png"/>
<a href="https://discord.gg/xMPCsx3dNf" style="text-decoration:none;">
    <img src="https://img.shields.io/badge/Discord-5865F2?logo=discord&logoColor=white&style=for-the-badge" alt="Discord"/>
</a>

# Dependencies
1. [Zune](https://github.com/Scythe-Technology/zune)
2. [Raylib](https://github.com/raysan5/raylib)
3. [ImGui](https://github.com/ocornut/imgui)
4. [rlImGui](https://github.com/raylib-extras/rlImGui)

# Running Luanos Engine
### Linux
1. Install Zune
<br>Follow its installation instructions at https://github.com/Scythe-Technology/zune

2. Clone the Repository
```bash
git clone https://github.com/Zalthen-dev/Luanos-Engine.git
cd Luanos-Engine
```

3. Navigate to `src/external/rimgui/src`

4. Clone [imgui](https://github.com/ocornut/imgui) and [rlImGui](https://github.com/raylib-extras/rlImGui)
```bash
git clone https://github.com/ocornut/imgui.git
git clone https://github.com/raylib-extras/rlImGui.git
```

5. Compile to shared library
```bash
g++ -shared -fPIC wrapper.cpp rlImGui/rlImGui.cpp imgui/imgui.cpp imgui/imgui_draw.cpp imgui/imgui_widgets.cpp imgui/imgui_tables.cpp imgui/imgui_demo.cpp -I. -Iimgui -IrlImGui -Iraylib/src -lraylib -o librimgui.so
```

6. Drag `librimgui.so` into `src/external/rimgui/bin`

7. Run
```bash
zune run game
```
---
### Windows
Todo

# How to Use
As of right now, Lunaos Engine only runs one script when it starts up, that at `src/test.luau` which will change soon!
<br>You can edit this script to do what you want!

# How to Help
You can help out by using Luanos Engine and reporting any bugs you find!
<br> You can also request features to be added! Here or in the discord server!

If you know how to code, help out by creating pull requests to add and change code!
