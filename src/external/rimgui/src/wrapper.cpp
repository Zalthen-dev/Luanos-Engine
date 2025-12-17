#include <raylib.h>
#include <raymath.h>
#include <string>

#include "imgui/imgui_internal.h"
#include "imgui/imgui.h"
#include "rlImGui/rlImGui.h"

#include "texteditor/texteditor.h"

/*

Compile with below line

g++ -shared -fPIC wrapper.cpp rlImGui/rlImGui.cpp imgui/imgui.cpp imgui/imgui_draw.cpp imgui/imgui_widgets.cpp imgui/imgui_tables.cpp imgui/imgui_demo.cpp texteditor/texteditor.h texteditor/texteditor.cpp -I. -Iimgui -IrlImGui -Iraylib/src -lraylib -o librimgui.so

*/

extern "C" {
    struct ImVec2_FFI { float x, y; };
    struct ImVec3_FFI { float x, y, z; };
    struct ImVec4_FFI { float x, y, z, w; };    

    const int IMGUI_WINDOWFLAGS_NONE                   = 0;
    const int IMGUI_WINDOWFLAGS_NO_TITLE_BAR           = 1 << 0;
    const int IMGUI_WINDOWFLAGS_NO_RESIZE              = 1 << 1;
    const int IMGUI_WINDOWFLAGS_NO_MOVE                = 1 << 2;
    const int IMGUI_WINDOWFLAGS_NO_SCROLLBAR           = 1 << 3;
    const int IMGUI_WINDOWFLAGS_NO_SCROLL_WITH_MOUSE   = 1 << 4;
    const int IMGUI_WINDOWFLAGS_NO_COLLAPSE            = 1 << 5;
    const int IMGUI_WINDOWFLAGS_ALWAYS_AUTO_RESIZE     = 1 << 6;
    const int IMGUI_WINDOWFLAGS_NO_BACKGROUND          = 1 << 7;
    const int IMGUI_WINDOWFLAGS_NO_SAVED_SETTINGS      = 1 << 8;
    const int IMGUI_WINDOWFLAGS_MENU_BAR               = 1 << 9;
    const int IMGUI_WINDOWFLAGS_HORIZONTAL_SCROLLBAR   = 1 << 10;
    const int IMGUI_WINDOWFLAGS_NO_FOCUS_ON_APPEARING  = 1 << 11;
    const int IMGUI_WINDOWFLAGS_NO_BRING_TO_FRONT_ON_FOCUS = 1 << 12;
    const int IMGUI_WINDOWFLAGS_ALWAYS_VERTICAL_SCROLLBAR   = 1 << 13;
    const int IMGUI_WINDOWFLAGS_ALWAYS_HORIZONTAL_SCROLLBAR = 1 << 14;
    const int IMGUI_WINDOWFLAGS_ALWAYS_USE_WINDOW_PADDING   = 1 << 15;
    const int IMGUI_WINDOWFLAGS_NO_NAV_INPUT           = 1 << 18;
    const int IMGUI_WINDOWFLAGS_NO_NAV_FOCUS           = 1 << 19;
    const int IMGUI_WINDOWFLAGS_NO_MOUSE_INPUT         = 1 << 20;
    const int IMGUI_WINDOWFLAGS_MENU_MODE              = 1 << 21;
    const int IMGUI_WINDOWFLAGS_NO_NAV                 = IMGUI_WINDOWFLAGS_NO_NAV_INPUT | IMGUI_WINDOWFLAGS_NO_NAV_FOCUS;

    const int IMGUI_TREENODEFLAGS_NONAVFOCUS = 1 << 27;
    const int IMGUI_TREENODEFLAGS_CLIPLABELFORTRAILINGBUTTON = 1 << 28;
    const int IMGUI_TREENODEFLAGS_UPSIDEDOWNARROW = 1 << 29;

    ImVec2_FFI cImVec2(float x, float y) {
        ImVec2_FFI v;
        v.x = x;
        v.y = y;
        return v;
    }

    void rImGuiSetup() {
        rlImGuiSetup(true);
    }

    void rImGuiShutdown() {
        rlImGuiShutdown();
    }

    void rImGuiBegin() {
        rlImGuiBegin();
    }

    void rImGuiEnd() {
        rlImGuiEnd();
    }

    void rImGuiDisableIO() {
        ImGuiIO& io = ImGui::GetIO();
        io.IniFilename = NULL;
    }

    void rImGuiEnableIO() {
        ImGuiIO& io = ImGui::GetIO();
        io.IniFilename = "imgui.ini";
    }

    void rImGui_ShowDemoWindow() {
        ImGui::ShowDemoWindow();
    }
    
    int GetID(const char* str) {
        return ImGui::GetID(str);
    }

    void Begin(const char* text, bool *p_open, int window_flags = 0) {
        ImGui::Begin(text, p_open, window_flags);
    }

    void End() {
        ImGui::End();
    }

    void Text(const char* text) {
        ImGui::Text(text);
    }

    void TextColored(ImVec4_FFI color, const char* text) {
        ImGui::TextColored(ImVec4(color.x, color.y, color.z, color.w), text);
    }

    void TextUnformatted(const char* text) {
        ImGui::TextUnformatted(text);
    }

    void TextDisabled(const char* text) {
        ImGui::TextDisabled(text);
    }

    void TextWrapped(const char* text) {
        ImGui::TextWrapped(text);
    }

    void LabelText(const char* label, const char* text) {
        ImGui::LabelText(label, text);
    }

    void BulletText(const char* text) {
        ImGui::BulletText(text);
    }

    bool Button(const char* label, ImVec2_FFI size) {
        return ImGui::Button(label, ImVec2(size.x, size.y));
    }

    bool SmallButton(const char* label) {
        return ImGui::SmallButton(label);
    }

    bool Checkbox(const char* label, bool* v) {
        return ImGui::Checkbox(label, v);
    }

    bool RadioButton(const char* label, bool active) {
        return ImGui::RadioButton(label, active);
    }

    void ProgressBar(float fraction, ImVec2_FFI size, const char* overlay) {
        ImGui::ProgressBar(fraction, ImVec2(size.x, size.y), overlay);
    }

    void Bullet() {
        ImGui::Bullet();
    }

    bool TextLink(const char* label) {
        return ImGui::TextLink(label);
    }

    void Spacing() {
        ImGui::Spacing();
    }

    void NewLine() {
        ImGui::NewLine();
    }

    void Separator() {
        ImGui::Separator();
    }

    void SeparatorText(const char* label) {
        ImGui::SeparatorText(label);
    }

    bool BeginCombo(const char* label, const char* preview_value, int flags) {
        return ImGui::BeginCombo(label, preview_value, flags);
    }
    
    void EndCombo() {
        ImGui::EndCombo();
    }

    bool DragFloat(const char* label, float* v, float v_speed, float v_min, float v_max, const char* format, int flags) {
        return ImGui::DragFloat(label, v, v_speed, v_min, v_max, format, flags);
    }

    bool DragInt(const char* label, int* v, float v_speed, int v_min, int v_max, const char* format, int flags) {
        return ImGui::DragInt(label, v, v_speed, v_min, v_max, format, flags);
    }

    bool SliderFloat(const char* label, float* v, float v_min, float v_max, const char* format, int flags) {
        return ImGui::SliderFloat(label, v, v_min, v_max, format, flags);
    }

    bool SliderInt(const char* label, int* v, int v_min, int v_max, const char* format, int flags) {
        return ImGui::SliderInt(label, v, v_min, v_max, format, flags);
    }

    bool InputFloat(const char* label, float* v, float step, float step_fast, const char* format, int flags) {
        return ImGui::InputFloat(label, v, step, step_fast, format, flags);
    }

    bool InputInt(const char* label, int* v, int step, int step_fast, int flags) {
        return ImGui::InputInt(label, v, step, step_fast, flags);
    }

    int TextResizeCallback(ImGuiInputTextCallbackData* data) {
        if (data->EventFlag == (1 << 18)) {
            std::string* str = reinterpret_cast<std::string*>(data->UserData);
            str->resize(data->BufTextLen + 1);
            data->Buf = str->data();
        }

        return 0;
    }

    bool InputText(const char* label, char* buf, int buf_size, int flags) {
        return ImGui::InputText(label, buf, buf_size, flags, 0, 0);
    }

    bool InputTextMultiline(const char* label, char* buf, int buf_size, ImVec2_FFI size, int flags) {
        return ImGui::InputTextMultiline(label, buf, buf_size, ImVec2(size.x, size.y), flags | (1 << 18), TextResizeCallback, buf);
    }

    bool InputTextWithHint(const char* label, const char* hint, char* buf, int buf_size, int flags) {
        return ImGui::InputTextWithHint(label, hint, buf, buf_size, flags, 0, 0);
    }

    bool ColorEdit4(const char* label, float col[4], int flags) {
        return ImGui::ColorEdit4(label, col, flags);
    }

    bool BeginMenu(const char* label) {
        return ImGui::BeginMenu(label);
    }

    void EndMenu() {
        return ImGui::EndMenu();
    }

    bool MenuItem(const char* label, const char* keybind) {
        return ImGui::MenuItem(label, keybind);
    }

    bool BeginMenuBar() {
        return ImGui::BeginMenuBar();
    }

    void EndMenuBar() {
        ImGui::EndMenuBar();
    }
    
    bool BeginMainMenuBar() {
        return ImGui::BeginMainMenuBar();
    }

    void EndMainMenuBar() {
        ImGui::EndMainMenuBar();
    }

    bool BeginPopupContextWindow() {
        return ImGui::BeginPopupContextWindow();
    }

    bool Selectable(const char* text) {
        return ImGui::Selectable(text);
    }

    void EndPopup() {
        ImGui::EndPopup();
    }

    bool TreeNode(const char* label) {
        return ImGui::TreeNode(label);
    }

    bool TreeNodeEx(const char* label, int flags) {
        return ImGui::TreeNodeEx(label, flags);
    }

    void TreePop() {
        ImGui::TreePop();
    }

    void SetNextWindowSize(ImVec2_FFI size, int condition) {
        ImGui::SetNextWindowSize(ImVec2(size.x, size.y), condition);
    }

    void SetNextWindowPos(ImVec2_FFI size, int condition) {
        ImGui::SetNextWindowPos(ImVec2(size.x, size.y), condition);
    }

    ImVec2_FFI GetWindowSize() {
        ImVec2 avail = ImGui::GetWindowSize();
        return cImVec2(avail.x, avail.y);
    }

    ImVec2_FFI GetContentRegionAvail() {
        ImVec2 avail = ImGui::GetContentRegionAvail();
        return cImVec2(avail.x, avail.y);
    }

    ImVec2_FFI CalcTextSize(const char* text) {
        ImVec2 size = ImGui::CalcTextSize(text);
        return cImVec2(size.x, size.y);
    }

    void SetCursorPosX(int x) {
        ImGui::SetCursorPosX(x);
    }

    void SetCursorPosY(int y) {
        ImGui::SetCursorPosY(y);
    }

    bool IsItemHovered(int flags) {
        return ImGui::IsItemHovered(flags);
    }

    bool IsItemClicked() {
        return ImGui::IsItemClicked();
    }

    bool IsAnyItemFocused() {
        return ImGui::IsAnyItemFocused();
    }

    void BeginTooltip() {
        ImGui::BeginTooltip();
    }

    void EndTooltip() {
        ImGui::EndTooltip();
    }

    bool BeginChild(const char str, ImVec2_FFI size, bool border, int flags) {
        return ImGui::BeginChild(str, ImVec2(size.x, size.y), border, flags);
    }

    void EndChild() {
        ImGui::EndChild();
    }
    
    bool BeginTabBar(const char* str, int flags) {
        return ImGui::BeginTabBar(str, flags);
    }

    void EndTabBar() {
        ImGui::EndTabBar();
    }

    bool BeginTabItem(const char* label, bool* p_open, int flags) {
        return ImGui::BeginTabItem(label, p_open, flags);
    }

    void EndTabItem() {
        ImGui::EndTabItem();
    }

    TextEditor* TextEditorCreate(int initialSize) {
        size_t initial_capacity = initialSize;
        return TextEditor_Create(initial_capacity);
    }

    void TextEditorDraw(TextEditor* textEditor, const char* label, ImVec2_FFI size, int flags) {
        TextEditor_Draw(textEditor, label, ImVec2(size.x, size.y), flags);
    }

    int TextEditorGetLength(TextEditor* textEditor) {
        return TextEditor_GetLength(textEditor);
    }

    const char* TextEditorGetText(TextEditor* textEditor) {
        return TextEditor_GetText(textEditor);
    }

    void TextEditorSetText(TextEditor* textEditor, const char* text) {
        TextEditor_SetText(textEditor, text);
    }

    void TextEditorDestroy(TextEditor* textEditor) {
        TextEditor_Destroy(textEditor);
    }
}