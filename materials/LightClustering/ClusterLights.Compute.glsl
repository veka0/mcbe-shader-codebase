#version 310 es

/*
* Available Macros:
*
* Passes:
* - CLUSTER_LIGHTS_PASS (not used)
* - FALLBACK_PASS (not used)
*
* AngularRefinement:
* - ANGULAR_REFINEMENT__OFF
* - ANGULAR_REFINEMENT__ON
*
* Available Resources:
*
* Buffers:
* - layout(binding = 1, std430) buffer s_ExtendsBuffer { LightExtends s_Extends[]; };
* - layout(binding = 0, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
*
* Uniforms:
* - uniform vec4 CameraFarPlane;
* - uniform vec4 ClusterDepthBounds;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
* - uniform vec4 LightsPerCluster;
* - uniform vec4 PointLightPreCalcValues;
*/

layout(local_size_x = 4, local_size_y = 4, local_size_z = 4) in;
struct LightExtends {
    vec4 _min;
    vec4 _max;
    vec4 pos;
    int index;
    float radius;
    int pad1;
    int pad2;
};

struct LightContribution {
    float contribution;
    int indexInLookUp;
};

struct LightData {
    float lookup;
};

layout(binding = 1, std430) buffer s_Extends { LightExtends Extends[]; } var_0a883;
layout(binding = 0, std430) buffer s_zLightLookupArray { LightData zLightLookupArray[]; } var_dac50;
uniform vec4 ClusterDepthBounds;
uniform vec4 ClusterDimensions;
uniform vec4 LightsPerCluster;
uniform vec4 PointLightPreCalcValues;
#ifdef ANGULAR_REFINEMENT__OFF
void func_b5ad2() {
    float loc_532a9 = float(GlobalInvocationID.x);
    float loc_d0a4e = float(GlobalInvocationID.y);
    float loc_286a7 = float(GlobalInvocationID.z);
    int loc_6f4b5 = int(ClusterDimensions.w);
    int loc_a217b = int(LightsPerCluster.x);
    bool loc_2313e = loc_532a9 >= ClusterDimensions.x;
    bool loc_069b0;
    if (!loc_2313e)
    {
        loc_069b0 = loc_d0a4e >= ClusterDimensions.y;
    }
    else
    {
        loc_069b0 = loc_2313e;
    }
    bool loc_84f5f;
    if (!loc_069b0)
    {
        loc_84f5f = loc_286a7 >= ClusterDimensions.z;
    }
    else
    {
        loc_84f5f = loc_069b0;
    }
    if (loc_84f5f)
    {
        return;
    }
    int loc_026da = int((loc_532a9 + (loc_d0a4e * ClusterDimensions.x)) + ((loc_286a7 * ClusterDimensions.x) * ClusterDimensions.y));
    vec3 loc_a9abc = vec3(loc_532a9 + 0.5, loc_d0a4e + 0.5, loc_286a7 + 0.5);
    vec3 loc_e3bd0 = ClusterDimensions.xyz;
    vec2 loc_dbe64 = ClusterDepthBounds.xy;
    vec4 loc_4ac24 = PointLightPreCalcValues;
    float loc_9136d;
    if (loc_a9abc.z < 1.0)
    {
        loc_9136d = 0.5 * loc_dbe64.x;
    }
    else
    {
        float loc_9fc94;
        if (loc_a9abc.z < 2.0)
        {
            loc_9fc94 = 0.5 * (loc_dbe64.x + loc_dbe64.y);
        }
        else
        {
            loc_9fc94 = exp2(mix(loc_4ac24.z, loc_4ac24.y, (loc_a9abc.z - 2.0) / (loc_e3bd0.z - 2.0)));
        }
        loc_9136d = loc_9fc94;
    }
    float loc_d2710 = loc_9136d * ClusterDepthBounds.z;
    float loc_65a86 = loc_d2710 * ClusterDepthBounds.w;
    vec3 loc_450b0 = vec3(mix(-loc_65a86, loc_65a86, loc_a9abc.x / loc_e3bd0.x), mix(-loc_d2710, loc_d2710, loc_a9abc.y / loc_e3bd0.y), -loc_9136d);
    int loc_25246;
    loc_25246 = 0;
    LightContribution loc_73e0b[64];
    int loc_e8108;
    for (int loc_0c57c = 0; loc_0c57c < loc_6f4b5; loc_25246 = loc_e8108, loc_0c57c++)
    {
        vec4 loc_e9fdb = var_0a883.Extends[loc_0c57c].pos;
        int loc_51439 = var_0a883.Extends[loc_0c57c].index;
        vec4 loc_30d7f = var_0a883.Extends[loc_0c57c]._min;
        vec4 loc_035a0 = var_0a883.Extends[loc_0c57c]._max;
        bool loc_25a54 = loc_286a7 < loc_30d7f.z;
        bool loc_a8060;
        if (!loc_25a54)
        {
            loc_a8060 = loc_286a7 > loc_035a0.z;
        }
        else
        {
            loc_a8060 = loc_25a54;
        }
        if (loc_a8060)
        {
            loc_e8108 = loc_25246;
            continue;
        }
        bool loc_9f6d7 = loc_d0a4e < loc_30d7f.y;
        bool loc_c8987;
        if (!loc_9f6d7)
        {
            loc_c8987 = loc_d0a4e > loc_035a0.y;
        }
        else
        {
            loc_c8987 = loc_9f6d7;
        }
        if (loc_c8987)
        {
            loc_e8108 = loc_25246;
            continue;
        }
        bool loc_35843 = loc_532a9 < loc_30d7f.x;
        bool loc_85c37;
        if (!loc_35843)
        {
            loc_85c37 = loc_532a9 > loc_035a0.x;
        }
        else
        {
            loc_85c37 = loc_35843;
        }
        if (loc_85c37)
        {
            loc_e8108 = loc_25246;
            continue;
        }
        float loc_d9ac7 = length(loc_e9fdb.xyz - loc_450b0);
        bool loc_c1fd8 = loc_25246 >= loc_a217b;
        bool loc_0799d;
        if (loc_c1fd8)
        {
            loc_0799d = loc_d9ac7 >= loc_73e0b[loc_25246 - 1].contribution;
        }
        else
        {
            loc_0799d = loc_c1fd8;
        }
        if (loc_0799d)
        {
            loc_e8108 = loc_25246;
            continue;
        }
        int loc_8aa6b;
        loc_8aa6b = 0;
        int loc_9b799;
        int loc_a0258;
        for (int loc_8b5f4 = loc_25246; loc_8aa6b < loc_8b5f4; loc_8b5f4 = loc_a0258, loc_8aa6b = loc_9b799)
        {
            int loc_bdce6 = (loc_8aa6b + loc_8b5f4) / 2;
            if (loc_73e0b[loc_bdce6].contribution < loc_d9ac7)
            {
                loc_a0258 = loc_8b5f4;
                loc_9b799 = loc_bdce6 + 1;
            }
            else
            {
                loc_a0258 = loc_bdce6;
                loc_9b799 = loc_8aa6b;
            }
        }
        int loc_10073;
        if (loc_25246 < loc_a217b)
        {
            int loc_890eb = loc_25246 - 1;
            for (int loc_df430 = loc_890eb; loc_df430 >= loc_8aa6b; loc_df430--)
            {
                loc_73e0b[loc_df430 + 1] = loc_73e0b[loc_df430];
            }
            loc_73e0b[loc_8aa6b].contribution = loc_d9ac7;
            loc_73e0b[loc_8aa6b].indexInLookUp = loc_25246;
            var_dac50.zLightLookupArray[(loc_026da * loc_a217b) + loc_25246].lookup = float(loc_51439);
            loc_10073 = loc_25246 + 1;
        }
        else
        {
            int loc_a422d = loc_a217b - 1;
            int loc_ce739 = loc_73e0b[loc_a422d].indexInLookUp;
            int loc_eb4bc = loc_a217b - 2;
            for (int loc_2b888 = loc_eb4bc; loc_2b888 >= loc_8aa6b; loc_2b888--)
            {
                loc_73e0b[loc_2b888 + 1] = loc_73e0b[loc_2b888];
            }
            loc_73e0b[loc_8aa6b].contribution = loc_d9ac7;
            loc_73e0b[loc_8aa6b].indexInLookUp = loc_ce739;
            var_dac50.zLightLookupArray[(loc_026da * loc_a217b) + loc_ce739].lookup = float(loc_51439);
            loc_10073 = loc_25246;
        }
        loc_e8108 = loc_10073;
    }
    if (loc_25246 < loc_a217b)
    {
        var_dac50.zLightLookupArray[(loc_026da * loc_a217b) + loc_25246].lookup = -1.0;
    }
}
#endif
#ifdef ANGULAR_REFINEMENT__ON
void func_4c579(inout vec4 arg_706f7, inout int arg_c27ae, inout bool arg_a7aac, inout uvec3 arg_a28c9, inout vec3 arg_dbfed, inout vec3 arg_ced6e) {
    float loc_06cc8 = dot(arg_706f7.xyz, arg_706f7.xyz);
    float loc_792b3 = var_0a883.Extends[arg_c27ae].radius * var_0a883.Extends[arg_c27ae].radius;
    if (loc_06cc8 <= loc_792b3)
    {
        arg_a7aac = true;
        return;
    }
    float loc_a03f4 = atan(ClusterDepthBounds.w * ClusterDepthBounds.z);
    float loc_a809f = atan(ClusterDepthBounds.z);
    vec2 loc_67c92 = vec2(((-loc_a03f4) + ((float(arg_a28c9.x) + 0.5) * ((2.0 * loc_a03f4) / arg_dbfed.x))) - atan(arg_ced6e.x, -arg_ced6e.z), ((-loc_a809f) + ((float(arg_a28c9.y) + 0.5) * ((2.0 * loc_a809f) / arg_dbfed.y))) - atan(arg_ced6e.y, -arg_ced6e.z));
    arg_a7aac = dot(loc_67c92, loc_67c92) < (loc_792b3 / loc_06cc8);
}
void func_c58cd() {
    float loc_45593 = float(GlobalInvocationID.x);
    float loc_432e2 = float(GlobalInvocationID.y);
    float loc_3ebdd = float(GlobalInvocationID.z);
    int loc_6f4b5 = int(ClusterDimensions.w);
    int loc_a217b = int(LightsPerCluster.x);
    bool loc_2313e = loc_45593 >= ClusterDimensions.x;
    bool loc_069b0;
    if (!loc_2313e)
    {
        loc_069b0 = loc_432e2 >= ClusterDimensions.y;
    }
    else
    {
        loc_069b0 = loc_2313e;
    }
    bool loc_84f5f;
    if (!loc_069b0)
    {
        loc_84f5f = loc_3ebdd >= ClusterDimensions.z;
    }
    else
    {
        loc_84f5f = loc_069b0;
    }
    if (loc_84f5f)
    {
        return;
    }
    int loc_026da = int((loc_45593 + (loc_432e2 * ClusterDimensions.x)) + ((loc_3ebdd * ClusterDimensions.x) * ClusterDimensions.y));
    vec3 loc_a9abc = vec3(loc_45593 + 0.5, loc_432e2 + 0.5, loc_3ebdd + 0.5);
    vec3 loc_e3bd0 = ClusterDimensions.xyz;
    vec2 loc_dbe64 = ClusterDepthBounds.xy;
    vec4 loc_4ac24 = PointLightPreCalcValues;
    float loc_9136d;
    if (loc_a9abc.z < 1.0)
    {
        loc_9136d = 0.5 * loc_dbe64.x;
    }
    else
    {
        float loc_9fc94;
        if (loc_a9abc.z < 2.0)
        {
            loc_9fc94 = 0.5 * (loc_dbe64.x + loc_dbe64.y);
        }
        else
        {
            loc_9fc94 = exp2(mix(loc_4ac24.z, loc_4ac24.y, (loc_a9abc.z - 2.0) / (loc_e3bd0.z - 2.0)));
        }
        loc_9136d = loc_9fc94;
    }
    float loc_d2710 = loc_9136d * ClusterDepthBounds.z;
    float loc_65a86 = loc_d2710 * ClusterDepthBounds.w;
    vec3 loc_450b0 = vec3(mix(-loc_65a86, loc_65a86, loc_a9abc.x / loc_e3bd0.x), mix(-loc_d2710, loc_d2710, loc_a9abc.y / loc_e3bd0.y), -loc_9136d);
    int loc_e762b;
    loc_e762b = 0;
    LightContribution loc_73e0b[64];
    int loc_7e4e3;
    for (int loc_060b7 = 0; loc_060b7 < loc_6f4b5; loc_e762b = loc_7e4e3, loc_060b7++)
    {
        vec4 loc_79899 = var_0a883.Extends[loc_060b7].pos;
        int loc_51439 = var_0a883.Extends[loc_060b7].index;
        vec4 loc_30d7f = var_0a883.Extends[loc_060b7]._min;
        vec4 loc_035a0 = var_0a883.Extends[loc_060b7]._max;
        bool loc_25a54 = loc_3ebdd < loc_30d7f.z;
        bool loc_a8060;
        if (!loc_25a54)
        {
            loc_a8060 = loc_3ebdd > loc_035a0.z;
        }
        else
        {
            loc_a8060 = loc_25a54;
        }
        if (loc_a8060)
        {
            loc_7e4e3 = loc_e762b;
            continue;
        }
        bool loc_9f6d7 = loc_432e2 < loc_30d7f.y;
        bool loc_c8987;
        if (!loc_9f6d7)
        {
            loc_c8987 = loc_432e2 > loc_035a0.y;
        }
        else
        {
            loc_c8987 = loc_9f6d7;
        }
        if (loc_c8987)
        {
            loc_7e4e3 = loc_e762b;
            continue;
        }
        bool loc_35843 = loc_45593 < loc_30d7f.x;
        bool loc_85c37;
        if (!loc_35843)
        {
            loc_85c37 = loc_45593 > loc_035a0.x;
        }
        else
        {
            loc_85c37 = loc_35843;
        }
        if (loc_85c37)
        {
            loc_7e4e3 = loc_e762b;
            continue;
        }
        vec3 loc_fb729 = loc_79899.xyz;
        vec3 loc_839b8 = ClusterDimensions.xyz;
        uvec3 loc_f940f = uvec3(ivec3(int(loc_45593), int(loc_432e2), int(loc_3ebdd)));
        bool loc_0b02d;
        func_4c579(loc_79899, loc_060b7, loc_0b02d, loc_f940f, loc_839b8, loc_fb729);
        if (!loc_0b02d)
        {
            loc_7e4e3 = loc_e762b;
            continue;
        }
        float loc_d9ac7 = length(loc_79899.xyz - loc_450b0);
        bool loc_c1fd8 = loc_e762b >= loc_a217b;
        bool loc_0799d;
        if (loc_c1fd8)
        {
            loc_0799d = loc_d9ac7 >= loc_73e0b[loc_e762b - 1].contribution;
        }
        else
        {
            loc_0799d = loc_c1fd8;
        }
        if (loc_0799d)
        {
            loc_7e4e3 = loc_e762b;
            continue;
        }
        int loc_8aa6b;
        loc_8aa6b = 0;
        int loc_9b799;
        int loc_a0258;
        for (int loc_8b5f4 = loc_e762b; loc_8aa6b < loc_8b5f4; loc_8b5f4 = loc_a0258, loc_8aa6b = loc_9b799)
        {
            int loc_bdce6 = (loc_8aa6b + loc_8b5f4) / 2;
            if (loc_73e0b[loc_bdce6].contribution < loc_d9ac7)
            {
                loc_a0258 = loc_8b5f4;
                loc_9b799 = loc_bdce6 + 1;
            }
            else
            {
                loc_a0258 = loc_bdce6;
                loc_9b799 = loc_8aa6b;
            }
        }
        int loc_10073;
        if (loc_e762b < loc_a217b)
        {
            int loc_890eb = loc_e762b - 1;
            for (int loc_df430 = loc_890eb; loc_df430 >= loc_8aa6b; loc_df430--)
            {
                loc_73e0b[loc_df430 + 1] = loc_73e0b[loc_df430];
            }
            loc_73e0b[loc_8aa6b].contribution = loc_d9ac7;
            loc_73e0b[loc_8aa6b].indexInLookUp = loc_e762b;
            var_dac50.zLightLookupArray[(loc_026da * loc_a217b) + loc_e762b].lookup = float(loc_51439);
            loc_10073 = loc_e762b + 1;
        }
        else
        {
            int loc_a422d = loc_a217b - 1;
            int loc_ce739 = loc_73e0b[loc_a422d].indexInLookUp;
            int loc_eb4bc = loc_a217b - 2;
            for (int loc_2b888 = loc_eb4bc; loc_2b888 >= loc_8aa6b; loc_2b888--)
            {
                loc_73e0b[loc_2b888 + 1] = loc_73e0b[loc_2b888];
            }
            loc_73e0b[loc_8aa6b].contribution = loc_d9ac7;
            loc_73e0b[loc_8aa6b].indexInLookUp = loc_ce739;
            var_dac50.zLightLookupArray[(loc_026da * loc_a217b) + loc_ce739].lookup = float(loc_51439);
            loc_10073 = loc_e762b;
        }
        loc_7e4e3 = loc_10073;
    }
    if (loc_e762b < loc_a217b)
    {
        var_dac50.zLightLookupArray[(loc_026da * loc_a217b) + loc_e762b].lookup = -1.0;
    }
}
#endif
void main() {
    uvec3 GlobalInvocationID = gl_GlobalInvocationID;
#ifdef ANGULAR_REFINEMENT__OFF
    func_b5ad2();
#endif
#ifdef ANGULAR_REFINEMENT__ON
    func_c58cd();
#endif
}
