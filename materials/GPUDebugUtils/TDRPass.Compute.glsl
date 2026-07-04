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
layout(binding = 0, std430) buffer s_FakeRWBufferBuffer { int s_FakeRWBuffer[]; } var_6b465;
void main() {
    uvec3 GlobalInvocationID = gl_GlobalInvocationID;
    while (var_6b465.s_FakeRWBuffer[GlobalInvocationID.x] == 0)
    {
        var_6b465.s_FakeRWBuffer[GlobalInvocationID.x] = 0;
    }
}
