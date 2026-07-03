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
* - uniform vec4 AmbientOcclusionParameters;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 GlobalRoughness;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MaterialID;
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
in highp vec4 v_fog;
in highp vec2 v_lightmapUV;
centroid in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
#ifdef SEASONS__ON
    highp vec4 var_6c86c = v_color0;
#endif
    highp vec4 var_950e4 = texture(s_MatTexture, v_texcoord0);
    if (var_950e4.w < 0.5)
    {
        discard;
    }
#ifdef SEASONS__OFF
    highp vec4 var_15f8b = var_950e4;
    highp vec3 var_26419 = var_15f8b.xyz * v_color0.xyz;
    var_950e4 = vec4(var_26419.x, var_26419.y, var_26419.z, var_15f8b.w);
#endif
#ifdef SEASONS__ON
    highp vec3 var_2455e = v_color0.xyz;
    highp vec3 var_2b07f = (var_950e4.xyz * mix(vec3(1.0), texture(s_SeasonsTexture, v_color0.xy).xyz * 2.0, vec3(var_2455e.z))).xyz * vec3(var_6c86c.w);
    highp vec4 var_26419 = vec4(var_2b07f.x, var_2b07f.y, var_2b07f.z, var_950e4.w);
    var_26419.w = 1.0;
    var_950e4 = var_26419;
#endif
    highp vec4 var_16cd7 = vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * var_26419.xyz, var_950e4.w);
    highp vec4 var_67e99 = v_fog;
    highp vec3 var_2a3e1 = mix(var_16cd7.xyz, FogColor.xyz, vec3(var_67e99.w));
    bgfx_FragColor = vec4(var_2a3e1.x, var_2a3e1.y, var_2a3e1.z, var_16cd7.w);
}
