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
* - FANCY__OFF
* - FANCY__ON
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*
* MultiColorTint:
* - MULTI_COLOR_TINT__OFF (not used)
* - MULTI_COLOR_TINT__ON (not used)
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

#if defined(FANCY__ON) || defined(INSTANCING__OFF)
uniform mat4 u_model[4];
#endif
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 FogColor;
uniform vec4 FogControl;
uniform vec4 OverlayColor;
uniform vec4 SubPixelOffset;
uniform vec4 TileLightColor;
in vec4 a_color0;
#ifdef FANCY__ON
in vec4 a_normal;
#endif
in vec3 a_position;
in vec2 a_texcoord0;
#ifdef INSTANCING__ON
in vec4 i_data1;
in vec4 i_data2;
in vec4 i_data3;
#endif
out vec4 v_clipPosition;
out vec4 v_color0;
out vec4 v_fog;
out vec4 v_light;
out vec2 v_texcoord0;
out vec3 v_worldPos;
void main() {
#ifdef FANCY__ON
    vec3 var_f099e = normalize(u_model[0] * vec4(a_normal.xyz, 0.0)).xyz;
    var_f099e.y *= TileLightColor.w;
#endif
#ifdef INSTANCING__OFF
    vec4 var_e2d09 = u_model[0] * vec4(a_position, 1.0);
#endif
#ifdef INSTANCING__ON
    vec4 var_78b44 = i_data1;
    vec4 var_e67a8 = i_data2;
    vec4 var_1b7f0 = i_data3;
    mat4 var_e43a8;
    var_e43a8[0] = vec4(var_78b44.x, var_e67a8.x, var_1b7f0.x, 0.0);
    var_e43a8[1] = vec4(var_78b44.y, var_e67a8.y, var_1b7f0.y, 0.0);
    var_e43a8[2] = vec4(var_78b44.z, var_e67a8.z, var_1b7f0.z, 0.0);
    var_e43a8[3] = vec4(var_78b44.w, var_e67a8.w, var_1b7f0.w, 1.0);
    vec4 var_e2d09 = var_e43a8 * vec4(a_position, 1.0);
#endif
    mat4 var_83c3f = u_proj;
    vec4 var_67767 = var_83c3f[2];
    var_67767.x += SubPixelOffset.x;
    var_67767.y -= SubPixelOffset.y;
    mat4 var_cbf5d = u_proj;
    var_cbf5d[2] = var_67767;
    vec4 var_04ab5 = var_cbf5d * (u_view * vec4(var_e2d09.xyz, 1.0));
    vec4 var_27f6b = var_04ab5;
    uvec2 var_6c76e = uvec2(round(a_texcoord0 * 65535.0));
    vec2 var_45935 = vec2(float((var_6c76e.x & 32767u) << uint(1)), float((var_6c76e.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    var_45935.x += (3.0517578125e-05 * ((2.0 * float((var_6c76e.x & 32768u) >> uint(15))) - 1.0));
    var_45935.y += (3.0517578125e-05 * ((2.0 * float((var_6c76e.y & 32768u) >> uint(15))) - 1.0));
    v_clipPosition = var_04ab5;
    v_color0 = a_color0;
    v_fog = vec4(FogColor.xyz, clamp(((var_27f6b.z / FogControl.z) - FogControl.x) / (FogControl.y - FogControl.x), 0.0, 1.0));
#ifdef FANCY__OFF
    v_light = vec4(TileLightColor.xyz * (1.0 + (OverlayColor.w * 0.3499999940395355224609375)), 1.0);
#endif
#ifdef FANCY__ON
    v_light = vec4(TileLightColor.xyz * ((((((1.0 + var_f099e.y) * 0.2750000059604644775390625) + ((var_f099e.x * var_f099e.x) * (-0.100000001490116119384765625))) + ((var_f099e.z * var_f099e.z) * 0.100000001490116119384765625)) + 0.449999988079071044921875) + (OverlayColor.w * 0.3499999940395355224609375)), 1.0);
#endif
    v_texcoord0 = var_45935;
    v_worldPos = var_e2d09.xyz;
    gl_Position = var_04ab5;
}
