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
* Dithering:
* - DITHERING__OFF (not used)
* - DITHERING__ON (not used)
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*
* RenderAsBillboards:
* - RENDER_AS_BILLBOARDS__OFF
* - RENDER_AS_BILLBOARDS__ON
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
* - uniform vec4 DitherParams2;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 GlobalRoughness;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MaterialID;
* - uniform vec4 MeshContext;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 ViewPositionAndTime;
*/

#ifdef INSTANCING__OFF
uniform mat4 u_model[4];
#endif
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 FogAndDistanceControl;
uniform vec4 FogColor;
uniform vec4 MeshContext;
uniform vec4 RenderChunkFogAlpha;
uniform vec4 SubPixelOffset;
uniform vec4 ViewPositionAndTime;
in vec4 a_color0;
in vec2 a_texcoord1;
in vec3 a_position;
in vec2 a_texcoord0;
#ifdef INSTANCING__ON
in vec4 i_data1;
in vec4 i_data2;
in vec4 i_data3;
#endif
out vec4 v_clipPosition;
out vec4 v_color0;
out vec2 v_ditheringAndMaskTinting;
out vec4 v_fog;
out vec2 v_lightmapUV;
centroid out vec2 v_texcoord0;
out vec3 v_worldPos;
out vec4 v_worldPosition;
void main() {
#ifdef INSTANCING__OFF
    vec4 var_a77b2 = u_model[0] * vec4(a_position, 1.0);
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
    vec4 var_a77b2 = var_e43a8 * vec4(a_position, 1.0);
#endif
    vec3 var_35d42 = var_a77b2.xyz;
#ifdef RENDER_AS_BILLBOARDS__ON
    vec3 var_eb4e0 = var_35d42 + vec3(0.5);
    vec3 var_f280f = normalize(var_eb4e0 - ViewPositionAndTime.xyz);
    vec3 var_d3ea2 = normalize(cross(vec3(0.0, 1.0, 0.0), var_f280f));
    vec3 var_c39b1 = a_color0.xyz;
    vec3 var_4e1ae = var_eb4e0 - ((cross(var_f280f, var_d3ea2) * (var_c39b1.z - 0.5)) + (var_d3ea2 * (var_c39b1.x - 0.5)));
#endif
    vec4 var_870be = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
    mat4 var_f3461 = u_proj;
    var_f3461[2].x += SubPixelOffset.x;
    var_f3461[2].y -= SubPixelOffset.y;
#ifdef RENDER_AS_BILLBOARDS__OFF
    vec4 var_d80ab = var_f3461 * (u_view * vec4(var_a77b2.xyz, 1.0));
#endif
#ifdef RENDER_AS_BILLBOARDS__ON
    vec4 var_d80ab = var_f3461 * (u_view * vec4(var_4e1ae, 1.0));
#endif
    vec2 var_c34f1 = a_texcoord1;
    uint var_960bd = uint(floor(var_c34f1.x * 255.0));
    uint var_d0d1e = uint(floor(var_c34f1.y * 255.0));
    v_clipPosition = var_d80ab;
#ifdef RENDER_AS_BILLBOARDS__OFF
    v_color0 = a_color0;
#endif
#ifdef RENDER_AS_BILLBOARDS__ON
    v_color0 = vec4(1.0);
#endif
    v_ditheringAndMaskTinting = vec2(float(var_d0d1e & 1u), float(var_d0d1e & 2u));
#ifdef RENDER_AS_BILLBOARDS__OFF
    v_fog = vec4(FogColor.xyz, clamp((((length(ViewPositionAndTime.xyz - var_35d42) / var_870be.z) + RenderChunkFogAlpha.x) - var_870be.x) / (var_870be.y - var_870be.x), 0.0, 1.0));
#endif
#ifdef RENDER_AS_BILLBOARDS__ON
    v_fog = vec4(FogColor.xyz, clamp((((length(ViewPositionAndTime.xyz - var_4e1ae) / var_870be.z) + RenderChunkFogAlpha.x) - var_870be.x) / (var_870be.y - var_870be.x), 0.0, 1.0));
#endif
    v_lightmapUV = vec2(clamp(float(var_960bd & 15u) * 0.0625, 0.0, 1.0), clamp(float((var_960bd & 240u) >> uint(4)) * 0.0625, 0.0, 1.0));
    v_texcoord0 = a_texcoord0;
    v_worldPos = var_35d42;
    v_worldPosition = vec4(var_a77b2.xyz, 0.0);
    gl_Position = var_d80ab;
}
