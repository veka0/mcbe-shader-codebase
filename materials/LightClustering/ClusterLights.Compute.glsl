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
* - layout(binding = 0, std430) buffer s_ExtendsBuffer { LightExtends s_Extends[]; };
* - layout(binding = 1, std430) buffer s_zLightLookupArrayBuffer { LightData s_zLightLookupArray[]; };
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
    int pad0;
    int pad1;
};

struct LightContribution {
    float contribution;
    int indexInLookUp;
};

struct LightData {
    float lookup;
};

layout(binding = 0, std430) buffer s_Extends { LightExtends Extends[]; } var_0c600;
layout(binding = 1, std430) buffer s_zLightLookupArray { LightData zLightLookupArray[]; } var_0bc25;
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
        vec4 loc_e9fdb = var_0c600.Extends[loc_0c57c].pos;
        int loc_51439 = var_0c600.Extends[loc_0c57c].index;
        vec4 loc_30d7f = var_0c600.Extends[loc_0c57c]._min;
        vec4 loc_035a0 = var_0c600.Extends[loc_0c57c]._max;
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
            var_0bc25.zLightLookupArray[(loc_026da * loc_a217b) + loc_25246].lookup = float(loc_51439);
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
            var_0bc25.zLightLookupArray[(loc_026da * loc_a217b) + loc_ce739].lookup = float(loc_51439);
            loc_10073 = loc_25246;
        }
        loc_e8108 = loc_10073;
    }
    if (loc_25246 < loc_a217b)
    {
        var_0bc25.zLightLookupArray[(loc_026da * loc_a217b) + loc_25246].lookup = -1.0;
    }
}
#endif
#ifdef ANGULAR_REFINEMENT__ON
void func_7ed5d(inout uvec3 arg_de290, inout vec2 arg_fd918, inout vec3 arg_d6a5b) {
    if (arg_de290.z == 0u)
    {
        arg_fd918 = vec2(0.0, ClusterDepthBounds.x);
        return;
    }
    if (arg_de290.z == 1u)
    {
        arg_fd918 = ClusterDepthBounds.xy;
        return;
    }
    arg_fd918 = vec2(exp2(mix(PointLightPreCalcValues.z, PointLightPreCalcValues.y, float(arg_de290.z - 2u) / (arg_d6a5b.z - 2.0))), exp2(mix(PointLightPreCalcValues.z, PointLightPreCalcValues.y, float(arg_de290.z - 1u) / (arg_d6a5b.z - 2.0))));
}
void func_00520(inout int arg_21bb6, inout vec4 arg_d7cb8, inout bool arg_35b97, inout vec3 arg_f87e7, inout vec3 arg_d89af, inout uvec3 arg_0f8de) {
    float loc_2939b = var_0c600.Extends[arg_21bb6].radius * var_0c600.Extends[arg_21bb6].radius;
    if (dot(arg_d7cb8.xyz, arg_d7cb8.xyz) <= loc_2939b)
    {
        arg_35b97 = true;
        return;
    }
    float loc_5e0d8 = -arg_f87e7.z;
    uvec3 loc_bc13f = gl_GlobalInvocationID;
    vec2 loc_5faa6;
    func_7ed5d(loc_bc13f, loc_5faa6, arg_d89af);
    vec2 loc_84456 = loc_5faa6;
    bool loc_d878d = (loc_5e0d8 + var_0c600.Extends[arg_21bb6].radius) < loc_84456.x;
    bool loc_edb78;
    if (!loc_d878d)
    {
        loc_edb78 = (loc_5e0d8 - var_0c600.Extends[arg_21bb6].radius) > loc_84456.y;
    }
    else
    {
        loc_edb78 = loc_d878d;
    }
    if (loc_edb78)
    {
        arg_35b97 = false;
        return;
    }
    float loc_ae481 = clamp(loc_5e0d8, loc_84456.x, loc_84456.y);
    float loc_698b9 = loc_ae481 - loc_5e0d8;
    float loc_94698 = sqrt(max(loc_2939b - (loc_698b9 * loc_698b9), 0.0));
    float loc_7aa1a = max(loc_ae481, 9.9999997473787516355514526367188e-05);
    float loc_5c420 = ClusterDepthBounds.w * ClusterDepthBounds.z;
    float loc_83989 = (2.0 * loc_5c420) / arg_d89af.x;
    float loc_dbd04 = (2.0 * ClusterDepthBounds.z) / arg_d89af.y;
    float loc_33b01 = (-loc_5c420) + (float(arg_0f8de.x) * loc_83989);
    float loc_6f6c7 = (-ClusterDepthBounds.z) + (float(arg_0f8de.y) * loc_dbd04);
    float loc_6d48f = 1.0 / loc_7aa1a;
    float loc_37812 = atan(loc_94698 / sqrt(max((((arg_f87e7.x * arg_f87e7.x) + (arg_f87e7.y * arg_f87e7.y)) + (loc_7aa1a * loc_7aa1a)) - (loc_94698 * loc_94698), 9.9999999392252902907785028219223e-09)));
    float loc_86064 = clamp(arg_f87e7.x * loc_6d48f, loc_33b01, loc_33b01 + loc_83989);
    float loc_e025b = clamp(arg_f87e7.y * loc_6d48f, loc_6f6c7, loc_6f6c7 + loc_dbd04);
    float loc_fb7af = -loc_7aa1a;
    float loc_7666e = abs(atan(arg_f87e7.x + (loc_fb7af * loc_86064), loc_7aa1a + (arg_f87e7.x * loc_86064)));
    float loc_0fe96 = abs(atan(arg_f87e7.y + (loc_fb7af * loc_e025b), loc_7aa1a + (arg_f87e7.y * loc_e025b)));
    arg_35b97 = ((loc_7666e * loc_7666e) + (loc_0fe96 * loc_0fe96)) <= (loc_37812 * loc_37812);
}
void func_06e9d() {
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
    int loc_e762b;
    loc_e762b = 0;
    LightContribution loc_73e0b[64];
    int loc_7e4e3;
    for (int loc_54c44 = 0; loc_54c44 < loc_6f4b5; loc_e762b = loc_7e4e3, loc_54c44++)
    {
        vec4 loc_540b2 = var_0c600.Extends[loc_54c44].pos;
        int loc_51439 = var_0c600.Extends[loc_54c44].index;
        vec4 loc_30d7f = var_0c600.Extends[loc_54c44]._min;
        vec4 loc_035a0 = var_0c600.Extends[loc_54c44]._max;
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
            loc_7e4e3 = loc_e762b;
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
            loc_7e4e3 = loc_e762b;
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
            loc_7e4e3 = loc_e762b;
            continue;
        }
        vec3 loc_ab2a6 = loc_540b2.xyz;
        vec3 loc_839b8 = ClusterDimensions.xyz;
        uvec3 loc_d419c = gl_GlobalInvocationID;
        bool loc_0b02d;
        func_00520(loc_54c44, loc_540b2, loc_0b02d, loc_ab2a6, loc_839b8, loc_d419c);
        if (!loc_0b02d)
        {
            loc_7e4e3 = loc_e762b;
            continue;
        }
        float loc_d9ac7 = length(loc_540b2.xyz - loc_450b0);
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
            var_0bc25.zLightLookupArray[(loc_026da * loc_a217b) + loc_e762b].lookup = float(loc_51439);
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
            var_0bc25.zLightLookupArray[(loc_026da * loc_a217b) + loc_ce739].lookup = float(loc_51439);
            loc_10073 = loc_e762b;
        }
        loc_7e4e3 = loc_10073;
    }
    if (loc_e762b < loc_a217b)
    {
        var_0bc25.zLightLookupArray[(loc_026da * loc_a217b) + loc_e762b].lookup = -1.0;
    }
}
#endif
void main() {
    uvec3 GlobalInvocationID = gl_GlobalInvocationID;
#ifdef ANGULAR_REFINEMENT__OFF
    func_b5ad2();
#endif
#ifdef ANGULAR_REFINEMENT__ON
    func_06e9d();
#endif
}
