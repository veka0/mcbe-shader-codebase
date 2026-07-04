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
* - uniform vec4 MaterialID;
* - uniform vec4 MeshContext;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 ViewPositionAndTime;
*/

precision mediump float;
precision highp int;
#ifdef DITHERING__ON
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
in highp vec2 v_ditheringAndMaskTinting;
in highp vec4 v_fog;
in highp vec2 v_lightmapUV;
centroid in highp vec2 v_texcoord0;
#ifdef DITHERING__ON
in highp vec4 v_worldPosition;
#endif
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
#if defined(DITHERING__OFF) && defined(SEASONS__ON)
    highp vec4 var_e49ec = v_color0;
#endif
#ifdef DITHERING__ON
    highp mat4 View = u_view;
#endif
#if defined(DITHERING__ON) && defined(SEASONS__ON)
    highp vec4 var_e49ec = v_color0;
#endif
    highp vec2 var_4f8e7 = v_ditheringAndMaskTinting;
    highp vec4 var_af465 = texture(s_MatTexture, v_texcoord0);
#ifdef DITHERING__OFF
    highp vec2 var_95233 = vec2(0.0);
#endif
#ifdef DITHERING__ON
    highp vec2 var_b246c = DitherParams2[2].xy;
#endif
    bool var_b8d8b;
    if (var_4f8e7.x > 0.5)
    {
#ifdef DITHERING__OFF
        highp vec2 var_01f17 = floor(vec2(0.0));
        highp vec2 var_75d5b = var_01f17;
        highp vec2 var_51242 = floor(vec2(0.0));
        highp vec2 var_7633c = var_51242;
        highp vec2 var_39049 = floor(vec2(0.0));
        highp vec2 var_9c296 = var_39049;
        var_b8d8b = smoothstep(var_95233.x, var_95233.y, 0.0) <= (((((((fract((var_75d5b.x * 0.5) + ((var_75d5b.y * var_75d5b.y) * 0.75)) * 0.25) + fract((var_7633c.x * 0.5) + ((var_7633c.y * var_7633c.y) * 0.75))) * 0.25) + fract((var_9c296.x * 0.5) + ((var_9c296.y * var_9c296.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
#endif
#ifdef DITHERING__ON
        highp vec4 var_bb748 = v_clipPosition;
        highp vec2 var_b2538 = floor(((((v_clipPosition.xyz / vec3(var_bb748.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[2].z)) * DitherParams2[2].z;
        highp vec2 var_42f61 = floor(var_b2538 * 0.25);
        highp vec2 var_a0c62 = floor(var_b2538 * 0.5);
        highp vec2 var_a9af4 = floor(var_b2538);
        var_b8d8b = smoothstep(var_b246c.x, var_b246c.y, dot(-normalize(vec3(View[0].z, View[1].z, View[2].z)), v_worldPosition.xyz - ViewPositionAndTime.xyz)) <= (((((((fract((var_42f61.x * 0.5) + ((var_42f61.y * var_42f61.y) * 0.75)) * 0.25) + fract((var_a0c62.x * 0.5) + ((var_a0c62.y * var_a0c62.y) * 0.75))) * 0.25) + fract((var_a9af4.x * 0.5) + ((var_a9af4.y * var_a9af4.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
#endif
    }
    else
    {
        var_b8d8b = false;
    }
    if (var_b8d8b || (var_af465.w < 0.5))
    {
        discard;
    }
#ifdef SEASONS__OFF
    highp vec4 var_15f8b = var_af465;
    highp vec3 var_26419 = var_15f8b.xyz * v_color0.xyz;
    var_af465 = vec4(var_26419.x, var_26419.y, var_26419.z, var_15f8b.w);
#endif
#ifdef SEASONS__ON
    highp vec3 var_2455e = v_color0.xyz;
    highp vec3 var_2b07f = (var_af465.xyz * mix(vec3(1.0), texture(s_SeasonsTexture, v_color0.xy).xyz * 2.0, vec3(var_2455e.z))).xyz * vec3(var_e49ec.w);
    highp vec4 var_26419 = vec4(var_2b07f.x, var_2b07f.y, var_2b07f.z, var_af465.w);
    var_26419.w = 1.0;
    var_af465 = var_26419;
#endif
    highp vec4 var_16cd7 = vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * var_26419.xyz, var_af465.w);
    highp vec4 var_67e99 = v_fog;
    highp vec3 var_2a3e1 = mix(var_16cd7.xyz, FogColor.xyz, vec3(var_67e99.w));
    bgfx_FragColor = vec4(var_2a3e1.x, var_2a3e1.y, var_2a3e1.z, var_16cd7.w);
}
