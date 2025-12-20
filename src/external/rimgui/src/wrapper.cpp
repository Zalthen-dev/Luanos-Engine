#include <raylib.h>
#include <raymath.h>
#include <string>
#include <cstdint>

#include "imgui/imgui.h"
#include "rlImGui/rlImGui.h"
#include "imgui/imgui_internal.h"

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
        return {x, y};
    }

    ImVec4_FFI cImVec4(ImVec4 vec) {
        return {vec.x, vec.y, vec.z, vec.w};
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

    void rImGuiEnableDocking() {
        ImGui::GetIO().ConfigFlags |= ImGuiConfigFlags_DockingEnable;
    }

    void rImGuiDisableDocking() {
        ImGui::GetIO().ConfigFlags &= ImGuiConfigFlags_DockingEnable;
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

    void TextLinkOpenURL(const char* text, const char* link) {
        ImGui::TextLinkOpenURL(text, link);
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

    void SameLine() {
        ImGui::SameLine();
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

    void SetTooltip(const char* text) {
        ImGui::SetTooltip("%s", text);
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

    void igImage(unsigned int textureId, float width, float height) {
        ImGui::Image(
            (ImTextureID)(uintptr_t)textureId, 
            ImVec2(width, height)
        );
    }

    void igImageWithBg(unsigned int textureId, ImVec2_FFI size) {
        ImGui::ImageWithBg(
            (ImTextureRef)textureId, 
            ImVec2(size.x, size.y)
        );
    }

    ImGuiViewport* GetMainViewport() {
        return ImGui::GetMainViewport();
    }

    unsigned int DockSpaceOverViewport(int dockspace_id, void* viewport_id, int flags) {
        return ImGui::DockSpaceOverViewport(dockspace_id, (const ImGuiViewport*)viewport_id, (ImGuiDockNodeFlags)flags);
    }

    void* DockBuilderGetNode(unsigned int node_id) {
        return ImGui::DockBuilderGetNode(node_id);
    }

    unsigned int DockBuilderAddNode(unsigned int node_id, int flags) {
        return ImGui::DockBuilderAddNode(node_id, (ImGuiDockNodeFlags)flags);
    }

    void DockBuilderSetNodeSize(unsigned int node_id, ImVec2_FFI size) {
        ImGui::DockBuilderSetNodeSize(node_id, ImVec2(size.x, size.y));
    }

    unsigned int DockBuilderSplitNode(unsigned int node_id, int split_dir, float size_ratio_for_node_at_dir, unsigned int* out_id_at_dir, unsigned int* out_id_at_opposite_dir) {
        return ImGui::DockBuilderSplitNode(node_id, (ImGuiDir)split_dir, size_ratio_for_node_at_dir, out_id_at_dir, out_id_at_opposite_dir);
    }

    void DockBuilderDockWindow(const char* window_name, unsigned int node_id) {
        ImGui::DockBuilderDockWindow(window_name, node_id);
    }

    void DockBuilderFinish(unsigned int node_id) {
        ImGui::DockBuilderFinish(node_id);
    }

    // text editor
    // TODO: make it more customizable
    // like making it not only multi-line, and additional things

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

    // push & pop

    ImVec4_FFI GetStyleColor(int idx) {
        return cImVec4(ImGui::GetStyleColorVec4((ImGuiCol)idx));
    }

    void PushStyleColor(int style, ImVec4_FFI color) {
        ImGui::PushStyleColor((ImGuiCol)style, ImVec4(color.x, color.y, color.z, color.w));
    }

    void PopStyleColor(int count) {
        ImGui::PopStyleColor(count);
    }

    void PushStyleVarFloat(int idx, float val) {
        ImGui::PushStyleVar(idx, val);
    }

    void PushStyleVarVec2(int idx, ImVec2_FFI val) {
        ImGui::PushStyleVar(idx, ImVec2(val.x, val.y));
    }

    void PopStyleVar(int count) {
        ImGui::PopStyleVar(count);
    }

    void PushID(const char* str_id) {
        ImGui::PushID(str_id);
    }

    void PopID() {
        ImGui::PopID();
    }

    // get & set stuff

    ImVec2_FFI GetCursorScreenPos() {
        ImVec2 pos = ImGui::GetCursorScreenPos();
        return cImVec2(pos.x, pos.y);
    }

    void SetCursorPosX(int x) {
        ImGui::SetCursorPosX(x);
    }

    void SetCursorPosY(int y) {
        ImGui::SetCursorPosY(y);
    }

    float GetFrameHeight() {
        return ImGui::GetFrameHeight();
    }

    float GetScrollY() {
        return ImGui::GetScrollY();
    }

    float GetScrollMaxY() {
        return ImGui::GetScrollMaxY();
    }

    void SetScrollHereY(float center_y_ratio) {
        ImGui::SetScrollHereY(center_y_ratio);
    }

    void SetItemDefaultFocus() {
        ImGui::SetItemDefaultFocus();
    }

    ImVec2_FFI GetViewportSize(void* viewport) {
        ImVec2 sz = ((ImGuiViewport*)viewport)->Size;
        return cImVec2(sz.x, sz.y);
    }

    // checks
    bool IsItemClicked() {
        return ImGui::IsItemClicked();
    }

    bool IsItemDeactivatedAfterEdit() {
        return ImGui::IsItemDeactivatedAfterEdit();
    }

    bool IsItemToggledSelection() {
        return ImGui::IsItemToggledSelection();
    }

    bool IsItemToggledOpen() {
        return ImGui::IsItemToggledOpen();
    }
    
    bool IsAnyItemFocused() {
        return ImGui::IsAnyItemFocused();
    }

    bool igIsWindowFocused(int flags) {
        return ImGui::IsWindowFocused(flags);
    }

    bool IsWindowHovered(int flags) {
        return ImGui::IsWindowHovered((ImGuiHoveredFlags)flags);
    }
    
    bool IsAnyItemHovered() {
        return ImGui::IsAnyItemHovered();
    }

    bool IsItemHovered(int flags) {
        return ImGui::IsItemHovered((ImGuiHoveredFlags)flags);
    }

    bool IsItemActive() {
        return ImGui::IsItemActive();
    }

    bool IsMouseDoubleClicked(int button) {
        return ImGui::IsMouseDoubleClicked(button);
    }
    
    bool IsMouseDragging(int button, float lock_threshold) {
        return ImGui::IsMouseDragging(button, lock_threshold);
    }

    bool IsMouseReleased(int button) {
        return ImGui::IsMouseReleased(button);
    }

    // styles

    void SetStyleDark() {
        ImGui::StyleColorsDark();
    }

    void SetStyleLight() {
        ImGui::StyleColorsLight();
    }

    // thanks to MomoDeve
    // https://github.com/ocornut/imgui/issues/707#issuecomment-670976818
    void SetStyleVisualStudioDarkBlue() {
        constexpr auto ColorFromBytes = [](uint8_t r, uint8_t g, uint8_t b) {
            return ImVec4((float)r / 255.0f, (float)g / 255.0f, (float)b / 255.0f, 1.0f);
        };

        auto& style = ImGui::GetStyle();
        ImVec4* colors = style.Colors;

        const ImVec4 bgColor           = ColorFromBytes(37, 37, 38);
        const ImVec4 lightBgColor      = ColorFromBytes(82, 82, 85);
        const ImVec4 veryLightBgColor  = ColorFromBytes(90, 90, 95);

        const ImVec4 panelColor        = ColorFromBytes(51, 51, 55);
        const ImVec4 panelHoverColor   = ColorFromBytes(29, 151, 236);
        const ImVec4 panelActiveColor  = ColorFromBytes(0, 119, 200);

        const ImVec4 textColor         = ColorFromBytes(255, 255, 255);
        const ImVec4 textDisabledColor = ColorFromBytes(151, 151, 151);
        const ImVec4 borderColor       = ColorFromBytes(78, 78, 78);

        colors[ImGuiCol_Text]                 = textColor;
        colors[ImGuiCol_TextDisabled]         = textDisabledColor;
        colors[ImGuiCol_TextSelectedBg]       = panelActiveColor;
        colors[ImGuiCol_WindowBg]             = bgColor;
        colors[ImGuiCol_ChildBg]              = bgColor;
        colors[ImGuiCol_PopupBg]              = bgColor;
        colors[ImGuiCol_Border]               = borderColor;
        colors[ImGuiCol_BorderShadow]         = borderColor;
        colors[ImGuiCol_FrameBg]              = panelColor;
        colors[ImGuiCol_FrameBgHovered]       = panelHoverColor;
        colors[ImGuiCol_FrameBgActive]        = panelActiveColor;
        colors[ImGuiCol_TitleBg]              = bgColor;
        colors[ImGuiCol_TitleBgActive]        = bgColor;
        colors[ImGuiCol_TitleBgCollapsed]     = bgColor;
        colors[ImGuiCol_MenuBarBg]            = panelColor;
        colors[ImGuiCol_ScrollbarBg]          = panelColor;
        colors[ImGuiCol_ScrollbarGrab]        = lightBgColor;
        colors[ImGuiCol_ScrollbarGrabHovered] = veryLightBgColor;
        colors[ImGuiCol_ScrollbarGrabActive]  = veryLightBgColor;
        colors[ImGuiCol_CheckMark]            = panelActiveColor;
        colors[ImGuiCol_SliderGrab]           = panelHoverColor;
        colors[ImGuiCol_SliderGrabActive]     = panelActiveColor;
        colors[ImGuiCol_Button]               = panelColor;
        colors[ImGuiCol_ButtonHovered]        = panelHoverColor;
        colors[ImGuiCol_ButtonActive]         = panelHoverColor;
        colors[ImGuiCol_Header]               = panelColor;
        colors[ImGuiCol_HeaderHovered]        = panelHoverColor;
        colors[ImGuiCol_HeaderActive]         = panelActiveColor;
        colors[ImGuiCol_Separator]            = borderColor;
        colors[ImGuiCol_SeparatorHovered]     = borderColor;
        colors[ImGuiCol_SeparatorActive]      = borderColor;
        colors[ImGuiCol_ResizeGrip]           = bgColor;
        colors[ImGuiCol_ResizeGripHovered]    = panelColor;
        colors[ImGuiCol_ResizeGripActive]     = lightBgColor;
        colors[ImGuiCol_PlotLines]            = panelActiveColor;
        colors[ImGuiCol_PlotLinesHovered]     = panelHoverColor;
        colors[ImGuiCol_PlotHistogram]        = panelActiveColor;
        colors[ImGuiCol_PlotHistogramHovered] = panelHoverColor;
        colors[ImGuiCol_ModalWindowDimBg] = bgColor;
        colors[ImGuiCol_DragDropTarget]       = bgColor;
        colors[ImGuiCol_NavHighlight]         = bgColor;
        colors[ImGuiCol_DockingPreview]       = panelActiveColor;
        colors[ImGuiCol_Tab]                  = bgColor;
        colors[ImGuiCol_TabActive]            = panelActiveColor;
        colors[ImGuiCol_TabUnfocused]         = bgColor;
        colors[ImGuiCol_TabUnfocusedActive]   = panelActiveColor;
        colors[ImGuiCol_TabHovered]           = panelHoverColor;

        style.WindowRounding    = 0.0f;
        style.ChildRounding     = 0.0f;
        style.FrameRounding     = 0.0f;
        style.GrabRounding      = 0.0f;
        style.PopupRounding     = 0.0f;
        style.ScrollbarRounding = 0.0f;
        style.TabRounding       = 0.0f;
    }
}