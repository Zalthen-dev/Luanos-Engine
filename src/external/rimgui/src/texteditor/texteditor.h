#pragma once
#include "../imgui/imgui.h"
#include <cstring>

extern "C" {

struct CustomTextEditor {
    ImVector<char> buffer;
    bool dirty;
};

CustomTextEditor* TextEditor_Create(size_t initial_capacity);
void        TextEditor_Destroy(CustomTextEditor* editor);

bool        TextEditor_Draw(
    CustomTextEditor* editor,
    const char* label,
    ImVec2 size,
    ImGuiInputTextFlags flags
);

const char* TextEditor_GetText(CustomTextEditor* editor);
size_t      TextEditor_GetLength(CustomTextEditor* editor);
void        TextEditor_SetText(CustomTextEditor* editor, const char* text);

}
