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
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_12350 = v_color0;
#ifdef SEASONS__OFF
    highp vec2 var_7bd33 = v_ditheringAndMaskTinting;
#endif
#ifdef SEASONS__ON
    highp vec4 var_b65d1 = texture(s_MatTexture, v_texcoord0);
#endif
#ifdef SEASONS__OFF
    highp vec4 var_0b58b = texture(s_MatTexture, v_texcoord0);
    if (var_7bd33.y > 0.5)
    {
        highp vec3 var_5e4d7 = mix(var_0b58b.xyz, var_0b58b.xyz * v_color0.xyz, vec3(var_0b58b.w)).xyz * var_12350.w;
        var_0b58b = vec4(var_5e4d7.x, var_5e4d7.y, var_5e4d7.z, var_0b58b.w);
        var_0b58b.w = 1.0;
    }
    else
    {
        highp vec3 var_55928 = var_0b58b.xyz * v_color0.xyz;
        var_0b58b = vec4(var_55928.x, var_55928.y, var_55928.z, var_0b58b.w);
        var_0b58b.w = var_12350.w;
    }
#endif
#ifdef SEASONS__ON
    highp vec3 var_2455e = v_color0.xyz;
    highp vec3 var_2b07f = (var_b65d1.xyz * mix(vec3(1.0), texture(s_SeasonsTexture, v_color0.xy).xyz * 2.0, vec3(var_2455e.z))).xyz * vec3(var_12350.w);
    highp vec4 var_04100 = vec4(var_2b07f.x, var_2b07f.y, var_2b07f.z, var_b65d1.w);
    var_04100.w = 1.0;
    highp vec4 var_37c08 = var_04100;
#endif
    highp vec4 var_50a63 = v_fog;
#ifdef SEASONS__OFF
    bgfx_FragColor = vec4(mix(vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * var_0b58b.xyz, var_0b58b.w).xyz, FogColor.xyz, vec3(var_50a63.w)), var_0b58b.w);
#endif
#ifdef SEASONS__ON
    bgfx_FragColor = vec4(mix(vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * var_04100.xyz, var_37c08.w).xyz, FogColor.xyz, vec3(var_50a63.w)), var_37c08.w);
#endif
}
