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
uniform highp vec4 MipResolutionAndRecipResolution;
uniform highp vec4 PreviousMipResolutionAndRecipResolution;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp float var_b7ab0 = (((-500.0) / ((texture(s_PreviousMip, ((floor(v_texcoord0.xy * MipResolutionAndRecipResolution.xy) * MipResolutionAndRecipResolution.zw) * MipResolutionAndRecipResolution.xy) * PreviousMipResolutionAndRecipResolution.zw).x * 999.75) - 1000.25)) - 0.25) * 0.001000250107608735561370849609375;
    bgfx_FragColor = vec4(var_b7ab0, var_b7ab0, 0.0, 0.0);
}
