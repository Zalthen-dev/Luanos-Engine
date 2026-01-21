cmake_minimum_required(VERSION 3.16)
project(EngineLib LANGUAGES CXX C)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# build targets
file(GLOB imgui_SRC                 imgui/*.cpp imgui/*.h)
file(GLOB imgui_texteditor_SRC      imgui_texteditor/*.cpp imgui_texteditor/*.h)
file(GLOB imgui_colortexteditor_SRC imgui_colortexteditor/*.cpp imgui_colortexteditor/*.h)
file(GLOB imguicolortextedit_SRC    ImGuiColorTextEdit/*.cpp ImGuiColorTextEdit/*.h)
file(GLOB raylibgizmo_SRC           raylib-gizmo/src/*.c raylib-gizmo/src/*.h)
file(GLOB raygui_SRC                raygui/src/*.h)
file(GLOB rlimgui_SRC               rlImGui/*.cpp rlImGui/*.h)

add_library(${PROJECT_NAME} SHARED
    wrapper_imgui.cpp

    ${raylibgizmo_SRC}
    ${raygui_SRC}

    ${imgui_SRC}
    ${imgui_colortexteditor_SRC}
    ${imgui_texteditor_SRC}
    ${imguicolortextedit_SRC}
    ${rlimgui_SRC}
)

target_compile_definitions(${PROJECT_NAME} PRIVATE PLATFORM_DESKTOP)

# reduce the file size by trimming some stuff
target_link_options(${PROJECT_NAME} PRIVATE "-s" "-Wl,-s" "-Wl,--gc-sections")

set(BUILD_SHARED_LIBS ON CACHE BOOL "" FORCE)

# removed the global "add_subdirectory(raylib)" so we dont build raylib when we dont need to.

target_include_directories(${PROJECT_NAME} PRIVATE
    imgui
    imgui_texteditor
    imgui_colortexteditor
    ImGuiColorTextEdit
    raylib-gizmo/src
    raygui/src
    rlImGui
)

if(WIN32) # WINDOWS
    set(RAYLIB_DLL "${CMAKE_CURRENT_SOURCE_DIR}/../src/external/raylib/native/bin/raylib.dll")
    set(RAYLIB_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/raylib/src")
	
    if(NOT EXISTS "${RAYLIB_DLL}")
        message(FATAL_ERROR "raylib.dll not found (launch the engine to download it)")
    endif()

    target_include_directories(${PROJECT_NAME} PRIVATE "${RAYLIB_INCLUDE_DIR}")

    # Link against the dll
    target_link_libraries(${PROJECT_NAME} PRIVATE "${RAYLIB_DLL}")
	# Build statically
    target_link_options(${PROJECT_NAME} PRIVATE -static)
	
elseif(UNIX) # LINUX
    add_subdirectory(raylib)
    target_link_libraries(${PROJECT_NAME} PRIVATE raylib)
	
elseif(APPLE) # MACOS
    add_subdirectory(raylib)
    target_link_libraries(${PROJECT_NAME} PRIVATE raylib)
endif()
