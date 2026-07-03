#version 310 es

/*
* Available Macros:
*
* Passes:
* - BI_LINEAR_COMPUTE_PASS (not used)
* - BI_LINEAR_DRAW_PASS (not used)
* - FALLBACK_PASS (not used)
* - TAAU_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_InputBufferMotionVectors;
* - uniform lowp sampler2D s_InputFinalColor;
* - uniform lowp sampler2D s_InputTAAHistory;
* - uniform lowp sampler2D s_UpscalingOutput;
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
* - uniform vec4 SubPixelJitter;
* - uniform vec4 TAAUpscalingParameters;
*/

void main() {
    gl_Position = vec4(0.0);
}
