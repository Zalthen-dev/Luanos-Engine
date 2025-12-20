#include "texteditor.h"

static int TextEditor_Callback(ImGuiInputTextCallbackData* data) {
    if (data->EventFlag == ImGuiInputTextFlags_CallbackResize) {
        auto* editor = (TextEditor*)data->UserData;
        editor->buffer.resize(data->BufTextLen + 1);
        data->Buf = editor->buffer.Data;
    }
    return 0;
}

TextEditor* TextEditor_Create(size_t initial_capacity) {
    auto* editor = new TextEditor();
    editor->buffer.resize(initial_capacity);
    editor->buffer[0] = '\0';
    editor->dirty = false;
    return editor;
}

void TextEditor_Destroy(TextEditor* editor) {
    delete editor;
}

bool TextEditor_Draw(TextEditor* editor, const char* label, ImVec2 size, ImGuiInputTextFlags flags) {
    flags |= ImGuiInputTextFlags_CallbackResize;
    
    bool changed = false;

    if ((flags & (1 << 26)) != 0) {
        changed = ImGui::InputTextMultiline(
            label,
            editor->buffer.Data,
            editor->buffer.Size,
            size,
            flags,
            TextEditor_Callback,
            editor
        );
    } else {
        changed = ImGui::InputText(
            label,
            editor->buffer.Data,
            editor->buffer.Size,
            flags,
            TextEditor_Callback,
            editor
        );
    }

    editor->dirty |= changed;
    return changed;
}

const char* TextEditor_GetText(TextEditor* editor) {
    return editor->buffer.Data;
}

size_t TextEditor_GetLength(TextEditor* editor) {
    return strlen(editor->buffer.Data);
}

void TextEditor_SetText(TextEditor* editor, const char* text) {
    size_t len = strlen(text);
    editor->buffer.resize(len + 1);
    memcpy(editor->buffer.Data, text, len + 1);
}
