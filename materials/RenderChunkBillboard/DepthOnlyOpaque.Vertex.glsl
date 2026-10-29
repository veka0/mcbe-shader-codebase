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
* Dithering:
* - DITHERING__OFF (not used)
* - DITHERING__ON (not used)
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
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
* - uniform lowp sampler2D s_SeasonsTexture;
*
* Uniforms:
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 GlobalRoughness;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MeshContext;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 ViewPositionAndTime;
*/

#ifdef INSTANCING__OFF
uniform mat4 u_model[4];
#endif
uniform mat4 u_viewProj;
uniform vec4 FogAndDistanceControl;
uniform vec4 FogColor;
uniform vec4 MeshContext;
uniform vec4 RenderChunkFogAlpha;
uniform vec4 ViewPositionAndTime;
in vec4 a_color0;
in vec3 a_position;
#ifdef INSTANCING__ON
in vec4 i_data1;
in vec4 i_data2;
in vec4 i_data3;
#endif
out vec4 v_color0;
out vec2 v_ditheringAndMaskTinting;
out vec4 v_fog;
out vec2 v_lightmapUV;
centroid out vec2 v_texcoord0;
out vec3 v_worldPos;
void main() {
#ifdef INSTANCING__OFF
    vec3 var_84c00 = (u_model[0] * vec4(a_position, 1.0)).xyz;
#endif
#ifdef INSTANCING__ON
    mat4 var_09352;
    var_09352[0] = vec4(i_data1.x, i_data2.x, i_data3.x, 0.0);
    var_09352[1] = vec4(i_data1.y, i_data2.y, i_data3.y, 0.0);
    var_09352[2] = vec4(i_data1.z, i_data2.z, i_data3.z, 0.0);
    var_09352[3] = vec4(i_data1.w, i_data2.w, i_data3.w, 1.0);
    vec3 var_84c00 = (var_09352 * vec4(a_position, 1.0)).xyz;
#endif
    vec4 var_b4c0f = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
    vec3 var_32be0 = a_color0.xyz;
    vec3 var_f0343 = var_84c00 + vec3(0.5);
    vec3 var_0de64 = normalize(var_f0343 - ViewPositionAndTime.xyz);
    vec3 var_f00ec = normalize(cross(vec3(0.0, 1.0, 0.0), var_0de64));
    vec2 var_09d1c = round(vec2(0.0));
    uvec2 var_27852 = uvec2(var_09d1c);
    vec2 var_45935 = vec2(float((var_27852.x & 32767u) << uint(1)), float((var_27852.y & 32767u) << uint(1))) * vec2(1.525902189314365386962890625e-05);
    var_45935.x += (3.0517578125e-05 * ((2.0 * float((var_27852.x & 32768u) >> uint(15))) - 1.0));
    var_45935.y += (3.0517578125e-05 * ((2.0 * float((var_27852.y & 32768u) >> uint(15))) - 1.0));
    v_color0 = vec4(1.0);
    v_ditheringAndMaskTinting = vec2(0.0);
    v_fog = vec4(FogColor.xyz, clamp((((length(ViewPositionAndTime.xyz - var_84c00) / var_b4c0f.z) + RenderChunkFogAlpha.x) - var_b4c0f.x) / (var_b4c0f.y - var_b4c0f.x), 0.0, 1.0));
    v_lightmapUV = vec2(0.0);
    v_texcoord0 = var_45935;
    v_worldPos = var_84c00;
    gl_Position = u_viewProj * vec4(var_f0343 - ((cross(var_0de64, var_f00ec) * (var_32be0.z - 0.5)) + (var_f00ec * (var_32be0.x - 0.5))), 1.0);
}
