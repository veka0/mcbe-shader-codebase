#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - GPU_VALIDATION_PASS (not used)
* - TDR_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - layout(binding = 0, std430) buffer s_FakeRWBufferBuffer { int s_FakeRWBuffer[]; };
*/

layout(local_size_x = 256, local_size_y = 1, local_size_z = 1) in;
layout(binding = 0, std430) buffer s_FakeRWBufferBuffer { int s_FakeRWBuffer[]; } var_84590;
void main() {
    var_84590.s_FakeRWBuffer[gl_GlobalInvocationID.x] = 0;
}
