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
    highp vec4 var_30e9e = var_74395 * MatColor;
    var_1bee0 = var_30e9e;
    highp vec4 var_b580a = var_30e9e;
    if (var_b580a.w < 0.5)
    {
        discard;
    }
#ifdef MULTI_COLOR_TINT__OFF
    highp vec3 var_c44be = var_30e9e.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec3 var_61abf = var_30e9e.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
    highp vec2 var_533c7 = var_61abf.xy;
    highp vec3 var_c44be = mix(mix((var_61abf.xxx * ChangeColor.xyz).xyz, var_61abf.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_533c7.y))).xyz, OverlayColor.xyz, vec3(OverlayColor.w)).xyz * v_light.xyz;
#endif
    highp vec4 var_4ef07 = vec4(var_c44be.x, var_c44be.y, var_c44be.z, var_30e9e.w);
#ifdef MULTI_COLOR_TINT__OFF
    highp vec3 var_96542 = mix(mix(var_4ef07, var_4ef07 * ChangeColor, vec4(var_f5beb.w)).xyz, OverlayColor.xyz, vec3(OverlayColor.w)).xyz * v_light.xyz;
    highp vec4 var_89833 = vec4(var_96542.x, var_96542.y, var_96542.z, var_30e9e.w);
    highp vec4 var_1a4b7 = vec4(var_96542, var_89833.w);
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec4 var_1a4b7 = vec4(var_c44be, var_4ef07.w);
#endif
    highp vec4 var_6ca24 = v_fog;
    highp vec3 var_14685 = mix(var_1a4b7.xyz, v_fog.xyz, vec3(var_6ca24.w));
    bgfx_FragColor = vec4(var_14685.x, var_14685.y, var_14685.z, var_1a4b7.w);
}
