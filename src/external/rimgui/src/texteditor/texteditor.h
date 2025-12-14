#pragma once
#include "../imgui/imgui.h"

extern "C" {

struct TextEditor {
    ImVector<char> buffer;
    bool dirty;
};

TextEditor* TextEditor_Create(size_t initial_capacity);
void        TextEditor_Destroy(TextEditor* editor);

bool        TextEditor_Draw(
    TextEditor* editor,
    const char* label,
    ImVec2 size,
    ImGuiInputTextFlags flags
);

const char* TextEditor_GetText(TextEditor* editor);
size_t      TextEditor_GetLength(TextEditor* editor);
void        TextEditor_SetText(TextEditor* editor, const char* text);

}
