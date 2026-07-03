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

layout(local_size_x = 16, local_size_y = 16, local_size_z = 1) in;
layout(location = 0, binding = 3, rgba16f) uniform writeonly highp image2D s_UpscalingOutput;
uniform highp sampler2D s_InputFinalColor;
uniform vec4 RenderResolution;
uniform vec4 ResolutionRatiosAndFPEpsilon;
void main() {
    uvec3 GlobalInvocationID = gl_GlobalInvocationID;
    vec2 var_80add = (vec2(float(GlobalInvocationID.x), float(GlobalInvocationID.y)) * ResolutionRatiosAndFPEpsilon.x) - vec2(0.5);
    vec2 var_7e373 = var_80add;
    vec2 var_cfb39 = max(vec2(0.0), floor(var_80add));
    vec2 var_461c2 = min(ceil(var_80add), vec2(RenderResolution.x - 1.0, RenderResolution.y - 1.0));
    float var_467b6 = clamp((var_7e373.x - var_cfb39.x) / (var_461c2.x - var_cfb39.x), 0.0, 1.0);
    imageStore(s_UpscalingOutput, ivec2(int(GlobalInvocationID.x), int(GlobalInvocationID.y)), mix(mix(texelFetch(s_InputFinalColor, ivec2(int(var_cfb39.x), int(var_cfb39.y)), 0), texelFetch(s_InputFinalColor, ivec2(int(var_461c2.x), int(var_cfb39.y)), 0), vec4(var_467b6)), mix(texelFetch(s_InputFinalColor, ivec2(int(var_cfb39.x), int(var_461c2.y)), 0), texelFetch(s_InputFinalColor, ivec2(int(var_461c2.x), int(var_461c2.y)), 0), vec4(var_467b6)), vec4(clamp((var_7e373.y - var_cfb39.y) / (var_461c2.y - var_cfb39.y), 0.0, 1.0))));
}
