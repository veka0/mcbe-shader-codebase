#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - MIP_DISTANCE_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_FramebufferDepth;
* - uniform lowp sampler2D s_InputMip;
* - uniform lowp sampler2D s_OutputMip;
*
* Uniforms:
* - uniform vec4 Levels;
* - uniform mat4 SceneInverseProjection;
* - uniform vec4 ScreenSize;
*/

precision mediump float;
precision highp int;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    bgfx_FragColor = vec4(0.0);
}
