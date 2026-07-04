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
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
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
* - uniform vec4 PrevPositionBaseOffset;
* - uniform vec4 PrevPositionForwardOffset;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 UVOffsetAndScale;
* - uniform vec4 Velocity;
* - uniform vec4 ViewPosition;
*/

uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 Dimensions;
uniform vec4 FogAndDistanceControl;
uniform vec4 FogColor;
uniform vec4 PositionBaseOffset;
uniform vec4 PositionForwardOffset;
uniform vec4 SubPixelOffset;
uniform vec4 UVOffsetAndScale;
uniform vec4 Velocity;
uniform vec4 ViewPosition;
in vec4 a_color0;
in vec3 a_position;
in vec2 a_texcoord0;
out vec4 v_color0;
out vec4 v_fog;
out float v_occlusionHeight;
out vec2 v_occlusionUV;
out vec2 v_texcoord0;
out vec3 v_worldPos;
void main() {
#ifdef NO_VARIETY__OFF
    vec4 var_6c969 = a_color0;
#endif
    vec2 var_49187 = a_texcoord0;
#ifdef NO_VARIETY__OFF
    vec2 var_181bc = UVOffsetAndScale.xy + (a_texcoord0 * UVOffsetAndScale.zw);
    var_181bc.x += ((var_6c969.x * 255.0) * UVOffsetAndScale.z);
#endif
    vec3 var_60145 = a_position + PositionBaseOffset.xyz;
    vec3 var_ba3f6 = vec3(30.0);
    vec3 var_f27d2 = (vec3(var_60145.x - (var_ba3f6.x * float(int(var_60145.x / var_ba3f6.x))), var_60145.y - (var_ba3f6.y * float(int(var_60145.y / var_ba3f6.y))), var_60145.z - (var_ba3f6.z * float(int(var_60145.z / var_ba3f6.z)))) - vec3(15.0)) + PositionForwardOffset.xyz;
    vec3 var_91624 = var_f27d2;
    mat4 var_83c3f = u_proj;
    vec4 var_67767 = var_83c3f[2];
    var_67767.x += SubPixelOffset.x;
    var_67767.y -= SubPixelOffset.y;
    mat4 var_a3f1d = u_proj;
    var_a3f1d[2] = var_67767;
    vec4 var_1e5d3 = var_a3f1d * (u_view * vec4(var_f27d2, 1.0));
    vec4 var_8dd4e = var_1e5d3;
    mat4 var_1d0ff = u_proj;
    vec4 var_f0fcc = var_1d0ff[2];
    var_f0fcc.x += SubPixelOffset.x;
    var_f0fcc.y -= SubPixelOffset.y;
    mat4 var_3a7e1 = u_proj;
    var_3a7e1[2] = var_f0fcc;
    vec4 var_ac686 = var_3a7e1 * (u_view * vec4(var_f27d2 + (Velocity.xyz * Dimensions.y), 1.0));
    vec4 var_fe173 = var_ac686;
    vec2 var_67f44 = (var_ac686.xy / vec2(var_fe173.w)) - (var_1e5d3.xy / vec2(var_8dd4e.w));
    vec4 var_defd3 = mix(var_ac686, var_1e5d3, vec4(var_49187.y));
    vec2 var_4cdd6 = var_defd3.xy + ((normalize(vec2(-var_67f44.y, var_67f44.x)) * (0.5 - var_49187.x)) * Dimensions.x);
    vec4 var_36755 = vec4(var_4cdd6.x, var_4cdd6.y, var_defd3.z, var_defd3.w);
    v_color0 = a_color0;
    v_fog = vec4(FogColor.xyz, clamp(((var_36755.z / FogAndDistanceControl.z) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0));
    v_occlusionHeight = (var_91624.y + (ViewPosition.y - 0.5)) * 0.0039215688593685626983642578125;
    v_occlusionUV = ((var_f27d2.xz + ViewPosition.xz) * 0.015625) + vec2(0.5);
#ifdef NO_VARIETY__OFF
    v_texcoord0 = var_181bc;
#endif
#ifdef NO_VARIETY__ON
    v_texcoord0 = UVOffsetAndScale.xy + (a_texcoord0 * UVOffsetAndScale.zw);
#endif
    v_worldPos = var_f27d2;
    gl_Position = vec4(var_4cdd6.x, var_4cdd6.y, var_defd3.z, var_defd3.w);
}
