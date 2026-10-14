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
* - DITHERING__OFF
* - DITHERING__ON
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* RenderAsBillboards:
* - RENDER_AS_BILLBOARDS__OFF (not used)
* - RENDER_AS_BILLBOARDS__ON (not used)
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
#ifdef DITHERING__ON
float var_466e6;
uniform highp mat4 u_view;
#endif
uniform highp sampler2D s_LightMapTexture;
uniform highp sampler2D s_MatTexture;
#ifdef SEASONS__ON
uniform highp sampler2D s_SeasonsTexture;
#endif
#ifdef DITHERING__ON
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
#endif
uniform highp vec4 FogColor;
#ifdef DITHERING__ON
uniform highp vec4 ViewPositionAndTime;
in highp vec4 v_clipPosition;
#endif
in highp vec4 v_color0;
#ifdef DITHERING__ON
in highp vec2 v_ditheringAndMaskTinting;
#endif
in highp vec4 v_fog;
in highp vec2 v_lightmapUV;
centroid in highp vec2 v_texcoord0;
#ifdef DITHERING__ON
in highp vec4 v_worldPosition;
#endif
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
#ifdef SEASONS__OFF
    highp vec4 var_d885f = texture(s_MatTexture, v_texcoord0);
#endif
#ifdef SEASONS__ON
    highp vec4 var_31ff7 = texture(s_MatTexture, v_texcoord0);
#endif
#if defined(DITHERING__OFF) && defined(SEASONS__OFF)
    if (false || (var_d885f.w < 0.5))
#endif
#if defined(DITHERING__OFF) && defined(SEASONS__ON)
    if (false || (var_31ff7.w < 0.5))
#endif
#ifdef DITHERING__ON
    highp vec2 var_42b21 = DitherParams2[2].xy;
    bool var_55e4d;
    if (v_ditheringAndMaskTinting.x > 0.5)
#endif
    {
#ifdef DITHERING__ON
        highp mat4 var_4228f = u_view;
        highp vec2 var_9b116 = floor(((((v_clipPosition.xyz / vec3(v_clipPosition.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[2].z)) * DitherParams2[2].z;
        highp vec2 var_765a5 = floor(var_9b116 * 0.25);
        highp vec2 var_9b96b = floor(var_9b116 * 0.5);
        highp vec2 var_9ed5c = floor(var_9b116);
        var_55e4d = smoothstep(var_42b21.x, var_42b21.y, dot(-normalize(vec4(var_4228f[0].z, var_4228f[1].z, var_4228f[2].z, var_466e6).xyz), v_worldPosition.xyz - ViewPositionAndTime.xyz)) <= (((((((fract((var_765a5.x * 0.5) + ((var_765a5.y * var_765a5.y) * 0.75)) * 0.25) + fract((var_9b96b.x * 0.5) + ((var_9b96b.y * var_9b96b.y) * 0.75))) * 0.25) + fract((var_9ed5c.x * 0.5) + ((var_9ed5c.y * var_9ed5c.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        var_55e4d = false;
    }
#endif
#if defined(DITHERING__ON) && defined(SEASONS__OFF)
    if (var_55e4d || (var_d885f.w < 0.5))
#endif
#if defined(DITHERING__ON) && defined(SEASONS__ON)
    if (var_55e4d || (var_31ff7.w < 0.5))
#endif
#ifdef DITHERING__ON
    {
#endif
        discard;
    }
#ifdef SEASONS__ON
    highp vec3 var_861c6 = v_color0.xyz;
    highp vec4 var_d885f = var_31ff7;
#endif
#ifdef SEASONS__OFF
    highp vec4 var_1179b = var_d885f;
    highp vec3 var_41041 = var_1179b.xyz * v_color0.xyz;
#endif
#ifdef SEASONS__ON
    highp vec3 var_41041 = var_31ff7.xyz * mix(vec3(1.0), texture(s_SeasonsTexture, v_color0.xy).xyz * 2.0, vec3(var_861c6.z));
#endif
    var_d885f.x = var_41041.x;
    var_d885f.y = var_41041.y;
    var_d885f.z = var_41041.z;
#ifdef SEASONS__ON
    highp vec4 var_0fcb9 = var_d885f;
    highp vec3 var_4e36a = var_0fcb9.xyz * vec3(v_color0.w);
    var_d885f.x = var_4e36a.x;
    var_d885f.y = var_4e36a.y;
    var_d885f.z = var_4e36a.z;
    var_d885f.w = 1.0;
    var_31ff7 = var_d885f;
    highp vec4 var_f1834 = vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * var_d885f.xyz, var_31ff7.w);
#endif
#ifdef SEASONS__OFF
    highp vec4 var_f1834 = vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * var_d885f.xyz, var_d885f.w);
#endif
    highp vec4 var_72c1b = var_f1834;
    highp vec3 var_8a63e = mix(var_f1834.xyz, FogColor.xyz, vec3(v_fog.w));
    var_72c1b.x = var_8a63e.x;
    var_72c1b.y = var_8a63e.y;
    var_72c1b.z = var_8a63e.z;
    bgfx_FragData0 = var_72c1b;
}
