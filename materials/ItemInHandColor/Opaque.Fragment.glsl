#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_ALPHA_TEST_PASS (not used)
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
* Uniforms:
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
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_fef14 = v_color0;
    highp vec3 var_f90fa = mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec3 var_d683b = mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
    highp vec2 var_533c7 = var_d683b.xy;
    highp vec3 var_f90fa = mix(mix((var_d683b.xxx * ChangeColor.xyz).xyz, var_d683b.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_533c7.y))).xyz, OverlayColor.xyz, vec3(OverlayColor.w)).xyz * v_light.xyz;
#endif
    highp vec4 var_1aaf3 = vec4(var_f90fa.x, var_f90fa.y, var_f90fa.z, vec4(1.0).w);
#ifdef MULTI_COLOR_TINT__OFF
    highp vec3 var_570ea = mix(mix(var_1aaf3, var_1aaf3 * ChangeColor, vec4(var_fef14.w)).xyz, OverlayColor.xyz, vec3(OverlayColor.w)).xyz * v_light.xyz;
    highp vec4 var_3849e = vec4(var_570ea.x, var_570ea.y, var_570ea.z, vec4(1.0).w);
#endif
    highp vec4 var_10e64 = v_fog;
#ifdef MULTI_COLOR_TINT__OFF
    bgfx_FragData0 = vec4(mix(vec4(var_570ea, var_3849e.w).xyz, v_fog.xyz, vec3(var_10e64.w)), var_3849e.w);
#endif
#ifdef MULTI_COLOR_TINT__ON
    bgfx_FragData0 = vec4(mix(vec4(var_f90fa, var_1aaf3.w).xyz, v_fog.xyz, vec3(var_10e64.w)), var_1aaf3.w);
#endif
}
