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
void func_905a5() {
    int loc_99764 = int(VolumeDimensions.z);
    int loc_d1475 = int(GlobalInvocationID.x);
    int loc_d481e = int(GlobalInvocationID.y);
    if ((loc_d1475 >= int(VolumeDimensions.x)) || (loc_d481e >= int(VolumeDimensions.y)))
    {
        return;
    }
    float loc_d9e90 = (exp((-2.0) / VolumeDimensions.z) - 1.0) * 0.0186573602259159088134765625;
    float loc_2e624 = ((1.0 - loc_d9e90) * VolumeNearFar.x) + (loc_d9e90 * VolumeNearFar.y);
    vec4 loc_2e4ca = vec4(0.0, 0.0, 0.0, 1.0);
    float loc_f1b7c;
    int loc_9b001 = 0;
    float loc_7c03e = loc_2e624;
    for (; loc_9b001 < loc_99764; loc_7c03e = loc_f1b7c, loc_9b001++)
    {
        float loc_cb8b6 = (exp(4.0 * ((float(loc_9b001) + 0.5) / VolumeDimensions.z)) - 1.0) * 0.0186573602259159088134765625;
        loc_f1b7c = ((1.0 - loc_cb8b6) * VolumeNearFar.x) + (loc_cb8b6 * VolumeNearFar.y);
        float loc_6712c = loc_f1b7c - loc_7c03e;
        vec4 loc_9ad75 = imageLoad(s_ScatteringBufferIn, ivec3(loc_d1475, loc_d481e, loc_9b001));
        vec4 loc_0b898 = loc_9ad75;
        float loc_d181d = exp((-loc_0b898.w) * loc_6712c);
        float loc_7f699;
        if (abs(loc_0b898.w) > 9.9999999747524270787835121154785e-07)
        {
            loc_7f699 = (1.0 - loc_d181d) / loc_0b898.w;
        }
        else
        {
            loc_7f699 = loc_6712c;
        }
        vec3 loc_aeba6 = loc_2e4ca.xyz + (loc_9ad75.xyz * (loc_2e4ca.w * loc_7f699));
        loc_2e4ca = vec4(loc_aeba6.x, loc_aeba6.y, loc_aeba6.z, loc_2e4ca.w);
        loc_2e4ca.w *= loc_d181d;
        imageStore(s_ScatteringBufferOut, ivec3(loc_d1475, loc_d481e, loc_9b001), loc_2e4ca);
    }
}
void main() {
    uvec3 GlobalInvocationID = gl_GlobalInvocationID;
    func_905a5();
}
