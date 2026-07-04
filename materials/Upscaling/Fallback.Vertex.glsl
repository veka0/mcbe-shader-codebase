#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - TAAU_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_InputBufferMotionVectors;
* - uniform lowp sampler2D s_InputFinalColor;
* - uniform lowp sampler2D s_InputTAAHistory;
*
* Uniforms:
* - uniform mat4 CurrentViewProjectionMatrixUniform;
* - uniform vec4 CurrentWorldOrigin;
* - uniform vec4 DisplayResolution;
* - uniform mat4 PreviousViewProjectionMatrixUniform;
* - uniform vec4 PreviousWorldOrigin;
* - uniform vec4 RecipDisplayResolution;
* - uniform vec4 RenderResolution;
* - uniform vec4 ResolutionRatiosAndFPEpsilon;
* - uniform vec4 SubPixelJitterAndValidHistory;
* - uniform vec4 TAAUpscalingParameters;
*/

out vec2 v_texcoord0;
void main() {
    v_texcoord0 = vec2(0.0);
    gl_Position = vec4(0.0);
}
