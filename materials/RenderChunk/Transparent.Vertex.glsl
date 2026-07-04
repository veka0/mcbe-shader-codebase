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
out vec4 v_color0;
out float v_dithering;
out vec4 v_fog;
out vec2 v_lightmapUV;
centroid out vec2 v_texcoord0;
out vec3 v_worldPos;
void main() {
#if defined(INSTANCING__OFF) && defined(RENDER_AS_BILLBOARDS__OFF)
    vec4 var_93fa5 = u_model[0] * vec4(a_position, 1.0);
#endif
#ifdef INSTANCING__ON
    vec4 var_78b44 = i_data1;
    vec4 var_e67a8 = i_data2;
    vec4 var_1b7f0 = i_data3;
    mat4 var_cc6b6;
    var_cc6b6[0] = vec4(var_78b44.x, var_e67a8.x, var_1b7f0.x, 0.0);
    var_cc6b6[1] = vec4(var_78b44.y, var_e67a8.y, var_1b7f0.y, 0.0);
    var_cc6b6[2] = vec4(var_78b44.z, var_e67a8.z, var_1b7f0.z, 0.0);
    var_cc6b6[3] = vec4(var_78b44.w, var_e67a8.w, var_1b7f0.w, 1.0);
#endif
#if defined(INSTANCING__ON) && defined(RENDER_AS_BILLBOARDS__OFF)
    vec4 var_93fa5 = var_cc6b6 * vec4(a_position, 1.0);
#endif
#ifdef RENDER_AS_BILLBOARDS__OFF
    vec3 var_1c444 = var_93fa5.xyz;
#endif
#if defined(INSTANCING__OFF) && defined(RENDER_AS_BILLBOARDS__ON)
    vec3 var_1c444 = (u_model[0] * vec4(a_position, 1.0)).xyz;
#endif
#if defined(INSTANCING__ON) && defined(RENDER_AS_BILLBOARDS__ON)
    vec3 var_1c444 = (var_cc6b6 * vec4(a_position, 1.0)).xyz;
#endif
    vec4 var_9d5b1 = a_color0;
#ifdef RENDER_AS_BILLBOARDS__ON
    vec3 var_eb4e0 = var_1c444 + vec3(0.5);
    vec3 var_f280f = normalize(var_eb4e0 - ViewPositionAndTime.xyz);
    vec3 var_d3ea2 = normalize(cross(vec3(0.0, 1.0, 0.0), var_f280f));
    vec3 var_c39b1 = a_color0.xyz;
    vec3 var_b5c08 = var_eb4e0 - ((cross(var_f280f, var_d3ea2) * (var_c39b1.z - 0.5)) + (var_d3ea2 * (var_c39b1.x - 0.5)));
    float var_e3e0a = length(ViewPositionAndTime.xyz - var_b5c08);
#endif
#ifdef RENDER_AS_BILLBOARDS__OFF
    float var_e3e0a = length(ViewPositionAndTime.xyz - var_1c444);
#endif
    vec4 var_ade36 = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
    mat4 var_dd47a = u_proj;
    var_dd47a[2].x += SubPixelOffset.x;
    var_dd47a[2].y -= SubPixelOffset.y;
#ifdef RENDER_AS_BILLBOARDS__OFF
    vec4 var_ca76d = a_color0;
#endif
#ifdef RENDER_AS_BILLBOARDS__ON
    vec4 var_ca76d = vec4(1.0);
#endif
    if (var_9d5b1.w < 0.949999988079071044921875)
    {
        vec4 var_cb46d = mix(FogAndDistanceControl, vec4(0.9900000095367431640625, 1.0, 100000.0, 100000.0), bvec4(MeshContext.x > 0.5));
        var_ca76d.w = mix(var_9d5b1.w, 1.0, clamp(var_e3e0a / var_cb46d.w, 0.0, 1.0));
    }
    vec2 var_e91ee = a_texcoord1;
    uint var_960bd = uint(floor(var_e91ee.x * 255.0));
    v_color0 = var_ca76d;
    v_dithering = float(uint(floor(var_e91ee.y * 255.0)) & 1u);
    v_fog = vec4(FogColor.xyz, clamp((((var_e3e0a / var_ade36.z) + RenderChunkFogAlpha.x) - var_ade36.x) / (var_ade36.y - var_ade36.x), 0.0, 1.0));
    v_lightmapUV = vec2(clamp(float(var_960bd & 15u) * 0.0625, 0.0, 1.0), clamp(float((var_960bd & 240u) >> uint(4)) * 0.0625, 0.0, 1.0));
    v_texcoord0 = a_texcoord0;
    v_worldPos = var_1c444;
#ifdef RENDER_AS_BILLBOARDS__OFF
    gl_Position = var_dd47a * (u_view * vec4(var_93fa5.xyz, 1.0));
#endif
#ifdef RENDER_AS_BILLBOARDS__ON
    gl_Position = var_dd47a * (u_view * vec4(var_b5c08, 1.0));
#endif
}
