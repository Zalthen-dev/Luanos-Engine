--!strict
--!optimize 2
--!native

local ffi = zune.ffi;

local raylib = require("./raylib");

local void = ffi.types.void;
local int = ffi.types.i32;
local uint = ffi.types.u32;
local bool = ffi.types.u8;
local char = ffi.types.u8;
local float = ffi.types.float;
local cstring = ffi.types.pointer;
type int = number;
type uint = number;
type bool = number;
type float = number;
type cstring = string | buffer | FFIPointer;
type char = number;

local Vector2 = raylib.Vector2
local Color = raylib.Color
local Rectangle = raylib.Rectangle
local Image = raylib.Image
local GlyphInfo = raylib.GlyphInfo
local Font = raylib.Font
local RenderTexture2D = raylib.RenderTexture2D
local NPatchInfo = raylib.NPatchInfo
type Vector2 = raylib.Vector2
type Color = raylib.Color
type Rectangle = raylib.Rectangle
type Image = raylib.Image
type GlyphInfo = raylib.GlyphInfo
type Font = raylib.Font
type RenderTexture2D = raylib.RenderTexture2D
type NPatchInfo = raylib.NPatchInfo

local Texture = raylib.Texture
local Texture2D = raylib.Texture2D
local TextureCubemap = raylib.TextureCubemap
type Texture = raylib.Texture
type Texture2D = raylib.Texture2D
type TextureCubemap = raylib.TextureCubemap

local function fn(returns: any, args: { any })
    return {
        returns = returns,
        args = args,
    };
end

