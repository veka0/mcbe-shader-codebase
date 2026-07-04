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

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;
void main() {
}
