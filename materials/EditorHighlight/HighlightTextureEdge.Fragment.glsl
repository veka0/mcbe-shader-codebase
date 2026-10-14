#version 310 es

/*
* Available Macros:
*
* Passes:
* - HIGHLIGHT_PASS (not used)
* - HIGHLIGHT_TEXTURE_EDGE_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_HighlightTextureColor;
* - uniform lowp sampler2D s_HighlightTextureDepth;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform lowp sampler2D s_SceneTextureColor;
* - uniform lowp sampler2D s_SceneTextureDepth;
* - uniform lowp sampler2D s_SelectedBlocksOverlayTexture;
*
* Uniforms:
* - uniform vec4 BlockEdgeColor;
* - uniform vec4 BlockEdgeThickness;
* - uniform vec4 CameraPosition;
* - uniform vec4 HiddenBlocksAlpha;
* - uniform vec4 HighlightAlpha;
* - uniform vec4 HighlightColor;
* - uniform mat4 InverseProjView;
* - uniform vec4 OutlineColor;
* - uniform vec4 OutlineWidth;
* - uniform vec4 OverlayTextureStretch;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 ScreenSize;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_HighlightTextureColor;
uniform highp sampler2D s_HighlightTextureDepth;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2D s_SceneTextureColor;
uniform highp sampler2D s_SceneTextureDepth;
uniform highp vec4 BlockEdgeColor;
uniform highp vec4 BlockEdgeThickness;
uniform highp vec4 HiddenBlocksAlpha;
uniform highp vec4 HighlightAlpha;
uniform highp vec4 HighlightColor;
uniform highp vec4 OutlineColor;
uniform highp vec4 OutlineWidth;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 ScreenSize;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_58cb8 = vec4(0.0);
    highp vec4 var_81d64 = texture(s_SceneTextureDepth, v_texcoord0);
    highp vec4 var_cc9c7 = texture(s_HighlightTextureDepth, v_texcoord0);
    highp vec4 var_6642e = texture(s_SceneTextureColor, v_texcoord0);
    highp vec4 var_fe5cb = texture(s_HighlightTextureColor, v_texcoord0);
    highp float var_df5e5;
    if (PreExposureEnabled.x != 0.0)
    {
        highp vec4 var_42699 = texelFetch(s_PreviousFrameAverageLuminance, ivec2(0), 0);
        highp float var_a5230 = var_42699.x;
        highp vec4 var_6be21 = var_6642e;
        highp vec3 var_9ad2d = var_6be21.xyz / vec3((0.180000007152557373046875 / var_a5230) + 9.9999997473787516355514526367188e-05);
        var_6642e.x = var_9ad2d.x;
        var_6642e.y = var_9ad2d.y;
        var_6642e.z = var_9ad2d.z;
        highp vec4 var_372dd = var_fe5cb;
        highp vec3 var_78d5c = var_372dd.xyz / vec3((0.180000007152557373046875 / var_a5230) + 9.9999997473787516355514526367188e-05);
        var_fe5cb.x = var_78d5c.x;
        var_fe5cb.y = var_78d5c.y;
        var_fe5cb.z = var_78d5c.z;
        var_df5e5 = var_a5230;
    }
    else
    {
        var_df5e5 = 1.0;
    }
    highp vec2 var_38c42 = vec2(OutlineWidth.x) * ScreenSize.zw;
    highp mat3 var_52c44;
    var_52c44[0].x = texture(s_HighlightTextureColor, v_texcoord0 + (vec2(-1.0) * var_38c42)).w;
    var_52c44[0].y = texture(s_HighlightTextureColor, v_texcoord0 + (vec2(-1.0, 0.0) * var_38c42)).w;
    var_52c44[0].z = texture(s_HighlightTextureColor, v_texcoord0 + (vec2(-1.0, 1.0) * var_38c42)).w;
    var_52c44[1].x = texture(s_HighlightTextureColor, v_texcoord0 + (vec2(0.0, -1.0) * var_38c42)).w;
    var_52c44[1].y = 0.0;
    var_52c44[1].z = texture(s_HighlightTextureColor, v_texcoord0 + (vec2(0.0, 1.0) * var_38c42)).w;
    var_52c44[2].x = texture(s_HighlightTextureColor, v_texcoord0 + (vec2(1.0, -1.0) * var_38c42)).w;
    var_52c44[2].y = texture(s_HighlightTextureColor, v_texcoord0 + (vec2(1.0, 0.0) * var_38c42)).w;
    var_52c44[2].z = texture(s_HighlightTextureColor, v_texcoord0 + var_38c42).w;
    highp float var_dc084 = dot(vec3(1.0, 2.0, 1.0), ceil(var_52c44[0])) + dot(vec3(-1.0, -2.0, -1.0), ceil(var_52c44[2]));
    highp float var_1f370 = (dot(vec3(1.0, 0.0, -1.0), ceil(var_52c44[0])) + dot(vec3(2.0, 0.0, -2.0), ceil(var_52c44[1]))) + dot(vec3(1.0, 0.0, -1.0), ceil(var_52c44[2]));
    highp vec2 var_bc243 = ScreenSize.zw * vec2(BlockEdgeThickness.x);
    highp vec4 var_baa2d = texture(s_HighlightTextureDepth, v_texcoord0);
    highp vec4 var_36aa8 = texture(s_HighlightTextureDepth, v_texcoord0 + (vec2(-1.0, 0.0) * var_bc243));
    highp vec4 var_54016 = texture(s_HighlightTextureDepth, v_texcoord0 + (vec2(1.0, 0.0) * var_bc243));
    highp vec4 var_f21da = texture(s_HighlightTextureDepth, v_texcoord0 + (vec2(0.0, -1.0) * var_bc243));
    highp vec4 var_38d96 = texture(s_HighlightTextureDepth, v_texcoord0 + (vec2(0.0, 1.0) * var_bc243));
    highp float var_8d11c = (var_baa2d.x * 9999.0) + 1.0;
    highp float var_18659 = dot(vec3(-1.0, 2.0, -1.0), vec3((var_36aa8.x * 9999.0) + 1.0, var_8d11c, (var_54016.x * 9999.0) + 1.0));
    highp float var_f4d79 = dot(vec3(-1.0, 2.0, -1.0), vec3((var_f21da.x * 9999.0) + 1.0, var_8d11c, (var_38d96.x * 9999.0) + 1.0));
    highp vec3 var_d9eae = mix(mix(mix(var_fe5cb.xyz, HighlightColor.xyz, vec3(HighlightColor.w)), var_6642e.xyz, vec3(HighlightAlpha.x)), BlockEdgeColor.xyz, vec3(float(sqrt((var_18659 * var_18659) + (var_f4d79 * var_f4d79)) > 0.00999999977648258209228515625) * BlockEdgeColor.w));
    if ((var_cc9c7.x + 1.1999999571798980468884110450745e-07) < 1.0)
    {
        if ((var_cc9c7.x - 1.1999999571798980468884110450745e-07) <= var_81d64.x)
        {
            var_58cb8 = vec4(var_d9eae, HighlightAlpha.x);
        }
        else
        {
            highp vec4 var_80fee = mix(var_6642e, vec4(OutlineColor.xyz, var_6642e.w), vec4(sqrt((var_dc084 * var_dc084) + (var_1f370 * var_1f370)) * OutlineColor.w));
            var_58cb8 = var_80fee;
            highp vec3 var_79998 = mix(var_80fee.xyz, var_d9eae, vec3(HiddenBlocksAlpha.x));
            var_58cb8.x = var_79998.x;
            var_58cb8.y = var_79998.y;
            var_58cb8.z = var_79998.z;
        }
    }
    else
    {
        var_58cb8 = var_6642e;
    }
    if (PreExposureEnabled.x != 0.0)
    {
        highp vec4 var_2a4ae = var_58cb8;
        highp vec3 var_39d81 = var_2a4ae.xyz * ((0.180000007152557373046875 / var_df5e5) + 9.9999997473787516355514526367188e-05);
        var_58cb8.x = var_39d81.x;
        var_58cb8.y = var_39d81.y;
        var_58cb8.z = var_39d81.z;
    }
    bgfx_FragData0 = var_58cb8;
}
