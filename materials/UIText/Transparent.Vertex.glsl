#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* ALPHA_TEST:
* - ALPHA_TEST__OFF (not used)
* - ALPHA_TEST__ON (not used)
*
* FONT_TYPE:
* - FONT_TYPE__BITMAP
* - FONT_TYPE__BITMAP_SMOOTH
* - FONT_TYPE__MSDF
* - FONT_TYPE__TRUE_TYPE
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_GlyphTexture;
*
* Uniforms:
* - uniform vec4 GlyphCutoff;
* - uniform vec4 GlyphHeight;
* - uniform vec4 GlyphSmoothRadius;
* - uniform vec4 HalfTexelOffset;
* - uniform vec4 HudOpacity;
* - uniform vec4 OutlineColor;
* - uniform vec4 OutlineCutoff;
* - uniform vec4 ShadowColor;
* - uniform vec4 ShadowOffset;
* - uniform vec4 ShadowSmoothRadius;
* - uniform vec4 TintColor;
*/

uniform mat4 u_modelViewProj;
#ifndef FONT_TYPE__TRUE_TYPE
uniform vec4 GlyphHeight;
#endif
#ifdef FONT_TYPE__MSDF
uniform vec4 GlyphSmoothRadius;
#endif
#ifndef FONT_TYPE__TRUE_TYPE
uniform vec4 HalfTexelOffset;
#endif
in vec4 a_color0;
in vec3 a_position;
in vec2 a_texcoord0;
out vec4 v_color0;
out vec4 v_linearClampBounds;
out vec2 v_texcoord0;
void main() {
#ifndef FONT_TYPE__TRUE_TYPE
    vec3 var_eede8 = a_position;
    vec2 var_36674 = a_texcoord0;
    vec2 var_6d827 = a_texcoord0;
    int var_05516 = int(var_eede8.z);
    var_6d827.x += (((var_05516 == 1) || (var_05516 == 2)) ? 0.0625 : 0.0);
    float var_c517f;
    if ((var_05516 == 0) || (var_05516 == 1))
    {
        var_c517f = GlyphHeight.x;
    }
    else
    {
        var_c517f = 0.0;
    }
    var_6d827.y += var_c517f;
    vec4 var_ac299 = vec4(0.0, 0.0, 1.0, 1.0);
#endif
#if defined(FONT_TYPE__BITMAP) || defined(FONT_TYPE__BITMAP_SMOOTH)
    vec2 var_71f06 = a_texcoord0 + vec2(HalfTexelOffset.x);
    var_ac299 = vec4(var_71f06.x, var_71f06.y, var_ac299.z, var_ac299.w);
    var_ac299.z = (var_36674.x + 0.0625) - HalfTexelOffset.x;
    var_ac299.w = (var_36674.y + GlyphHeight.x) - HalfTexelOffset.x;
#endif
#ifdef FONT_TYPE__MSDF
    if (GlyphSmoothRadius.x > 0.00095000001601874828338623046875)
    {
        vec2 var_a0fda = a_texcoord0 + vec2(HalfTexelOffset.x);
        var_ac299 = vec4(var_a0fda.x, var_a0fda.y, var_ac299.z, var_ac299.w);
        var_ac299.z = (var_36674.x + 0.0625) - HalfTexelOffset.x;
        var_ac299.w = (var_36674.y + GlyphHeight.x) - HalfTexelOffset.x;
    }
#endif
    v_color0 = a_color0;
#ifndef FONT_TYPE__TRUE_TYPE
    v_linearClampBounds = var_ac299;
    v_texcoord0 = var_6d827;
#endif
#ifdef FONT_TYPE__TRUE_TYPE
    v_linearClampBounds = vec4(0.0, 0.0, 1.0, 1.0);
    v_texcoord0 = a_texcoord0;
#endif
    gl_Position = u_modelViewProj * vec4(a_position.xy, 0.0, 1.0);
}
