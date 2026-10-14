#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - SCATTERING_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2DArray s_ScatteringBufferIn;
* - uniform lowp sampler2DArray s_ScatteringBufferOut;
*
* Uniforms:
* - uniform vec4 VolumeDimensions;
* - uniform vec4 VolumeNearFar;
*/

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;
layout(location = 0, binding = 0, rgba16f) uniform readonly highp image2DArray s_ScatteringBufferIn;
layout(location = 1, binding = 1, rgba16f) uniform writeonly highp image2DArray s_ScatteringBufferOut;
uniform vec4 VolumeDimensions;
uniform vec4 VolumeNearFar;
void func_4ff05() {
    int loc_99764 = int(VolumeDimensions.z);
    int loc_a3096 = int(gl_GlobalInvocationID.x);
    int loc_8ae82 = int(gl_GlobalInvocationID.y);
    if ((loc_a3096 >= int(VolumeDimensions.x)) || (loc_8ae82 >= int(VolumeDimensions.y)))
    {
        return;
    }
    float loc_d9e90 = (exp((-2.0) / VolumeDimensions.z) - 1.0) * 0.0186573602259159088134765625;
    float loc_2e624 = ((1.0 - loc_d9e90) * VolumeNearFar.x) + (loc_d9e90 * VolumeNearFar.y);
    vec4 loc_fc143 = vec4(0.0, 0.0, 0.0, 1.0);
    float loc_f1b7c;
    int loc_9b001 = 0;
    float loc_7c03e = loc_2e624;
    for (; loc_9b001 < loc_99764; loc_7c03e = loc_f1b7c, loc_9b001++)
    {
        float loc_cb8b6 = (exp(4.0 * ((float(loc_9b001) + 0.5) / VolumeDimensions.z)) - 1.0) * 0.0186573602259159088134765625;
        loc_f1b7c = ((1.0 - loc_cb8b6) * VolumeNearFar.x) + (loc_cb8b6 * VolumeNearFar.y);
        float loc_6712c = loc_f1b7c - loc_7c03e;
        vec4 loc_80f67 = imageLoad(s_ScatteringBufferIn, ivec3(loc_a3096, loc_8ae82, loc_9b001));
        vec4 loc_0b898 = loc_80f67;
        float loc_d181d = exp((-loc_0b898.w) * loc_6712c);
        float loc_e4bed;
        if (abs(loc_0b898.w) > 9.9999999747524270787835121154785e-07)
        {
            loc_e4bed = (1.0 - loc_d181d) / loc_0b898.w;
        }
        else
        {
            loc_e4bed = loc_6712c;
        }
        float loc_b1412 = loc_fc143.w;
        vec4 loc_b6bc8 = loc_fc143;
        vec3 loc_9f49e = loc_b6bc8.xyz + (loc_80f67.xyz * (loc_b1412 * loc_e4bed));
        loc_fc143.x = loc_9f49e.x;
        loc_fc143.y = loc_9f49e.y;
        loc_fc143.z = loc_9f49e.z;
        loc_fc143.w *= loc_d181d;
        imageStore(s_ScatteringBufferOut, ivec3(loc_a3096, loc_8ae82, loc_9b001), loc_fc143);
    }
}
void main() {
    func_4ff05();
}
