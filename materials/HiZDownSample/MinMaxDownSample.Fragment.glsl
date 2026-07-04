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
* - uniform vec4 ViewportScale;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_PreviousMip;
uniform highp vec4 MipLevel;
uniform highp vec4 MipResolutionAndRecipResolution;
uniform highp vec4 PreviousMipResolutionAndRecipResolution;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec2 var_2a4d8 = floor(v_texcoord0.xy * MipResolutionAndRecipResolution.xy) * MipResolutionAndRecipResolution.zw;
    highp vec4 var_5a19e = vec4(0.0);
    highp vec4 var_a035d = vec4(0.0);
    highp vec2 var_33515 = textureLod(s_PreviousMip, var_2a4d8, MipLevel.x).xy;
    var_5a19e.x = var_33515.x;
    var_a035d.x = var_33515.y;
    var_33515 = textureLod(s_PreviousMip, var_2a4d8 + (vec2(1.0, 0.0) * PreviousMipResolutionAndRecipResolution.zw), MipLevel.x).xy;
    var_5a19e.y = var_33515.x;
    var_a035d.y = var_33515.y;
    var_33515 = textureLod(s_PreviousMip, var_2a4d8 + PreviousMipResolutionAndRecipResolution.zw, MipLevel.x).xy;
    var_5a19e.z = var_33515.x;
    var_a035d.z = var_33515.y;
    var_33515 = textureLod(s_PreviousMip, var_2a4d8 + (vec2(0.0, 1.0) * PreviousMipResolutionAndRecipResolution.zw), MipLevel.x).xy;
    var_5a19e.w = var_33515.x;
    var_a035d.w = var_33515.y;
    highp vec2 var_efc5a = min(var_5a19e.xy, var_5a19e.zw);
    highp vec2 var_2da52 = max(var_a035d.xy, var_a035d.zw);
    bgfx_FragColor = vec4(min(var_efc5a.x, var_efc5a.y), max(var_2da52.x, var_2da52.y), 0.0, 0.0);
}