export type Fns = {
    GetFontDefault: () -> Font,
    LoadFont: (fileName: cstring) -> Font,
    LoadFontEx: (fileName: cstring, fontSize: int, codepoints: FFIPointer, codepointCount: int) -> Font,
    LoadFontFromImage: (image: Image, key: Color, firstChar: int) -> Font,
    LoadFontFromMemory: (fileType: cstring, fileData: FFIPointer, dataSize: int, fontSize: int, codepoints: FFIPointer, codepointCount: int) -> Font,
    IsFontValid: (font: Font) -> bool,
    LoadFontData: (fileData: FFIPointer, dataSize: int, fontSize: int, codepoints: FFIPointer, codepointCount: int, type_: int) -> FFIPointer,
    GenImageFontAtlas: (glyphs: FFIPointer, glyphRecs: FFIPointer, glyphCount: int, fontSize: int, padding: int, packMethod: int) -> Image,
    UnloadFontData: (glyphs: FFIPointer, glyphCount: int) -> (),
    UnloadFont: (font: Font) -> (),
    ExportFontAsCode: (font: Font, fileName: cstring) -> bool,

    DrawFPS: (posX: int, posY: int) -> (),
    DrawText: (text: cstring, posX: int, posY: int, fontSize: int, color: Color) -> (),
    DrawTextEx: (font: Font, text: cstring, position: Vector2, fontSize: float, spacing: float, tint: Color) -> (),
    DrawTextPro: (font: Font, text: cstring, position: Vector2, origin: Vector2, rotation: float, fontSize: float, spacing: float, tint: Color) -> (),
    DrawTextCodepoint: (font: Font, codepoint: int, position: Vector2, fontSize: float, tint: Color) -> (),
    DrawTextCodepoints: (font: Font, codepoints: FFIPointer, codepointCount: int, position: Vector2, fontSize: float, spacing: float, tint: Color) -> (),

    SetTextLineSpacing: (spacing: int) -> (),
    MeasureText: (text: cstring, fontSize: int) -> int,
    MeasureTextEx: (font: Font, text: cstring, fontSize: float, spacing: float) -> Vector2,
    GetGlyphIndex: (font: Font, codepoint: int) -> int,
    GetGlyphInfo: (font: Font, codepoint: int) -> GlyphInfo,
    GetGlyphAtlasRec: (font: Font, codepoint: int) -> Rectangle,

    LoadUTF8: (codepoints: FFIPointer, length: int) -> FFIPointer,
    UnloadUTF8: (text: cstring) -> (),
    LoadCodepoints: (text: cstring, count: FFIPointer) -> FFIPointer,
    UnloadCodepoints: (codepoints: FFIPointer) -> (),
    GetCodepointCount: (text: cstring) -> int,
    GetCodepoint: (text: cstring, codepointSize: FFIPointer) -> int,
    GetCodepointNext: (text: cstring, codepointSize: FFIPointer) -> int,
    GetCodepointPrevious: (text: cstring, codepointSize: FFIPointer) -> int,
    CodepointToUTF8: (codepoint: int, utf8Size: FFIPointer) -> FFIPointer,

    TextCopy: (dst: cstring, src: cstring) -> int,
    TextIsEqual: (text1: cstring, text2: cstring) -> bool,
    TextLength: (text: cstring) -> uint,
    TextFormat: (text: cstring) -> FFIPointer,
    TextSubtext: (text: cstring, position: int, length: int) -> FFIPointer,
    TextReplace: (text: cstring, replace: cstring, by: cstring) -> FFIPointer,
    TextInsert: (text: cstring, insert: cstring, position: int) -> FFIPointer,
    TextJoin: (textList: FFIPointer, count: int, delimiter: cstring) -> FFIPointer,
    TextSplit: (text: cstring, delimiter: char, count: FFIPointer) -> FFIPointer,
    TextAppend: (text: cstring, append: cstring, position: FFIPointer) -> (),
    TextFindIndex: (text: cstring, find: cstring) -> int,
    TextToUpper: (text: cstring) -> FFIPointer,
    TextToLower: (text: cstring) -> FFIPointer,
    TextToPascal: (text: cstring) -> FFIPointer,
    TextToSnake: (text: cstring) -> FFIPointer,
    TextToCamel: (text: cstring) -> FFIPointer,
    TextToInteger: (text: cstring) -> int,
    TextToFloat: (text: cstring) -> float,

    LoadImage: (fileName: cstring) -> Image,
    UnloadImage: (image: Image) -> (),

    LoadTexture: (fileName: cstring) -> Texture2D,
    LoadTextureFromImage: (image: Image) -> Texture2D,
    LoadTextureCubemap: (image: Image, layout: int) -> TextureCubemap,
    UnloadTexture: (texture: Texture2D) -> (),

    LoadRenderTexture: (width: int, height: int) -> (RenderTexture2D),
    UnloadRenderTexture: (texture: RenderTexture2D) -> (),

    DrawTexture: (texture: Texture2D, posX: int, posY: int, tint: Color) -> (),
    DrawTextureV: (texture: Texture2D, position: Vector2, tint: Color) -> (),
    DrawTextureEx: (texture: Texture2D, position: Vector2, rotation: float, scale: float, tint: Color) -> (),
    DrawTextureRec: (texture: Texture2D, source: Rectangle, position: Vector2, tint: Color) -> (),
    DrawTexturePro: (texture: Texture2D, source: Rectangle, dest: Rectangle, origin: Vector2, rotation: float, tint: Color) -> (),
    DrawTextureNPatch: (texture: Texture2D, nPatchInfo: NPatchInfo, dest: Rectangle, origin: Vector2, rotation: float, tint: Color) -> (),
};

