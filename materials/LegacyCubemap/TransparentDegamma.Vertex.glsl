#version 310 es

/*
* Available Macros:
*
* Passes:
* - FORCE_FORWARD_PBR_OPAQUE_PASS (not used)
* - TRANSPARENT_PASS (not used)
* - TRANSPARENT_DEGAMMA_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
*
* Uniforms:
* - uniform vec4 ColorGrading_OptimizeGammaCorrection;
* - uniform mat4 CubemapRotation;
* - uniform vec4 PreExposureEnabled;
*/

uniform mat4 CubemapRotation;
uniform mat4 u_modelViewProj;
in vec3 a_position;
in vec2 a_texcoord0;
out vec2 v_texcoord0;
void main() {
    v_texcoord0 = a_texcoord0;
    gl_Position = u_modelViewProj * (CubemapRotation * vec4(a_position, 1.0));
}
