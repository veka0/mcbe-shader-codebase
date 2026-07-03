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
    vec2 var_b1f80 = a_texcoord0;
    int var_39b97 = int(var_eede8.z);
    var_b1f80.x += (((var_39b97 == 1) || (var_39b97 == 2)) ? 0.0625 : 0.0);
    var_b1f80.y += (((var_39b97 == 0) || (var_39b97 == 1)) ? 0.0625 : 0.0);
#endif
#if defined(FONT_TYPE__BITMAP) || defined(FONT_TYPE__BITMAP_SMOOTH)
    vec2 var_53a93 = a_texcoord0 + vec2(HalfTexelOffset.x);
    vec2 var_9e22a = (a_texcoord0 + vec2(0.0625)) - vec2(HalfTexelOffset.x);
#endif
#ifdef FONT_TYPE__MSDF
    vec4 var_3c82b;
    if (GlyphSmoothRadius.x > 0.00095000001601874828338623046875)
    {
        vec2 var_fad76 = a_texcoord0 + vec2(HalfTexelOffset.x);
        vec2 var_a5ea7 = (a_texcoord0 + vec2(0.0625)) - vec2(HalfTexelOffset.x);
        var_3c82b = vec4(var_fad76.x, var_fad76.y, var_a5ea7.x, var_a5ea7.y);
    }
    else
    {
        var_3c82b = vec4(0.0, 0.0, 1.0, 1.0);
    }
#endif
    v_color0 = a_color0;
#if defined(FONT_TYPE__BITMAP) || defined(FONT_TYPE__BITMAP_SMOOTH)
    v_linearClampBounds = vec4(var_53a93.x, var_53a93.y, var_9e22a.x, var_9e22a.y);
#endif
#ifdef FONT_TYPE__MSDF
    v_linearClampBounds = var_3c82b;
#endif
#ifndef FONT_TYPE__TRUE_TYPE
    v_texcoord0 = var_b1f80;
#endif
#ifdef FONT_TYPE__TRUE_TYPE
    v_linearClampBounds = vec4(0.0, 0.0, 1.0, 1.0);
    v_texcoord0 = a_texcoord0;
#endif
    gl_Position = u_modelViewProj * vec4(a_position.xy, 0.0, 1.0);
}
