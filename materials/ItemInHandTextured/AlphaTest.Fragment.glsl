#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_PASS (not used)
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
* - uniform vec4 ChangeColor;
* - uniform vec4 ColorBased;
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
uniform highp sampler2D s_MatTexture;
uniform highp vec4 AlphaMaskedTint;
uniform highp vec4 ChangeColor;
uniform highp vec4 ColorBased;
uniform highp vec4 MatColor;
#ifdef MULTI_COLOR_TINT__ON
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
in highp vec4 v_color0;
in highp vec4 v_fog;
in highp vec4 v_light;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_19e4b = v_color0;
    highp vec4 var_9af0f = texture(s_MatTexture, v_texcoord0);
    if (AlphaMaskedTint.x != 0.0)
    {
        highp vec3 var_c7ec1 = mix(var_9af0f.xyz, var_9af0f.xyz * v_color0.xyz, vec3(var_9af0f.w));
        var_9af0f = vec4(var_c7ec1.x, var_c7ec1.y, var_c7ec1.z, var_9af0f.w);
        var_9af0f.w = 1.0;
    }
    else
    {
        highp vec3 var_55928 = var_9af0f.xyz * v_color0.xyz;
        var_9af0f = vec4(var_55928.x, var_55928.y, var_55928.z, var_9af0f.w);
    }
    highp vec4 var_1f491 = var_9af0f;
    highp vec3 var_9b8be = var_1f491.xyz * var_19e4b.w;
    highp vec4 var_f6340 = vec4(var_9b8be.x, var_9b8be.y, var_9b8be.z, var_1f491.w) * MatColor;
    var_9af0f = var_f6340;
    highp vec4 var_b580a = var_f6340;
    if (var_b580a.w < 0.5)
    {
        discard;
    }
#ifdef MULTI_COLOR_TINT__OFF
    highp vec3 var_c44be = var_f6340.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec3 var_61abf = var_f6340.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
    highp vec2 var_533c7 = var_61abf.xy;
    highp vec3 var_c44be = mix(mix((var_61abf.xxx * ChangeColor.xyz).xyz, var_61abf.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_533c7.y))).xyz, OverlayColor.xyz, vec3(OverlayColor.w)).xyz * v_light.xyz;
#endif
    highp vec4 var_4ef07 = vec4(var_c44be.x, var_c44be.y, var_c44be.z, var_f6340.w);
#ifdef MULTI_COLOR_TINT__OFF
    highp vec3 var_96542 = mix(mix(var_4ef07, var_4ef07 * ChangeColor, vec4(var_19e4b.w)).xyz, OverlayColor.xyz, vec3(OverlayColor.w)).xyz * v_light.xyz;
    highp vec4 var_89833 = vec4(var_96542.x, var_96542.y, var_96542.z, var_f6340.w);
    highp vec4 var_1a4b7 = vec4(var_96542, var_89833.w);
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec4 var_1a4b7 = vec4(var_c44be, var_4ef07.w);
#endif
    highp vec4 var_6ca24 = v_fog;
    highp vec3 var_14685 = mix(var_1a4b7.xyz, v_fog.xyz, vec3(var_6ca24.w));
    bgfx_FragColor = vec4(var_14685.x, var_14685.y, var_14685.z, var_1a4b7.w);
}
