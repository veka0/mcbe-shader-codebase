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
* Uniforms:
* - uniform vec4 ChangeColor;
* - uniform vec4 ColorBased;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MaterialID;
* - uniform vec4 MultiplicativeTintColor;
* - uniform vec4 OverlayColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
*/

precision mediump float;
precision highp int;
uniform highp vec4 ChangeColor;
uniform highp vec4 ColorBased;
#ifdef MULTI_COLOR_TINT__ON
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
in highp vec4 v_color0;
in highp vec4 v_fog;
in highp vec4 v_light;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_fef14 = v_color0;
    highp vec3 var_05ab4 = mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec3 var_d683b = mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
    highp vec2 var_533c7 = var_d683b.xy;
    highp vec3 var_3469a = mix(mix((var_d683b.xxx * ChangeColor.xyz).xyz, var_d683b.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_533c7.y))).xyz, OverlayColor.xyz, vec3(OverlayColor.w)).xyz * v_light.xyz;
    highp vec4 var_bac29 = vec4(var_3469a.x, var_3469a.y, var_3469a.z, vec4(1.0).w);
#endif
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_90a94 = vec4(var_05ab4.x, var_05ab4.y, var_05ab4.z, vec4(1.0).w);
    highp vec3 var_f13ac = mix(mix(var_90a94, var_90a94 * ChangeColor, vec4(var_fef14.w)).xyz, OverlayColor.xyz, vec3(OverlayColor.w)).xyz * v_light.xyz;
    highp vec4 var_bac29 = vec4(var_f13ac.x, var_f13ac.y, var_f13ac.z, vec4(1.0).w);
#endif
    if (var_bac29.w < 0.5)
    {
        discard;
    }
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_1a4b7 = vec4(var_f13ac, var_bac29.w);
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec4 var_1a4b7 = vec4(var_3469a, var_bac29.w);
#endif
    highp vec4 var_6ca24 = v_fog;
    highp vec3 var_14685 = mix(var_1a4b7.xyz, v_fog.xyz, vec3(var_6ca24.w));
    bgfx_FragColor = vec4(var_14685.x, var_14685.y, var_14685.z, var_1a4b7.w);
}