return {
    def = {
        GetFontDefault = fn(Font, {}),
        LoadFont = fn(Font, { cstring }),
        LoadFontEx = fn(Font, { cstring, int, ffi.types.pointer, int }),
        LoadFontFromImage = fn(Font, { Image, Color, int }),
        LoadFontFromMemory = fn(Font, { cstring, ffi.types.pointer, int, int, ffi.types.pointer, int }),
        IsFontValid = fn(bool, { Font }),
        LoadFontData = fn(ffi.types.pointer, { ffi.types.pointer, int, int, ffi.types.pointer, int, int }),
        GenImageFontAtlas = fn(Image, { ffi.types.pointer, ffi.types.pointer, int, int, int, int }),
        UnloadFontData = fn(void, { ffi.types.pointer, int }),
        UnloadFont = fn(void, { Font }),
        ExportFontAsCode = fn(bool, { Font, cstring }),

        DrawFPS = fn(void, { int, int }),
        DrawText = fn(void, { cstring, int, int, int, Color }),
        DrawTextEx = fn(void, { Font, cstring, Vector2, float, float, Color }),
        DrawTextPro = fn(void, { Font, cstring, Vector2, Vector2, float, float, float, Color }),
        DrawTextCodepoint = fn(void, { Font, int, Vector2, float, Color }),
        DrawTextCodepoints = fn(void, { Font, ffi.types.pointer, int, Vector2, float, float, Color }),

        SetTextLineSpacing = fn(void, { int }),
        MeasureText = fn(int, { cstring, int }),
        MeasureTextEx = fn(Vector2, { Font, cstring, float, float }),
        GetGlyphIndex = fn(int, { Font, int }),
        GetGlyphInfo = fn(GlyphInfo, { Font, int }),
        GetGlyphAtlasRec = fn(Rectangle, { Font, int }),

        LoadUTF8 = fn(cstring, { ffi.types.pointer, int }),
        UnloadUTF8 = fn(void, { cstring }),
        LoadCodepoints = fn(ffi.types.pointer, { cstring, ffi.types.pointer }),
        UnloadCodepoints = fn(void, { ffi.types.pointer }),
        GetCodepointCount = fn(int, { cstring }),
        GetCodepoint = fn(int, { cstring, ffi.types.pointer }),
        GetCodepointNext = fn(int, { cstring, ffi.types.pointer }),
        GetCodepointPrevious = fn(int, { cstring, ffi.types.pointer }),
        CodepointToUTF8 = fn(cstring, { int, ffi.types.pointer }),

        TextCopy = fn(int, { cstring, cstring }),
        TextIsEqual = fn(bool, { cstring, cstring }),
        TextLength = fn(uint, { cstring }),
        TextFormat = fn(cstring, { cstring }),
        TextSubtext = fn(cstring, { cstring, int, int }),
        TextReplace = fn(cstring, { cstring, cstring, cstring }),
        TextInsert = fn(cstring, { cstring, cstring, int }),
        TextJoin = fn(cstring, { ffi.types.pointer, int, cstring }),
        TextSplit = fn(ffi.types.pointer, { cstring, char, ffi.types.pointer }),
        TextAppend = fn(void, { cstring, cstring, ffi.types.pointer }),
        TextFindIndex = fn(int, { cstring, cstring }),
        TextToUpper = fn(cstring, { cstring }),
        TextToLower = fn(cstring, { cstring }),
        TextToPascal = fn(cstring, { cstring }),
        TextToSnake = fn(cstring, { cstring }),
        TextToCamel = fn(cstring, { cstring }),
        TextToInteger = fn(int, { cstring }),
        TextToFloat = fn(float, { cstring }),

        LoadImage = fn(Image, { cstring }),
        UnloadImage = fn(void, { Image }),

        LoadTexture = fn(Texture, { cstring }),
        LoadTextureFromImage = fn(Texture, { Image }),
        LoadTextureCubemap = fn(TextureCubemap, {Image, int}),
        UnloadTexture = fn(void, { Texture }),

        LoadRenderTexture = fn(RenderTexture2D, {int, int}),
        UnloadRenderTexture = fn(void, {RenderTexture2D}),

        DrawTexture = fn(void, {Texture2D, int, int, Color}),
        DrawTextureV = fn(void, {Texture2D, Vector2, Color}),
        DrawTextureEx = fn(void, {Texture2D, Vector2, float, float, Color}),
        DrawTextureRec = fn(void, {Texture2D, Rectangle, Vector2, Color}),
        DrawTexturePro = fn(void, {Texture2D, Rectangle, Rectangle, Vector2, float, Color}),
        DrawTextureNPatch = fn(void, {Texture2D, NPatchInfo, Rectangle, Vector2, float, Color}),
    }
}