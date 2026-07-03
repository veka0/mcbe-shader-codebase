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

void main() {
    gl_Position = vec4(0.0);
}
