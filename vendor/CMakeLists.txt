cmake_minimum_required(VERSION 3.16)
project(EngineLib LANGUAGES CXX C)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(WIN32)
    add_compile_definitions(PLATFORM_DESKTOP BUILD_LIBTYPE_SHARED)
elseif(APPLE)
    add_compile_definitions(_GLFW_X11 PLATFORM_DESKTOP BUILD_LIBTYPE_SHARED)
elseif(UNIX)
    add_compile_definitions(_GLFW_X11 PLATFORM_DESKTOP BUILD_LIBTYPE_SHARED)
endif()

set(BUILD_SHARED_LIBS ON CACHE BOOL "" FORCE)

add_subdirectory(raylib)

file(GLOB imgui_SRC 				imgui/*.cpp imgui/*.h)
file(GLOB imgui_texteditor_SRC 		imgui_texteditor/*.cpp imgui_texteditor/*.h)
file(GLOB imgui_colortexteditor_SRC imgui_colortexteditor/*.cpp imgui_colortexteditor/*.h)
file(GLOB imguicolortextedit_SRC 	ImGuiColorTextEdit/*.cpp ImGuiColorTextEdit/*.h)
file(GLOB raylibgizmo_SRC 			raylib-gizmo/src/*.c raylib-gizmo/src/*.h)
file(GLOB raygui_SRC 				raygui/src/*.h)
file(GLOB rlimgui_SRC 				rlImGui/*.cpp rlImGui/*.h)

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

target_link_libraries(${PROJECT_NAME} PRIVATE raylib)

target_include_directories(${PROJECT_NAME} PRIVATE
    imgui
    imgui_texteditor
    imgui_colortexteditor
    ImGuiColorTextEdit
    raylib-gizmo/src
    raygui/src
    rlImGui
)
