#version 310 es

/*
* Available Macros:
*
* Passes:
* - MIN_MAX_DOWN_SAMPLE_PASS (not used)
* - MIN_MAX_INITIALIZE_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_PreviousMip;
* - uniform lowp sampler2D s_RasterColor;
*
* Uniforms:
* - uniform vec4 MipLevel;
* - uniform vec4 MipResolutionAndRecipResolution;
* - uniform vec4 PreviousMipResolutionAndRecipResolution;
* - uniform vec4 ScreenSize;
* - uniform vec4 Thickness;
* - uniform vec4 ViewportScale;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_PreviousMip;
uniform highp vec4 MipLevel;
uniform highp vec4 PreviousMipResolutionAndRecipResolution;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_785d2 = vec4(0.0);
    highp vec4 var_ae6d9 = vec4(0.0);
    highp vec2 var_55f48 = textureLod(s_PreviousMip, v_texcoord0.xy + (vec2(-0.5) * PreviousMipResolutionAndRecipResolution.zw), MipLevel.x).xy;
    var_785d2.x = 1.0 - var_55f48.x;
    var_ae6d9.x = 1.0 - var_55f48.y;
    var_55f48 = textureLod(s_PreviousMip, v_texcoord0.xy + (vec2(0.5, -0.5) * PreviousMipResolutionAndRecipResolution.zw), MipLevel.x).xy;
    var_785d2.y = 1.0 - var_55f48.x;
    var_ae6d9.y = 1.0 - var_55f48.y;
    var_55f48 = textureLod(s_PreviousMip, v_texcoord0.xy + (vec2(-0.5, 0.5) * PreviousMipResolutionAndRecipResolution.zw), MipLevel.x).xy;
    var_785d2.z = 1.0 - var_55f48.x;
    var_ae6d9.z = 1.0 - var_55f48.y;
    var_55f48 = textureLod(s_PreviousMip, v_texcoord0.xy + (vec2(0.5) * PreviousMipResolutionAndRecipResolution.zw), MipLevel.x).xy;
    var_785d2.w = 1.0 - var_55f48.x;
    var_ae6d9.w = 1.0 - var_55f48.y;
    highp vec2 var_52932 = min(var_785d2.xy, var_785d2.zw);
    highp vec2 var_56b93 = max(var_ae6d9.xy, var_ae6d9.zw);
    bgfx_FragColor = vec4(1.0 - min(var_52932.x, var_52932.y), 1.0 - max(var_56b93.x, var_56b93.y), 0.0, 0.0);
}
