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
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_81d64 = texture(s_SceneTextureDepth, v_texcoord0);
    highp vec4 var_b0955 = texture(s_HighlightTextureDepth, v_texcoord0);
    highp vec4 var_1ac3d = texture(s_SceneTextureColor, v_texcoord0);
    highp vec4 var_ab311 = texture(s_HighlightTextureColor, v_texcoord0);
    highp vec4 var_a4aca = vec4((v_texcoord0 * 2.0) - vec2(1.0), var_b0955.x, 1.0);
    var_a4aca.y = -var_a4aca.y;
    highp vec4 var_6f0b4 = InverseProjView * var_a4aca;
    highp vec4 var_ef43a = var_6f0b4;
    highp float var_b5d53 = var_ef43a.w;
    highp vec3 var_eb171 = var_6f0b4.xyz / vec3(var_b5d53);
    var_ef43a = vec4(var_eb171.x, var_eb171.y, var_eb171.z, var_6f0b4.w);
    highp vec3 var_cd3dd = var_eb171.xyz + CameraPosition.xyz;
    highp vec2 var_20eb5 = v_texcoord0 + (vec2(-1.0, 0.0) * ScreenSize.zw);
    highp vec2 var_30e7c = v_texcoord0 + (vec2(0.0, -1.0) * ScreenSize.zw);
    highp vec4 var_219a5 = vec4((var_20eb5 * 2.0) - vec2(1.0), texture(s_HighlightTextureDepth, var_20eb5).x, 1.0);
    var_219a5.y = -var_219a5.y;
    highp vec4 var_f12b9 = InverseProjView * var_219a5;
    highp vec4 var_6ef9f = var_f12b9;
    highp float var_a538e = var_6ef9f.w;
    highp vec3 var_e3fa0 = var_f12b9.xyz / vec3(var_a538e);
    var_6ef9f = vec4(var_e3fa0.x, var_e3fa0.y, var_e3fa0.z, var_f12b9.w);
    highp vec4 var_0ead0 = vec4((v_texcoord0 * 2.0) - vec2(1.0), texture(s_HighlightTextureDepth, v_texcoord0).x, 1.0);
    var_0ead0.y = -var_0ead0.y;
    highp vec4 var_cc76c = InverseProjView * var_0ead0;
    highp vec4 var_7fe45 = var_cc76c;
    highp float var_edd16 = var_7fe45.w;
    highp vec3 var_8b3d5 = var_cc76c.xyz / vec3(var_edd16);
    var_7fe45 = vec4(var_8b3d5.x, var_8b3d5.y, var_8b3d5.z, var_cc76c.w);
    highp vec3 var_a797a = var_8b3d5.xyz;
    highp vec4 var_3e640 = vec4((var_30e7c * 2.0) - vec2(1.0), texture(s_HighlightTextureDepth, var_30e7c).x, 1.0);
    var_3e640.y = -var_3e640.y;
    highp vec4 var_8b955 = InverseProjView * var_3e640;
    highp vec4 var_06625 = var_8b955;
    highp float var_21284 = var_06625.w;
    highp vec3 var_2a2d7 = var_8b955.xyz / vec3(var_21284);
    var_06625 = vec4(var_2a2d7.x, var_2a2d7.y, var_2a2d7.z, var_8b955.w);
    highp vec3 var_04b05 = round(normalize(cross(var_e3fa0.xyz - var_a797a, var_2a2d7.xyz - var_a797a)) * 10.0) * vec3(0.100000001490116119384765625);
    highp vec4 var_2975e = texture(s_SelectedBlocksOverlayTexture, fract((((var_cd3dd.zy * var_04b05.x) + (var_cd3dd.xz * var_04b05.y)) + (var_cd3dd.xy * var_04b05.z)) / vec2(OverlayTextureStretch.x)));
    highp vec4 var_1e153 = var_2975e;
    highp vec3 var_e154c = mix(var_ab311.xyz, var_2975e.xyz, vec3(var_1e153.w));
    highp vec4 var_35b91;
    highp float var_df5e5;
    if (PreExposureEnabled.x != 0.0)
    {
        highp vec4 var_42699 = texelFetch(s_PreviousFrameAverageLuminance, ivec2(0), 0);
        highp float var_a5230 = var_42699.x;
        highp vec3 var_a7b00 = var_1ac3d.xyz / vec3((0.180000007152557373046875 / var_a5230) + 9.9999997473787516355514526367188e-05);
        var_1ac3d = vec4(var_a7b00.x, var_a7b00.y, var_a7b00.z, var_1ac3d.w);
        highp vec3 var_d299f = var_e154c.xyz / vec3((0.180000007152557373046875 / var_a5230) + 9.9999997473787516355514526367188e-05);
        var_df5e5 = var_a5230;
        var_35b91 = vec4(var_d299f.x, var_d299f.y, var_d299f.z, var_ab311.w);
    }
    else
    {
        var_df5e5 = 1.0;
        var_35b91 = vec4(var_e154c.x, var_e154c.y, var_e154c.z, var_ab311.w);
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
    highp vec4 var_2320a = var_35b91;
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
    highp vec3 var_e4f8c = mix(mix(mix(var_1ac3d.xyz, mix(var_35b91.xyz, HighlightColor.xyz, vec3(var_a3114.w)), vec3(var_2320a.w * HighlightAlpha.x)), OutlineColor.xyz, vec3(var_6c8df * var_bdd7e.w)), BlockEdgeColor.xyz, vec3(float(sqrt((var_2d529 * var_2d529) + (var_18d36 * var_18d36)) > 0.00999999977648258209228515625) * BlockEdgeColor.w));
    highp vec4 var_e7a67;
    if ((var_b0955.x + 1.1999999571798980468884110450745e-07) < 1.0)
    {
        highp vec4 var_7a858;
        if ((var_b0955.x - 1.1999999571798980468884110450745e-07) <= var_81d64.x)
        {
            var_7a858 = vec4(var_e4f8c, var_1ac3d.w);
        }
        else
        {
            highp vec4 var_dc444 = mix(var_1ac3d, vec4(OutlineColor.xyz, var_1ac3d.w), vec4(var_6c8df * OutlineColor.w));
            highp vec3 var_8a0f9 = mix(var_dc444.xyz, var_e4f8c, vec3(HiddenBlocksAlpha.x));
            var_7a858 = vec4(var_8a0f9.x, var_8a0f9.y, var_8a0f9.z, var_dc444.w);
        }
        var_e7a67 = var_7a858;
    }
    else
    {
        var_e7a67 = var_1ac3d;
    }
    highp vec4 var_38beb;
    if (PreExposureEnabled.x != 0.0)
    {
        highp vec3 var_1d4b5 = var_e7a67.xyz * ((0.180000007152557373046875 / var_df5e5) + 9.9999997473787516355514526367188e-05);
        var_38beb = vec4(var_1d4b5.x, var_1d4b5.y, var_1d4b5.z, var_e7a67.w);
    }
    else
    {
        var_38beb = var_e7a67;
    }
    bgfx_FragColor = var_38beb;
}
