#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_OPAQUE_PASS (not used)
* - GEOMETRY_PREPASS_PASS (not used)
* - GEOMETRY_PREPASS_ALPHA_TEST_PASS (not used)
*
* Dithering:
* - DITHERING__OFF (not used)
* - DITHERING__ON (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* Seasons:
* - SEASONS__OFF (not used)
* - SEASONS__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_LightMapTexture;
* - uniform lowp sampler2D s_MatTexture;
* - layout(binding = 3, std430) buffer s_PBRDataBuffer { PBRTextureData s_PBRData[]; };
* - uniform lowp sampler2D s_SeasonsTexture;
*
* Uniforms:
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
* - uniform vec4 GlobalRoughness;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 ViewPositionAndTime;
*/

uniform mat4 u_model[4];
uniform mat4 u_viewProj;
uniform vec4 ViewPositionAndTime;
in vec4 a_color0;
in vec3 a_position;
out vec3 v_bitangent;
out vec3 v_normal;
out vec3 v_tangent;
out vec3 v_worldPos;
void main() {
    vec3 var_32be0 = a_color0.xyz;
    vec3 var_de068 = (u_model[0] * vec4(a_position, 1.0)).xyz + vec3(0.5);
    vec3 var_0de64 = normalize(var_de068 - ViewPositionAndTime.xyz);
    vec3 var_f00ec = normalize(cross(vec3(0.0, 1.0, 0.0), var_0de64));
    v_bitangent = vec3(0.0);
    v_normal = vec3(0.0);
    v_tangent = vec3(0.0);
    v_worldPos = vec3(0.0);
    gl_Position = u_viewProj * vec4(var_de068 - ((cross(var_0de64, var_f00ec) * (var_32be0.z - 0.5)) + (var_f00ec * (var_32be0.x - 0.5))), 1.0);
}
