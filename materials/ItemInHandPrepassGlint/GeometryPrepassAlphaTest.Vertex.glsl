#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_OPAQUE_PASS (not used)
* - GEOMETRY_PREPASS_PASS (not used)
* - GEOMETRY_PREPASS_ALPHA_TEST_PASS (not used)
*
* Fancy:
* - FANCY__OFF (not used)
* - FANCY__ON (not used)
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
* Buffers:
* - uniform lowp sampler2D s_GlintTexture;
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
* - uniform vec4 GlintColor;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MultiplicativeTintColor;
* - uniform vec4 OverlayColor;
* - uniform mat4 PrevWorld;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 UVAnimation;
* - uniform vec4 UVScale;
* - uniform vec4 ViewPositionAndTime;
*/

uniform mat4 PrevWorld;
uniform mat4 u_model[4];
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 SubPixelOffset;
uniform vec4 UVAnimation;
uniform vec4 UVScale;
in vec4 a_color0;
in vec4 a_texcoord8;
in vec4 a_normal;
in vec3 a_position;
in vec4 a_tangent;
in vec2 a_texcoord0;
#ifdef INSTANCING__ON
in vec4 i_data1;
in vec4 i_data2;
in vec4 i_data3;
#endif
out vec3 v_bitangent;
out vec4 v_clipPosition;
out vec4 v_color0;
out vec4 v_glintUV;
out vec4 v_mers;
out vec3 v_normal;
flat out int v_pbrTextureId;
out vec3 v_prevWorldPos;
out vec3 v_tangent;
out vec2 v_texcoord0;
out vec3 v_worldPos;
void main() {
    vec4 var_d607e = vec4(0.0);
    uvec2 var_6c76e = uvec2(round(a_texcoord0 * 65535.0));
    vec2 var_a956b = vec2(float((var_6c76e.x & 32767u) << uint(1)), float((var_6c76e.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    var_a956b.x += (3.0517578125e-05 * ((2.0 * float((var_6c76e.x & 32768u) >> uint(15))) - 1.0));
    var_a956b.y += (3.0517578125e-05 * ((2.0 * float((var_6c76e.y & 32768u) >> uint(15))) - 1.0));
    float var_4e585 = sin(UVAnimation.z);
    float var_04af3 = cos(UVAnimation.z);
    vec2 var_ddacc = (var_a956b - vec2(0.5)) * mat2(vec2(var_04af3, -var_4e585), vec2(var_4e585, var_04af3));
    var_ddacc.x += UVAnimation.x;
    vec2 var_eb807 = var_ddacc;
    vec2 var_e0bbc = var_eb807 + vec2(0.5);
    var_ddacc = var_e0bbc;
    vec2 var_3abf4 = var_e0bbc * UVScale.xy;
    var_d607e.x = var_3abf4.x;
    var_d607e.y = var_3abf4.y;
    float var_6a4a7 = sin(UVAnimation.w);
    float var_758cc = cos(UVAnimation.w);
    vec2 var_e87b6 = (var_a956b - vec2(0.5)) * mat2(vec2(var_758cc, -var_6a4a7), vec2(var_6a4a7, var_758cc));
    var_e87b6.x += UVAnimation.y;
    vec2 var_0ef75 = var_e87b6;
    vec2 var_a930f = var_0ef75 + vec2(0.5);
    var_e87b6 = var_a930f;
    vec2 var_e2e42 = var_a930f * UVScale.xy;
    var_d607e.z = var_e2e42.x;
    var_d607e.w = var_e2e42.y;
#ifdef INSTANCING__OFF
    vec4 var_e2d09 = u_model[0] * vec4(a_position, 1.0);
#endif
#ifdef INSTANCING__ON
    mat4 var_53a7d;
    var_53a7d[0] = vec4(i_data1.x, i_data2.x, i_data3.x, 0.0);
    var_53a7d[1] = vec4(i_data1.y, i_data2.y, i_data3.y, 0.0);
    var_53a7d[2] = vec4(i_data1.z, i_data2.z, i_data3.z, 0.0);
    var_53a7d[3] = vec4(i_data1.w, i_data2.w, i_data3.w, 1.0);
    vec4 var_e2d09 = var_53a7d * vec4(a_position, 1.0);
#endif
    mat4 var_83c3f = u_proj;
    vec4 var_67767 = var_83c3f[2];
    var_67767.x += SubPixelOffset.x;
    var_67767.y -= SubPixelOffset.y;
    mat4 var_cbf5d = u_proj;
    var_cbf5d[2] = var_67767;
    vec4 var_c804c = var_cbf5d * (u_view * vec4(var_e2d09.xyz, 1.0));
    uvec2 var_06b01 = uvec2(round(a_texcoord0 * 65535.0));
    vec2 var_45935 = vec2(float((var_06b01.x & 32767u) << uint(1)), float((var_06b01.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    var_45935.x += (3.0517578125e-05 * ((2.0 * float((var_06b01.x & 32768u) >> uint(15))) - 1.0));
    var_45935.y += (3.0517578125e-05 * ((2.0 * float((var_06b01.y & 32768u) >> uint(15))) - 1.0));
    v_bitangent = (u_model[0] * vec4(cross(a_normal.xyz, a_tangent.xyz) * a_tangent.w, 0.0)).xyz;
    v_clipPosition = var_c804c;
    v_color0 = a_color0;
    v_glintUV = var_d607e;
    v_mers = a_texcoord8;
    v_normal = (u_model[0] * vec4(a_normal.xyz, 0.0)).xyz;
    v_pbrTextureId = 0;
    v_prevWorldPos = (PrevWorld * vec4(a_position, 1.0)).xyz;
    v_tangent = (u_model[0] * vec4(a_tangent.xyz, 0.0)).xyz;
    v_texcoord0 = var_45935;
    v_worldPos = var_e2d09.xyz;
    gl_Position = var_c804c;
}
