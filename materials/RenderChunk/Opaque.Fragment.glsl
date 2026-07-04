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
    highp vec4 var_248f2 = v_color0;
#ifdef SEASONS__OFF
    highp vec2 var_7bd33 = v_ditheringAndMaskTinting;
#endif
#ifdef SEASONS__ON
    highp vec4 var_b65d1 = texture(s_MatTexture, v_texcoord0);
#endif
#ifdef SEASONS__OFF
    highp vec4 var_924bf = texture(s_MatTexture, v_texcoord0);
    if (var_7bd33.y > 0.5)
    {
        highp vec3 var_c7ec1 = mix(var_924bf.xyz, var_924bf.xyz * v_color0.xyz, vec3(var_924bf.w));
        var_924bf = vec4(var_c7ec1.x, var_c7ec1.y, var_c7ec1.z, var_924bf.w);
    }
    else
    {
        highp vec3 var_55928 = var_924bf.xyz * v_color0.xyz;
        var_924bf = vec4(var_55928.x, var_55928.y, var_55928.z, var_924bf.w);
    }
    highp vec3 var_86c71 = var_924bf.xyz * var_248f2.w;
    var_924bf = vec4(var_86c71.x, var_86c71.y, var_86c71.z, var_924bf.w);
#endif
#ifdef SEASONS__ON
    highp vec3 var_2455e = v_color0.xyz;
    highp vec3 var_2b07f = (var_b65d1.xyz * mix(vec3(1.0), texture(s_SeasonsTexture, v_color0.xy).xyz * 2.0, vec3(var_2455e.z))).xyz * vec3(var_248f2.w);
    highp vec4 var_945ff = vec4(var_2b07f.x, var_2b07f.y, var_2b07f.z, var_b65d1.w);
#endif
#ifdef SEASONS__OFF
    var_924bf.w = 1.0;
#endif
#ifdef SEASONS__ON
    var_945ff.w = 1.0;
    highp vec4 var_924bf = var_945ff;
    var_924bf.w = 1.0;
#endif
    highp vec4 var_16cd7 = vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * var_924bf.xyz, var_924bf.w);
    highp vec4 var_67e99 = v_fog;
    highp vec3 var_2a3e1 = mix(var_16cd7.xyz, FogColor.xyz, vec3(var_67e99.w));
    bgfx_FragColor = vec4(var_2a3e1.x, var_2a3e1.y, var_2a3e1.z, var_16cd7.w);
}
