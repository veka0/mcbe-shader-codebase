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
in highp vec4 v_fog;
in highp vec2 v_lightmapUV;
centroid in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_228e4 = v_color0;
    highp vec4 var_e16d7 = texture(s_MatTexture, v_texcoord0);
#ifdef SEASONS__OFF
    highp vec3 var_0255a = var_e16d7.xyz * v_color0.xyz;
#endif
#ifdef SEASONS__ON
    highp vec3 var_2455e = v_color0.xyz;
    highp vec3 var_0255a = (var_e16d7.xyz * mix(vec3(1.0), texture(s_SeasonsTexture, v_color0.xy).xyz * 2.0, vec3(var_2455e.z))).xyz * vec3(var_228e4.w);
#endif
    highp vec4 var_db98d = vec4(var_0255a.x, var_0255a.y, var_0255a.z, var_e16d7.w);
#ifdef SEASONS__OFF
    var_db98d.w = var_228e4.w;
#endif
#ifdef SEASONS__ON
    var_db98d.w = 1.0;
    highp vec4 var_99b2d = var_db98d;
    highp vec4 var_d81ae = vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * var_db98d.xyz, var_99b2d.w);
#endif
#ifdef SEASONS__OFF
    highp vec4 var_d81ae = vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * var_db98d.xyz, var_db98d.w);
#endif
    highp vec4 var_67e99 = v_fog;
    highp vec3 var_2a3e1 = mix(var_d81ae.xyz, FogColor.xyz, vec3(var_67e99.w));
    bgfx_FragColor = vec4(var_2a3e1.x, var_2a3e1.y, var_2a3e1.z, var_d81ae.w);
}
