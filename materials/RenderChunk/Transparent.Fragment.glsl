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
* - DITHERING__ON
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
float var_8909c;
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
in highp vec2 v_ditheringAndMaskTinting;
in highp vec4 v_fog;
in highp vec2 v_lightmapUV;
centroid in highp vec2 v_texcoord0;
#ifdef DITHERING__ON
in highp vec4 v_worldPosition;
#endif
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_0c498 = texture(s_MatTexture, v_texcoord0);
    if (v_ditheringAndMaskTinting.y > 0.5)
    {
        highp vec4 var_ec353 = var_0c498;
        highp float var_7a181 = var_0c498.w;
        highp vec3 var_d8fa6 = mix(var_ec353.xyz, var_ec353.xyz * v_color0.xyz, vec3(var_7a181));
        var_0c498.x = var_d8fa6.x;
        var_0c498.y = var_d8fa6.y;
        var_0c498.z = var_d8fa6.z;
        highp vec4 var_8e56a = var_0c498;
        highp vec3 var_a3d7a = var_8e56a.xyz * v_color0.w;
        var_0c498.x = var_a3d7a.x;
        var_0c498.y = var_a3d7a.y;
        var_0c498.z = var_a3d7a.z;
        var_0c498.w = 1.0;
    }
    else
    {
        highp vec4 var_bc465 = var_0c498;
        highp vec3 var_30e20 = var_bc465.xyz * v_color0.xyz;
        var_0c498.x = var_30e20.x;
        var_0c498.y = var_30e20.y;
        var_0c498.z = var_30e20.z;
        var_0c498.w *= v_color0.w;
    }
#ifdef DITHERING__ON
    highp vec2 var_8dad0 = DitherParams2[2].xy;
    if (v_ditheringAndMaskTinting.x > 0.5)
    {
        highp mat4 var_06d92 = u_view;
        highp vec2 var_9b116 = floor(((((v_clipPosition.xyz / vec3(v_clipPosition.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[2].z)) * DitherParams2[2].z;
        highp vec2 var_ea24e = floor(var_9b116 * 0.25);
        highp vec2 var_ff607 = floor(var_9b116 * 0.5);
        highp vec2 var_0a695 = floor(var_9b116);
        if (smoothstep(var_8dad0.x, var_8dad0.y, dot(-normalize(vec4(var_06d92[0].z, var_06d92[1].z, var_06d92[2].z, var_8909c).xyz), v_worldPosition.xyz - ViewPositionAndTime.xyz)) <= (((((((fract((var_ea24e.x * 0.5) + ((var_ea24e.y * var_ea24e.y) * 0.75)) * 0.25) + fract((var_ff607.x * 0.5) + ((var_ff607.y * var_ff607.y) * 0.75))) * 0.25) + fract((var_0a695.x * 0.5) + ((var_0a695.y * var_0a695.y) * 0.75))) * 64.0) + 0.5) * 0.015625))
        {
            var_0c498.w = 0.0;
        }
    }
#endif
    highp vec4 var_49453 = vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * var_0c498.xyz, var_0c498.w);
    highp vec4 var_72c1b = var_49453;
    highp vec3 var_8a63e = mix(var_49453.xyz, FogColor.xyz, vec3(v_fog.w));
    var_72c1b.x = var_8a63e.x;
    var_72c1b.y = var_8a63e.y;
    var_72c1b.z = var_8a63e.z;
    bgfx_FragData0 = var_72c1b;
}
