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
#ifdef SEASONS__ON
    highp vec4 var_6c86c = v_color0;
#endif
#ifdef DITHERING__ON
    highp vec2 var_4f8e7 = v_ditheringAndMaskTinting;
#endif
    highp vec4 var_cf110 = texture(s_MatTexture, v_texcoord0);
#ifdef DITHERING__OFF
    if (false || (var_cf110.w < 0.5))
#endif
#ifdef DITHERING__ON
    highp vec2 var_42b21 = DitherParams2[2].xy;
    bool var_2935c;
    if (var_4f8e7.x > 0.5)
#endif
    {
#ifdef DITHERING__ON
        highp mat4 var_4228f = u_view;
        highp vec4 var_bb748 = v_clipPosition;
        highp vec2 var_b2538 = floor(((((v_clipPosition.xyz / vec3(var_bb748.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[2].z)) * DitherParams2[2].z;
        highp vec2 var_765a5 = floor(var_b2538 * 0.25);
        highp vec2 var_9b96b = floor(var_b2538 * 0.5);
        highp vec2 var_9ed5c = floor(var_b2538);
        var_2935c = smoothstep(var_42b21.x, var_42b21.y, dot(-normalize(vec4(var_4228f[0].z, var_4228f[1].z, var_4228f[2].z, var_466e6).xyz), v_worldPosition.xyz - ViewPositionAndTime.xyz)) <= (((((((fract((var_765a5.x * 0.5) + ((var_765a5.y * var_765a5.y) * 0.75)) * 0.25) + fract((var_9b96b.x * 0.5) + ((var_9b96b.y * var_9b96b.y) * 0.75))) * 0.25) + fract((var_9ed5c.x * 0.5) + ((var_9ed5c.y * var_9ed5c.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        var_2935c = false;
    }
    if (var_2935c || (var_cf110.w < 0.5))
    {
#endif
        discard;
    }
#ifdef SEASONS__OFF
    highp vec4 var_15f8b = var_cf110;
    highp vec3 var_fffd0 = var_15f8b.xyz * v_color0.xyz;
    var_cf110 = vec4(var_fffd0.x, var_fffd0.y, var_fffd0.z, var_15f8b.w);
#endif
#ifdef SEASONS__ON
    highp vec3 var_2455e = v_color0.xyz;
    highp vec3 var_2b07f = (var_cf110.xyz * mix(vec3(1.0), texture(s_SeasonsTexture, v_color0.xy).xyz * 2.0, vec3(var_2455e.z))).xyz * vec3(var_6c86c.w);
    highp vec4 var_fffd0 = vec4(var_2b07f.x, var_2b07f.y, var_2b07f.z, var_cf110.w);
    var_fffd0.w = 1.0;
    var_cf110 = var_fffd0;
#endif
    highp vec4 var_713a6 = v_fog;
    bgfx_FragData0 = vec4(mix(vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * var_fffd0.xyz, var_cf110.w).xyz, FogColor.xyz, vec3(var_713a6.w)), var_cf110.w);
}
