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
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
#ifdef DITHERING__ON
    highp mat4 View = u_view;
#endif
    highp vec4 var_33cd4 = v_color0;
#ifdef DITHERING__ON
    highp vec2 var_4f8e7 = v_ditheringAndMaskTinting;
#endif
    highp vec4 var_e60df = texture(s_MatTexture, v_texcoord0);
    var_e60df.w *= var_33cd4.w;
#ifdef DITHERING__OFF
    highp vec4 var_15f8b = var_e60df;
#endif
#ifdef DITHERING__ON
    highp vec3 var_82cf8 = var_e60df.xyz * v_color0.xyz;
#endif
#ifdef DITHERING__OFF
    highp vec3 var_9ed97 = var_15f8b.xyz * v_color0.xyz;
    var_e60df = vec4(var_9ed97.x, var_9ed97.y, var_9ed97.z, var_15f8b.w);
#endif
#ifdef DITHERING__ON
    var_e60df = vec4(var_82cf8.x, var_82cf8.y, var_82cf8.z, var_e60df.w);
    highp vec2 var_25b3d = DitherParams2[2].xy;
    if (var_4f8e7.x > 0.5)
    {
        highp vec4 var_bb748 = v_clipPosition;
        highp vec2 var_b2538 = floor(((((v_clipPosition.xyz / vec3(var_bb748.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[2].z)) * DitherParams2[2].z;
        highp vec2 var_39f2b = floor(var_b2538 * 0.25);
        highp vec2 var_45856 = floor(var_b2538 * 0.5);
        highp vec2 var_93c64 = floor(var_b2538);
        if (smoothstep(var_25b3d.x, var_25b3d.y, dot(-normalize(vec3(View[0].z, View[1].z, View[2].z)), v_worldPosition.xyz - ViewPositionAndTime.xyz)) <= (((((((fract((var_39f2b.x * 0.5) + ((var_39f2b.y * var_39f2b.y) * 0.75)) * 0.25) + fract((var_45856.x * 0.5) + ((var_45856.y * var_45856.y) * 0.75))) * 0.25) + fract((var_93c64.x * 0.5) + ((var_93c64.y * var_93c64.y) * 0.75))) * 64.0) + 0.5) * 0.015625))
        {
            var_e60df.w = 0.0;
        }
    }
    highp vec4 var_d81ae = vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * var_e60df.xyz, var_e60df.w);
#endif
#ifdef DITHERING__OFF
    highp vec4 var_d81ae = vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * var_9ed97.xyz, var_e60df.w);
#endif
    highp vec4 var_67e99 = v_fog;
    highp vec3 var_2a3e1 = mix(var_d81ae.xyz, FogColor.xyz, vec3(var_67e99.w));
    bgfx_FragColor = vec4(var_2a3e1.x, var_2a3e1.y, var_2a3e1.z, var_d81ae.w);
}
