#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* ALPHA_TEST:
* - ALPHA_TEST__OFF
* - ALPHA_TEST__ON
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

precision mediump float;
precision highp int;
uniform highp sampler2D s_GlyphTexture;
#ifdef FONT_TYPE__MSDF
uniform highp vec4 GlyphCutoff;
uniform highp vec4 GlyphSmoothRadius;
#endif
uniform highp vec4 HudOpacity;
#ifdef FONT_TYPE__MSDF
uniform highp vec4 OutlineColor;
uniform highp vec4 OutlineCutoff;
uniform highp vec4 ShadowColor;
uniform highp vec4 ShadowOffset;
uniform highp vec4 ShadowSmoothRadius;
#endif
uniform highp vec4 TintColor;
in highp vec4 v_color0;
#ifndef FONT_TYPE__TRUE_TYPE
in highp vec4 v_linearClampBounds;
#endif
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
#if defined(ALPHA_TEST__OFF) && defined(FONT_TYPE__BITMAP)
    highp vec4 var_86cb1 = (v_color0 * texture(s_GlyphTexture, min(max(v_texcoord0, v_linearClampBounds.xy), v_linearClampBounds.zw))) * TintColor;
#endif
#if defined(ALPHA_TEST__OFF) && defined(FONT_TYPE__BITMAP_SMOOTH)
    highp vec4 var_86cb1 = (v_color0 * smoothstep(vec4(0.300000011920928955078125), vec4(0.5), texture(s_GlyphTexture, min(max(v_texcoord0, v_linearClampBounds.xy), v_linearClampBounds.zw)))) * TintColor;
#endif
#ifdef FONT_TYPE__MSDF
    highp vec2 var_b3742;
    if (GlyphSmoothRadius.x > 0.00095000001601874828338623046875)
#endif
#if defined(ALPHA_TEST__ON) && defined(FONT_TYPE__BITMAP)
    highp vec4 var_77356 = texture(s_GlyphTexture, min(max(v_texcoord0, v_linearClampBounds.xy), v_linearClampBounds.zw));
#endif
#if defined(ALPHA_TEST__ON) && defined(FONT_TYPE__BITMAP_SMOOTH)
    highp vec4 var_0a663 = texture(s_GlyphTexture, min(max(v_texcoord0, v_linearClampBounds.xy), v_linearClampBounds.zw));
    highp vec4 var_77356 = smoothstep(vec4(0.300000011920928955078125), vec4(0.5), var_0a663);
#endif
#if defined(ALPHA_TEST__ON) && defined(FONT_TYPE__TRUE_TYPE)
    highp vec4 var_77356 = texture(s_GlyphTexture, v_texcoord0);
#endif
#if defined(ALPHA_TEST__ON) && !defined(FONT_TYPE__MSDF)
    highp vec4 var_b580a = var_77356;
    if (var_b580a.w < 0.5)
#endif
#if defined(ALPHA_TEST__ON) || defined(FONT_TYPE__MSDF)
    {
#endif
#ifdef FONT_TYPE__MSDF
        var_b3742 = min(max(v_texcoord0, v_linearClampBounds.xy), v_linearClampBounds.zw);
#endif
#if defined(ALPHA_TEST__ON) && !defined(FONT_TYPE__MSDF)
        discard;
#endif
#if defined(ALPHA_TEST__ON) || defined(FONT_TYPE__MSDF)
    }
#endif
#ifdef FONT_TYPE__MSDF
    else
    {
        var_b3742 = v_texcoord0;
    }
    highp vec4 var_bc8c7 = texture(s_GlyphTexture, var_b3742);
#endif
#if defined(ALPHA_TEST__ON) && defined(FONT_TYPE__MSDF)
    if (var_bc8c7.w < 0.5)
    {
        discard;
    }
#endif
#ifdef FONT_TYPE__MSDF
    highp float var_63127 = max(min(var_bc8c7.x, var_bc8c7.y), min(max(var_bc8c7.x, var_bc8c7.y), var_bc8c7.z));
    highp vec4 var_fb92b = mix(OutlineColor, v_color0, vec4(smoothstep(max(0.0, GlyphCutoff.x - GlyphSmoothRadius.x), min(1.0, GlyphCutoff.x + GlyphSmoothRadius.x), var_63127)));
    highp vec4 var_46c40 = var_fb92b;
    highp float var_ae182 = smoothstep(max(0.0, OutlineCutoff.x - GlyphSmoothRadius.x), min(1.0, OutlineCutoff.x + GlyphSmoothRadius.x), var_63127);
    highp float var_5ab6f = var_46c40.w;
    highp vec4 var_87383 = vec4(var_fb92b.xyz, var_5ab6f * var_ae182);
    var_46c40 = var_87383;
    highp vec2 var_739a8 = floor(v_texcoord0 * vec2(16.0)) * 0.0625;
    highp vec4 var_bc321 = texture(s_GlyphTexture, clamp(v_texcoord0 - ShadowOffset.xy, var_739a8, var_739a8 + vec2(0.0625)));
    highp vec4 var_86cb1 = mix(vec4(ShadowColor.xyz, ShadowColor.w * smoothstep(max(0.0, OutlineCutoff.x - ShadowSmoothRadius.x), min(1.0, OutlineCutoff.x + ShadowSmoothRadius.x), var_bc321.w)), var_87383, vec4(var_ae182)) * TintColor;
#endif
#if defined(ALPHA_TEST__OFF) && defined(FONT_TYPE__TRUE_TYPE)
    highp vec4 var_86cb1 = (v_color0 * texture(s_GlyphTexture, v_texcoord0)) * TintColor;
#endif
#if defined(ALPHA_TEST__ON) && !defined(FONT_TYPE__MSDF)
    highp vec4 var_86cb1 = (v_color0 * var_77356) * TintColor;
#endif
    var_86cb1.w *= HudOpacity.x;
    bgfx_FragData0 = var_86cb1;
}
