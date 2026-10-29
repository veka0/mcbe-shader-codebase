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
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* Seasons:
* - SEASONS__OFF
* - SEASONS__ON
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

precision mediump float;
precision highp int;
uniform highp sampler2D s_LightMapTexture;
uniform highp sampler2D s_MatTexture;
#ifdef SEASONS__ON
uniform highp sampler2D s_SeasonsTexture;
#endif
uniform highp vec4 FogColor;
in highp vec4 v_color0;
#ifdef SEASONS__OFF
in highp vec2 v_ditheringAndMaskTinting;
#endif
in highp vec4 v_fog;
in highp vec2 v_lightmapUV;
centroid in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
#ifdef SEASONS__ON
    highp vec4 var_fb4fb = texture(s_MatTexture, v_texcoord0);
#endif
#ifdef SEASONS__OFF
    highp vec4 var_1459a = texture(s_MatTexture, v_texcoord0);
    if (v_ditheringAndMaskTinting.y > 0.5)
    {
        highp vec4 var_ec353 = var_1459a;
        highp float var_7a181 = var_1459a.w;
        highp vec3 var_d8fa6 = mix(var_ec353.xyz, var_ec353.xyz * v_color0.xyz, vec3(var_7a181));
        var_1459a.x = var_d8fa6.x;
        var_1459a.y = var_d8fa6.y;
        var_1459a.z = var_d8fa6.z;
        highp vec4 var_8e56a = var_1459a;
        highp vec3 var_a3d7a = var_8e56a.xyz * v_color0.w;
        var_1459a.x = var_a3d7a.x;
        var_1459a.y = var_a3d7a.y;
        var_1459a.z = var_a3d7a.z;
        var_1459a.w = 1.0;
    }
    else
    {
        highp vec4 var_bc465 = var_1459a;
        highp vec3 var_30e20 = var_bc465.xyz * v_color0.xyz;
        var_1459a.x = var_30e20.x;
        var_1459a.y = var_30e20.y;
        var_1459a.z = var_30e20.z;
        var_1459a.w = v_color0.w;
    }
#endif
#ifdef SEASONS__ON
    highp vec3 var_861c6 = v_color0.xyz;
    highp vec4 var_b1dcb = var_fb4fb;
    highp vec3 var_32afa = var_fb4fb.xyz * mix(vec3(1.0), texture(s_SeasonsTexture, v_color0.xy).xyz * 2.0, vec3(var_861c6.z));
    var_b1dcb.x = var_32afa.x;
    var_b1dcb.y = var_32afa.y;
    var_b1dcb.z = var_32afa.z;
    highp vec4 var_0fcb9 = var_b1dcb;
    highp vec3 var_4e36a = var_0fcb9.xyz * vec3(v_color0.w);
    var_b1dcb.x = var_4e36a.x;
    var_b1dcb.y = var_4e36a.y;
    var_b1dcb.z = var_4e36a.z;
    var_b1dcb.w = 1.0;
    highp vec4 var_99b2d = var_b1dcb;
    highp vec4 var_f1834 = vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * var_b1dcb.xyz, var_99b2d.w);
#endif
#ifdef SEASONS__OFF
    highp vec4 var_f1834 = vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * var_1459a.xyz, var_1459a.w);
#endif
    highp vec4 var_72c1b = var_f1834;
    highp vec3 var_8a63e = mix(var_f1834.xyz, FogColor.xyz, vec3(v_fog.w));
    var_72c1b.x = var_8a63e.x;
    var_72c1b.y = var_8a63e.y;
    var_72c1b.z = var_8a63e.z;
    bgfx_FragData0 = var_72c1b;
}
