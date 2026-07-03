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
uniform highp vec4 FogColor;
in highp vec4 v_fog;
in highp vec2 v_lightmapUV;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_72347 = vec4(texture(s_LightMapTexture, v_lightmapUV).xyz, 1.0);
    highp vec4 var_67e99 = v_fog;
    highp vec3 var_2a3e1 = mix(var_72347.xyz, FogColor.xyz, vec3(var_67e99.w));
    bgfx_FragColor = vec4(var_2a3e1.x, var_2a3e1.y, var_2a3e1.z, var_72347.w);
}
