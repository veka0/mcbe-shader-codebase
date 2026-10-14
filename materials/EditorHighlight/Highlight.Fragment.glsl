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
uniform highp mat4 InverseProjView;
uniform highp sampler2D s_HighlightTextureColor;
uniform highp sampler2D s_HighlightTextureDepth;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2D s_SceneTextureColor;
uniform highp sampler2D s_SceneTextureDepth;
uniform highp sampler2D s_SelectedBlocksOverlayTexture;
uniform highp vec4 BlockEdgeColor;
uniform highp vec4 BlockEdgeThickness;
uniform highp vec4 CameraPosition;
uniform highp vec4 HiddenBlocksAlpha;
uniform highp vec4 HighlightAlpha;
uniform highp vec4 HighlightColor;
uniform highp vec4 OutlineColor;
uniform highp vec4 OutlineWidth;
uniform highp vec4 OverlayTextureStretch;
uniform highp vec4 PreExposureEnabled;
uniform highp vec4 ScreenSize;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_93128 = vec4(0.0);
    highp vec4 var_81d64 = texture(s_SceneTextureDepth, v_texcoord0);
    highp vec4 var_b0955 = texture(s_HighlightTextureDepth, v_texcoord0);
    highp vec4 var_fd987 = texture(s_SceneTextureColor, v_texcoord0);
    highp vec4 var_b4fb3 = texture(s_HighlightTextureColor, v_texcoord0);
    highp vec4 var_a244b = var_b4fb3;
    highp vec4 var_a4aca = vec4((v_texcoord0 * 2.0) - vec2(1.0), var_b0955.x, 1.0);
    var_a4aca.y = -var_a4aca.y;
    highp vec4 var_82e3c = InverseProjView * var_a4aca;
    highp vec4 var_04842 = var_82e3c;
    highp float var_b5d53 = var_04842.w;
    highp vec3 var_3948e = var_82e3c.xyz / vec3(var_b5d53);
    var_04842.x = var_3948e.x;
    var_04842.y = var_3948e.y;
    var_04842.z = var_3948e.z;
    highp vec3 var_cd3dd = var_04842.xyz + CameraPosition.xyz;
    highp vec2 var_20eb5 = v_texcoord0 + (vec2(-1.0, 0.0) * ScreenSize.zw);
    highp vec2 var_30e7c = v_texcoord0 + (vec2(0.0, -1.0) * ScreenSize.zw);
    highp vec4 var_219a5 = vec4((var_20eb5 * 2.0) - vec2(1.0), texture(s_HighlightTextureDepth, var_20eb5).x, 1.0);
    var_219a5.y = -var_219a5.y;
    highp vec4 var_a1763 = InverseProjView * var_219a5;
    highp vec4 var_2001d = var_a1763;
    highp float var_a538e = var_2001d.w;
    highp vec3 var_cce88 = var_a1763.xyz / vec3(var_a538e);
    var_2001d.x = var_cce88.x;
    var_2001d.y = var_cce88.y;
    var_2001d.z = var_cce88.z;
    highp vec4 var_0ead0 = vec4((v_texcoord0 * 2.0) - vec2(1.0), texture(s_HighlightTextureDepth, v_texcoord0).x, 1.0);
    var_0ead0.y = -var_0ead0.y;
    highp vec4 var_11537 = InverseProjView * var_0ead0;
    highp vec4 var_0e44a = var_11537;
    highp float var_edd16 = var_0e44a.w;
    highp vec3 var_64d4f = var_11537.xyz / vec3(var_edd16);
    var_0e44a.x = var_64d4f.x;
    var_0e44a.y = var_64d4f.y;
    var_0e44a.z = var_64d4f.z;
    highp vec4 var_3e640 = vec4((var_30e7c * 2.0) - vec2(1.0), texture(s_HighlightTextureDepth, var_30e7c).x, 1.0);
    var_3e640.y = -var_3e640.y;
    highp vec4 var_fec3b = InverseProjView * var_3e640;
    highp vec4 var_55d86 = var_fec3b;
    highp float var_21284 = var_55d86.w;
    highp vec3 var_c29d7 = var_fec3b.xyz / vec3(var_21284);
    var_55d86.x = var_c29d7.x;
    var_55d86.y = var_c29d7.y;
    var_55d86.z = var_c29d7.z;
    highp vec3 var_657ac = round(normalize(cross(var_2001d.xyz - var_0e44a.xyz, var_55d86.xyz - var_0e44a.xyz)) * 10.0) * vec3(0.100000001490116119384765625);
    highp vec4 var_2975e = texture(s_SelectedBlocksOverlayTexture, fract((((var_cd3dd.zy * var_657ac.x) + (var_cd3dd.xz * var_657ac.y)) + (var_cd3dd.xy * var_657ac.z)) / vec2(OverlayTextureStretch.x)));
    highp vec4 var_1e153 = var_2975e;
    highp vec3 var_fcdef = mix(var_b4fb3.xyz, var_2975e.xyz, vec3(var_1e153.w));
    var_a244b.x = var_fcdef.x;
    var_a244b.y = var_fcdef.y;
    var_a244b.z = var_fcdef.z;
    highp vec4 var_72455 = var_a244b;
    highp float var_df5e5;
    if (PreExposureEnabled.x != 0.0)
    {
        highp vec4 var_42699 = texelFetch(s_PreviousFrameAverageLuminance, ivec2(0), 0);
        highp float var_a5230 = var_42699.x;
        highp vec4 var_6be21 = var_fd987;
        highp vec3 var_9ad2d = var_6be21.xyz / vec3((0.180000007152557373046875 / var_a5230) + 9.9999997473787516355514526367188e-05);
        var_fd987.x = var_9ad2d.x;
        var_fd987.y = var_9ad2d.y;
        var_fd987.z = var_9ad2d.z;
        highp vec4 var_372dd = var_72455;
        highp vec3 var_78d5c = var_372dd.xyz / vec3((0.180000007152557373046875 / var_a5230) + 9.9999997473787516355514526367188e-05);
        var_72455.x = var_78d5c.x;
        var_72455.y = var_78d5c.y;
        var_72455.z = var_78d5c.z;
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
    highp float var_5bca1 = dot(vec3(1.0, 2.0, 1.0), ceil(var_52c44[0])) + dot(vec3(-1.0, -2.0, -1.0), ceil(var_52c44[2]));
    highp float var_ddda2 = (dot(vec3(1.0, 0.0, -1.0), ceil(var_52c44[0])) + dot(vec3(2.0, 0.0, -2.0), ceil(var_52c44[1]))) + dot(vec3(1.0, 0.0, -1.0), ceil(var_52c44[2]));
    highp float var_6c8df = sqrt((var_5bca1 * var_5bca1) + (var_ddda2 * var_ddda2));
    highp vec4 var_2320a = var_72455;
    highp vec4 var_a3114 = HighlightColor;
    highp vec4 var_bdd7e = OutlineColor;
    highp vec2 var_bc243 = ScreenSize.zw * vec2(BlockEdgeThickness.x);
    highp vec4 var_baa2d = texture(s_HighlightTextureDepth, v_texcoord0);
    highp vec4 var_36aa8 = texture(s_HighlightTextureDepth, v_texcoord0 + (vec2(-1.0, 0.0) * var_bc243));
    highp vec4 var_54016 = texture(s_HighlightTextureDepth, v_texcoord0 + (vec2(1.0, 0.0) * var_bc243));
    highp vec4 var_f21da = texture(s_HighlightTextureDepth, v_texcoord0 + (vec2(0.0, -1.0) * var_bc243));
    highp vec4 var_38d96 = texture(s_HighlightTextureDepth, v_texcoord0 + (vec2(0.0, 1.0) * var_bc243));
    highp float var_8d11c = (var_baa2d.x * 9999.0) + 1.0;
    highp float var_2d529 = dot(vec3(-1.0, 2.0, -1.0), vec3((var_36aa8.x * 9999.0) + 1.0, var_8d11c, (var_54016.x * 9999.0) + 1.0));
    highp float var_18d36 = dot(vec3(-1.0, 2.0, -1.0), vec3((var_f21da.x * 9999.0) + 1.0, var_8d11c, (var_38d96.x * 9999.0) + 1.0));
    highp vec3 var_e4f8c = mix(mix(mix(var_fd987.xyz, mix(var_72455.xyz, HighlightColor.xyz, vec3(var_a3114.w)), vec3(var_2320a.w * HighlightAlpha.x)), OutlineColor.xyz, vec3(var_6c8df * var_bdd7e.w)), BlockEdgeColor.xyz, vec3(float(sqrt((var_2d529 * var_2d529) + (var_18d36 * var_18d36)) > 0.00999999977648258209228515625) * BlockEdgeColor.w));
    if ((var_b0955.x + 1.1999999571798980468884110450745e-07) < 1.0)
    {
        if ((var_b0955.x - 1.1999999571798980468884110450745e-07) <= var_81d64.x)
        {
            var_93128 = vec4(var_e4f8c, var_fd987.w);
        }
        else
        {
            highp vec4 var_19460 = mix(var_fd987, vec4(OutlineColor.xyz, var_fd987.w), vec4(var_6c8df * OutlineColor.w));
            var_93128 = var_19460;
            highp vec3 var_79998 = mix(var_19460.xyz, var_e4f8c, vec3(HiddenBlocksAlpha.x));
            var_93128.x = var_79998.x;
            var_93128.y = var_79998.y;
            var_93128.z = var_79998.z;
        }
    }
    else
    {
        var_93128 = var_fd987;
    }
    if (PreExposureEnabled.x != 0.0)
    {
        highp vec4 var_2a4ae = var_93128;
        highp vec3 var_39d81 = var_2a4ae.xyz * ((0.180000007152557373046875 / var_df5e5) + 9.9999997473787516355514526367188e-05);
        var_93128.x = var_39d81.x;
        var_93128.y = var_39d81.y;
        var_93128.z = var_39d81.z;
    }
    bgfx_FragData0 = var_93128;
}
