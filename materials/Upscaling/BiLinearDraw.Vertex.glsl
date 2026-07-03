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

in vec3 a_position;
in vec2 a_texcoord0;
out vec2 v_texcoord0;
void main() {
    vec4 var_c3366 = vec4(a_position, 1.0);
    vec2 var_19dcd = (var_c3366.xy * 2.0) - vec2(1.0);
    v_texcoord0 = a_texcoord0;
    gl_Position = vec4(var_19dcd.x, var_19dcd.y, var_c3366.z, var_c3366.w);
}
