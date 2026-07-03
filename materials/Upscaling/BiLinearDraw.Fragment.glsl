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

precision mediump float;
precision highp int;
uniform highp sampler2D s_InputFinalColor;
uniform highp vec4 DisplayResolution;
uniform highp vec4 RenderResolution;
uniform highp vec4 ResolutionRatiosAndFPEpsilon;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec2 var_c866d = DisplayResolution.xy * v_texcoord0;
    highp vec2 var_25be3 = (vec2(float(uint(var_c866d.x)) + 0.5, float(uint(var_c866d.y)) + 0.5) * ResolutionRatiosAndFPEpsilon.x) - vec2(0.5);
    highp vec2 var_e8534 = var_25be3;
    highp vec2 var_f41ca = max(vec2(0.0), floor(var_25be3));
    highp vec2 var_9d116 = min(ceil(var_25be3), vec2(RenderResolution.x - 1.0, RenderResolution.y - 1.0));
    highp float var_84d38 = clamp((var_e8534.x - var_f41ca.x) / (var_9d116.x - var_f41ca.x), 0.0, 1.0);
    bgfx_FragColor = vec4(mix(mix(texelFetch(s_InputFinalColor, ivec2(int(var_f41ca.x), int(var_f41ca.y)), 0), texelFetch(s_InputFinalColor, ivec2(int(var_9d116.x), int(var_f41ca.y)), 0), vec4(var_84d38)), mix(texelFetch(s_InputFinalColor, ivec2(int(var_f41ca.x), int(var_9d116.y)), 0), texelFetch(s_InputFinalColor, ivec2(int(var_9d116.x), int(var_9d116.y)), 0), vec4(var_84d38)), vec4(clamp((var_e8534.y - var_f41ca.y) / (var_9d116.y - var_f41ca.y), 0.0, 1.0))).xyz, 0.0);
}
