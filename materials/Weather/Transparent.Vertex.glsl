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
    vec2 var_e7b5c = UVOffsetAndScale.xy + (a_texcoord0 * UVOffsetAndScale.zw);
    var_e7b5c.x += ((a_color0.x * 255.0) * UVOffsetAndScale.z);
#endif
    vec3 var_5bfc0 = a_position + PositionBaseOffset.xyz;
    vec3 var_4108f = vec3(30.0);
    vec3 var_61547 = (vec3(var_5bfc0.x - (var_4108f.x * trunc(var_5bfc0.x / var_4108f.x)), var_5bfc0.y - (var_4108f.y * trunc(var_5bfc0.y / var_4108f.y)), var_5bfc0.z - (var_4108f.z * trunc(var_5bfc0.z / var_4108f.z))) - vec3(15.0)) + PositionForwardOffset.xyz;
    vec3 var_91624 = var_61547;
    mat4 var_83c3f = u_proj;
    vec4 var_67767 = var_83c3f[2];
    var_67767.x += SubPixelOffset.x;
    var_67767.y -= SubPixelOffset.y;
    mat4 var_a3f1d = u_proj;
    var_a3f1d[2] = var_67767;
    vec4 var_0d6d9 = var_a3f1d * (u_view * vec4(var_61547, 1.0));
    vec4 var_8dd4e = var_0d6d9;
    mat4 var_1d0ff = u_proj;
    vec4 var_f0fcc = var_1d0ff[2];
    var_f0fcc.x += SubPixelOffset.x;
    var_f0fcc.y -= SubPixelOffset.y;
    mat4 var_3a7e1 = u_proj;
    var_3a7e1[2] = var_f0fcc;
    vec4 var_54b08 = var_3a7e1 * (u_view * vec4(var_61547 + (Velocity.xyz * Dimensions.y), 1.0));
    vec4 var_fe173 = var_54b08;
    vec2 var_42565 = (var_54b08.xy / vec2(var_fe173.w)) - (var_0d6d9.xy / vec2(var_8dd4e.w));
    vec4 var_a54f8 = mix(var_54b08, var_0d6d9, vec4(a_texcoord0.y));
    vec4 var_4dc20 = var_a54f8;
    vec2 var_32c13 = var_a54f8.xy + ((normalize(vec2(-var_42565.y, var_42565.x)) * (0.5 - a_texcoord0.x)) * Dimensions.x);
    var_4dc20.x = var_32c13.x;
    var_4dc20.y = var_32c13.y;
    v_color0 = a_color0;
    v_fog = vec4(FogColor.xyz, clamp(((var_4dc20.z / FogAndDistanceControl.z) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0));
    v_occlusionHeight = (var_91624.y + (ViewPosition.y - 0.5)) * 0.0039215688593685626983642578125;
    v_occlusionUV = ((var_61547.xz + ViewPosition.xz) * 0.015625) + vec2(0.5);
#ifdef NO_VARIETY__OFF
    v_texcoord0 = var_e7b5c;
#endif
#ifdef NO_VARIETY__ON
    v_texcoord0 = UVOffsetAndScale.xy + (a_texcoord0 * UVOffsetAndScale.zw);
#endif
    v_worldPos = var_61547;
    gl_Position = var_4dc20;
}
