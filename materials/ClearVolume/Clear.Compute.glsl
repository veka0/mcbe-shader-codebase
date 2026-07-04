#version 310 es

/*
* Available Macros:
*
* Passes:
* - CLEAR_PASS (not used)
* - FALLBACK_PASS (not used)
*
* ThreadLimit:
* - THREAD_LIMIT__LIMITED_AT128
* - THREAD_LIMIT__LIMITED_AT256
* - THREAD_LIMIT__NATIVE
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2DArray s_Volume;
*
* Uniforms:
* - uniform vec4 ClearValue;
* - uniform vec4 VolumeDimensions;
*/

#ifdef THREAD_LIMIT__LIMITED_AT128
layout(local_size_x = 8, local_size_y = 8, local_size_z = 2) in;
#endif
#ifdef THREAD_LIMIT__LIMITED_AT256
layout(local_size_x = 8, local_size_y = 8, local_size_z = 4) in;
#endif
#ifdef THREAD_LIMIT__NATIVE
layout(local_size_x = 8, local_size_y = 8, local_size_z = 8) in;
#endif
layout(location = 0, binding = 0, rgba16f) uniform writeonly highp image2DArray s_Volume;
uniform vec4 ClearValue;
uniform vec4 VolumeDimensions;
void func_84d4a() {
    int loc_6590b = int(GlobalInvocationID.x);
    int loc_b2d73 = int(GlobalInvocationID.y);
    int loc_0b58a = int(GlobalInvocationID.z);
    if (((loc_6590b >= int(VolumeDimensions.x)) || (loc_b2d73 >= int(VolumeDimensions.y))) || (loc_0b58a >= int(VolumeDimensions.z)))
    {
        return;
    }
    imageStore(s_Volume, ivec3(loc_6590b, loc_b2d73, loc_0b58a), ClearValue);
}
void main() {
    uvec3 GlobalInvocationID = gl_GlobalInvocationID;
    func_84d4a();
}
