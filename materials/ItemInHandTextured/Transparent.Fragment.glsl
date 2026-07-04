#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_PASS (not used)
* - DEPTH_ONLY_OPAQUE_PASS (not used)
* - OPAQUE_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Fancy:
* - FANCY__OFF (not used)
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* MultiColorTint:
* - MULTI_COLOR_TINT__OFF
* - MULTI_COLOR_TINT__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 AlphaMaskedTint;
* - uniform vec4 BlockLightColor;
* - uniform vec4 ChangeColor;
* - uniform vec4 ColorBased;
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
* - uniform vec4 DitheringEnabledToggle;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MatColor;
* - uniform vec4 MaterialID;
* - uniform vec4 MultiplicativeTintColor;
* - uniform vec4 OverlayColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
*/

precision mediump float;
precision highp int;
float var_33fae;
uniform highp mat4 u_invView;
uniform highp mat4 u_view;
uniform highp sampler2D s_MatTexture;
uniform highp vec4 AlphaMaskedTint;
uniform highp vec4 ChangeColor;
uniform highp vec4 ColorBased;
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
uniform highp vec4 DitheringEnabledToggle;
uniform highp vec4 MatColor;
#ifdef MULTI_COLOR_TINT__ON
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
in highp vec4 v_clipPosition;
in highp vec4 v_color0;
in highp vec4 v_fog;
in highp vec4 v_light;
in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_f5beb = v_color0;
    highp vec4 var_1bee0 = texture(s_MatTexture, v_texcoord0);
    if (AlphaMaskedTint.x != 0.0)
    {
        highp vec3 var_5e4d7 = mix(var_1bee0.xyz, var_1bee0.xyz * v_color0.xyz, vec3(var_1bee0.w)).xyz * var_f5beb.w;
        var_1bee0 = vec4(var_5e4d7.x, var_5e4d7.y, var_5e4d7.z, var_1bee0.w);
        var_1bee0.w = 1.0;
    }
    else
    {
        highp vec3 var_55928 = var_1bee0.xyz * v_color0.xyz;
        var_1bee0 = vec4(var_55928.x, var_55928.y, var_55928.z, var_1bee0.w);
    }
    highp vec4 var_74395 = var_1bee0;
    highp vec4 var_0d9b4 = var_74395 * MatColor;
    var_1bee0 = var_0d9b4;
#ifdef MULTI_COLOR_TINT__OFF
    highp vec3 var_2ce32 = var_0d9b4.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec3 var_61abf = var_0d9b4.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
    highp vec2 var_533c7 = var_61abf.xy;
    highp vec3 var_9b5e9 = mix(mix((var_61abf.xxx * ChangeColor.xyz).xyz, var_61abf.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_533c7.y))).xyz, OverlayColor.xyz, vec3(OverlayColor.w)).xyz * v_light.xyz;
    highp vec4 var_6eb8b = vec4(var_9b5e9.x, var_9b5e9.y, var_9b5e9.z, var_0d9b4.w);
#endif
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_8990b = vec4(var_2ce32.x, var_2ce32.y, var_2ce32.z, var_0d9b4.w);
    highp vec3 var_7e05e = mix(mix(var_8990b, var_8990b * ChangeColor, vec4(var_f5beb.w)).xyz, OverlayColor.xyz, vec3(OverlayColor.w)).xyz * v_light.xyz;
    highp vec4 var_6eb8b = vec4(var_7e05e.x, var_7e05e.y, var_7e05e.z, var_0d9b4.w);
#endif
    highp vec2 var_7c9c5 = DitherParams2[0].xy;
    bool var_c20f0;
    if (DitheringEnabledToggle.x != 0.0)
    {
        highp mat4 var_4971e = u_view;
        highp vec4 var_d36cf = v_clipPosition;
        highp vec2 var_886c2 = floor(((((v_clipPosition.xyz / vec3(var_d36cf.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[0].z)) * DitherParams2[0].z;
        highp vec2 var_f4989 = floor(var_886c2 * 0.25);
        highp vec2 var_85686 = floor(var_886c2 * 0.5);
        highp vec2 var_09c49 = floor(var_886c2);
        var_c20f0 = smoothstep(var_7c9c5.x, var_7c9c5.y, dot(-normalize(vec4(var_4971e[0].z, var_4971e[1].z, var_4971e[2].z, var_33fae).xyz), v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)) <= (((((((fract((var_f4989.x * 0.5) + ((var_f4989.y * var_f4989.y) * 0.75)) * 0.25) + fract((var_85686.x * 0.5) + ((var_85686.y * var_85686.y) * 0.75))) * 0.25) + fract((var_09c49.x * 0.5) + ((var_09c49.y * var_09c49.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        var_c20f0 = false;
    }
    highp float var_dbeed = var_6eb8b.w * (var_c20f0 ? 0.0 : 1.0);
    highp vec4 var_b57e9 = v_fog;
#ifdef MULTI_COLOR_TINT__OFF
    bgfx_FragColor = vec4(mix(vec4(var_7e05e, var_dbeed).xyz, v_fog.xyz, vec3(var_b57e9.w)), var_dbeed);
#endif
#ifdef MULTI_COLOR_TINT__ON
    bgfx_FragColor = vec4(mix(vec4(var_9b5e9, var_dbeed).xyz, v_fog.xyz, vec3(var_b57e9.w)), var_dbeed);
#endif
}
