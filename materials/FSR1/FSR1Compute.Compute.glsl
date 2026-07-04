#version 310 es

/*
* Available Macros:
*
* Passes:
* - FSR1_COMPUTE_PASS (not used)
* - FSR1_FRAG_PASS (not used)
* - FALLBACK_PASS (not used)
*
* FFXPrecision:
* - FFX_PRECISION__FULL (not used)
* - FFX_PRECISION__HALF (not used)
*
* FSRFilterMode:
* - FSR_FILTER_MODE__BILINEAR (not used)
* - FSR_FILTER_MODE__EASU (not used)
* - FSR_FILTER_MODE__RCAS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_InputTex;
* - uniform lowp sampler2D s_OutputTex;
*
* Uniforms:
* - uniform vec4 FSRConst0;
* - uniform vec4 FSRConst1;
* - uniform vec4 FSRConst2;
* - uniform vec4 FSRConst3;
* - uniform vec4 InputAndOutputResolution;
*/

layout(local_size_x = 64, local_size_y = 1, local_size_z = 1) in;
layout(location = 0, binding = 1, rgba8) uniform writeonly highp image2D s_OutputTex;
void main() {
    uvec3 LocalInvocationID = gl_LocalInvocationID;
    uvec3 WorkGroupID = gl_WorkGroupID;
    imageStore(s_OutputTex, ivec2(uvec2(LocalInvocationID.x) + uvec2(WorkGroupID.x << 4u, WorkGroupID.y << 4u)), vec4(0.9570000171661376953125, 0.2750000059604644775390625, 0.0670000016689300537109375, 1.0));
}
