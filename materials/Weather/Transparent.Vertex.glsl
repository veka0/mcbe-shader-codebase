#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* FlipOcclusion:
* - FLIP_OCCLUSION__OFF (not used)
* - FLIP_OCCLUSION__ON (not used)
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*
* NoOcclusion:
* - NO_OCCLUSION__OFF (not used)
* - NO_OCCLUSION__ON (not used)
*
* NoVariety:
* - NO_VARIETY__OFF
* - NO_VARIETY__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_LightingTexture;
* - uniform lowp sampler2D s_OcclusionTexture;
* - uniform lowp sampler2D s_WeatherTexture;
*
* Uniforms:
* - uniform vec4 Dimensions;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MaterialID;
* - uniform vec4 OcclusionHeightOffset;
* - uniform vec4 PositionBaseOffset;
* - uniform vec4 PositionForwardOffset;
* - uniform vec4 UVOffsetAndScale;
* - uniform vec4 Velocity;
* - uniform vec4 ViewPosition;
*/

uniform mat4 u_modelViewProj;
#ifdef INSTANCING__OFF
uniform mat4 u_model[4];
#endif
uniform vec4 Dimensions;
uniform vec4 FogAndDistanceControl;
uniform vec4 FogColor;
uniform vec4 PositionBaseOffset;
uniform vec4 PositionForwardOffset;
uniform vec4 UVOffsetAndScale;
uniform vec4 Velocity;
uniform vec4 ViewPosition;
in vec4 a_color0;
in vec3 a_position;
in vec2 a_texcoord0;
#ifdef INSTANCING__ON
in vec4 i_data1;
in vec4 i_data2;
in vec4 i_data3;
#endif
out vec4 v_color0;
out vec4 v_fog;
out float v_occlusionHeight;
out vec2 v_occlusionUV;
out vec2 v_texcoord0;
out vec3 v_worldPos;
void main() {
#ifdef INSTANCING__ON
    vec4 var_78b44 = i_data1;
    vec4 var_e67a8 = i_data2;
    vec4 var_1b7f0 = i_data3;
    mat4 var_59d11;
    var_59d11[0] = vec4(var_78b44.x, var_e67a8.x, var_1b7f0.x, 0.0);
    var_59d11[1] = vec4(var_78b44.y, var_e67a8.y, var_1b7f0.y, 0.0);
    var_59d11[2] = vec4(var_78b44.z, var_e67a8.z, var_1b7f0.z, 0.0);
    var_59d11[3] = vec4(var_78b44.w, var_e67a8.w, var_1b7f0.w, 1.0);
#endif
#ifdef NO_VARIETY__OFF
    vec4 var_6c969 = a_color0;
#endif
    vec2 var_49187 = a_texcoord0;
#ifdef NO_VARIETY__OFF
    vec2 var_181bc = UVOffsetAndScale.xy + (a_texcoord0 * UVOffsetAndScale.zw);
    var_181bc.x += ((var_6c969.x * 255.0) * UVOffsetAndScale.z);
#endif
    vec3 var_5bfc0 = a_position + PositionBaseOffset.xyz;
    vec3 var_4108f = vec3(30.0);
    vec3 var_596e7 = (vec3(var_5bfc0.x - (var_4108f.x * trunc(var_5bfc0.x / var_4108f.x)), var_5bfc0.y - (var_4108f.y * trunc(var_5bfc0.y / var_4108f.y)), var_5bfc0.z - (var_4108f.z * trunc(var_5bfc0.z / var_4108f.z))) - vec3(15.0)) + PositionForwardOffset.xyz;
    vec3 var_91624 = var_596e7;
    vec4 var_12b3c = u_modelViewProj * vec4(var_596e7, 1.0);
    vec4 var_8dd4e = var_12b3c;
    vec4 var_6e0e6 = u_modelViewProj * vec4(var_596e7 + (Velocity.xyz * Dimensions.y), 1.0);
    vec4 var_fe173 = var_6e0e6;
    vec2 var_67f44 = (var_6e0e6.xy / vec2(var_fe173.w)) - (var_12b3c.xy / vec2(var_8dd4e.w));
    vec4 var_defd3 = mix(var_6e0e6, var_12b3c, vec4(var_49187.y));
    vec2 var_4cdd6 = var_defd3.xy + ((normalize(vec2(-var_67f44.y, var_67f44.x)) * (0.5 - var_49187.x)) * Dimensions.x);
    vec4 var_36755 = vec4(var_4cdd6.x, var_4cdd6.y, var_defd3.z, var_defd3.w);
    v_color0 = a_color0;
    v_fog = vec4(FogColor.xyz, clamp(((var_36755.z / FogAndDistanceControl.z) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0));
    v_occlusionHeight = (var_91624.y + (ViewPosition.y - 0.5)) * 0.0039215688593685626983642578125;
    v_occlusionUV = ((var_596e7.xz + ViewPosition.xz) * 0.015625) + vec2(0.5);
#ifdef NO_VARIETY__OFF
    v_texcoord0 = var_181bc;
#endif
#ifdef NO_VARIETY__ON
    v_texcoord0 = UVOffsetAndScale.xy + (a_texcoord0 * UVOffsetAndScale.zw);
#endif
#ifdef INSTANCING__OFF
    v_worldPos = (u_model[0] * vec4(a_position, 1.0)).xyz;
#endif
#ifdef INSTANCING__ON
    v_worldPos = (var_59d11 * vec4(a_position, 1.0)).xyz;
#endif
    gl_Position = vec4(var_4cdd6.x, var_4cdd6.y, var_defd3.z, var_defd3.w);
}
