#include "TextEditor.h"
#include <string>

struct ColorTextEditorWrapper {
    TextEditor impl;
    std::string cached_text;
};

extern "C" {

ColorTextEditorWrapper* ColorTextEditorCreate() {
    auto* wrapper = new ColorTextEditorWrapper();

    wrapper->impl.SetLanguageDefinition(TextEditor::LanguageDefinition::Lua());
    wrapper->impl.SetPalette(TextEditor::GetDarkPalette());
    wrapper->impl.SetShowWhitespaces(false);
    
    return wrapper;
}

void ColorTextEditorDestroy(ColorTextEditorWrapper* wrapper) {
    delete wrapper;
}

bool ColorTextEditorDraw(ColorTextEditorWrapper* wrapper, const char* label, ImVec2 size) {
    wrapper->impl.Render(label, size, false);
    return wrapper->impl.IsTextChanged();
}

const char* ColorTextEditorGetText(ColorTextEditorWrapper* wrapper) {
    wrapper->cached_text = wrapper->impl.GetText();
    return wrapper->cached_text.c_str();
}

size_t ColorTextEditorGetLength(ColorTextEditorWrapper* wrapper) {
    return wrapper->impl.GetText().size();
}

void ColorTextEditorSetText(ColorTextEditorWrapper* wrapper, const char* text) {
    wrapper->impl.SetText(text);
}

void ColorTextEditorSetLanguage(ColorTextEditorWrapper* wrapper, const char* lang) {
    if (strcmp(lang, "Lua") == 0) 
        wrapper->impl.SetLanguageDefinition(TextEditor::LanguageDefinition::Lua());
    else if (strcmp(lang, "C++") == 0) 
        wrapper->impl.SetLanguageDefinition(TextEditor::LanguageDefinition::CPlusPlus());
    else if (strcmp(lang, "GLSL") == 0) 
        wrapper->impl.SetLanguageDefinition(TextEditor::LanguageDefinition::GLSL());
}

}