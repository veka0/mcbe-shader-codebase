#version 310 es

/*
* Available Macros:
*
* Passes:
* - CLUSTER_LIGHTS_PASS (not used)
* - FALLBACK_PASS (not used)
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

layout(binding = 1, std430) buffer s_Extends { LightExtends Extends[]; } var_c436b;
layout(binding = 0, std430) buffer s_zLightLookupArray { LightData zLightLookupArray[]; } var_8ea63;
uniform vec4 CameraFarPlane;
uniform vec4 ClusterDepthBounds;
uniform vec4 ClusterDimensions;
uniform vec4 ClusterNearFarWidthHeight;
uniform vec4 ClusterSize;
uniform vec4 LightsPerCluster;
void func_aecb3(inout float arg_4298c, inout float arg_e0023, inout vec2 arg_a8b7b, inout vec2 arg_ced28, inout float arg_58281) {
    if (arg_4298c < 1.0)
    {
        arg_e0023 = arg_a8b7b.x;
        return;
    }
    if (arg_4298c < 2.0)
    {
        arg_e0023 = arg_ced28.x;
        return;
    }
    if (arg_4298c < 3.0)
    {
        arg_e0023 = arg_ced28.y;
        return;
    }
    arg_e0023 = exp2(((log2(arg_a8b7b.y / arg_ced28.y) * (arg_58281 + (-1.5))) / (ClusterDimensions.z - 2.0)) + log2(arg_ced28.y));
}
void func_8f344() {
    float loc_24753 = float(GlobalInvocationID.x);
    float loc_bc44b = float(GlobalInvocationID.y);
    float loc_1141f = float(GlobalInvocationID.z);
    int loc_6f4b5 = int(ClusterDimensions.w);
    int loc_a217b = int(LightsPerCluster.x);
    bool loc_2313e = loc_24753 >= ClusterDimensions.x;
    bool loc_069b0;
    if (!loc_2313e)
    {
        loc_069b0 = loc_bc44b >= ClusterDimensions.y;
    }
    else
    {
        loc_069b0 = loc_2313e;
    }
    bool loc_84f5f;
    if (!loc_069b0)
    {
        loc_84f5f = loc_1141f >= ClusterDimensions.z;
    }
    else
    {
        loc_84f5f = loc_069b0;
    }
    if (loc_84f5f)
    {
        return;
    }
    int loc_026da = int((loc_24753 + (loc_bc44b * ClusterDimensions.x)) + ((loc_1141f * ClusterDimensions.x) * ClusterDimensions.y));
    float loc_e119b = loc_1141f + 0.5;
    vec2 loc_79283 = ClusterNearFarWidthHeight.xy;
    vec2 loc_7d455 = ClusterDepthBounds.xy;
    float loc_babe4;
    func_aecb3(loc_e119b, loc_babe4, loc_79283, loc_7d455, loc_1141f);
    float loc_8aa53 = loc_babe4 / CameraFarPlane.z;
    vec3 loc_e90de = vec3(((((loc_24753 + 0.5) * ClusterSize.x) - (ClusterNearFarWidthHeight.z * 0.5)) / ClusterNearFarWidthHeight.z) * (CameraFarPlane.x * loc_8aa53), ((((loc_bc44b + 0.5) * ClusterSize.y) - (ClusterNearFarWidthHeight.w * 0.5)) / ClusterNearFarWidthHeight.w) * (CameraFarPlane.y * loc_8aa53), -loc_babe4);
    int loc_25246;
    loc_25246 = 0;
    LightContribution loc_73e0b[64];
    int loc_e8108;
    for (int loc_0c57c = 0; loc_0c57c < loc_6f4b5; loc_25246 = loc_e8108, loc_0c57c++)
    {
        vec4 loc_e9fdb = var_c436b.Extends[loc_0c57c].pos;
        int loc_51439 = var_c436b.Extends[loc_0c57c].index;
        vec4 loc_30d7f = var_c436b.Extends[loc_0c57c]._min;
        vec4 loc_035a0 = var_c436b.Extends[loc_0c57c]._max;
        bool loc_25a54 = loc_1141f < loc_30d7f.z;
        bool loc_a8060;
        if (!loc_25a54)
        {
            loc_a8060 = loc_1141f > loc_035a0.z;
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
        bool loc_9f6d7 = loc_bc44b < loc_30d7f.y;
        bool loc_c8987;
        if (!loc_9f6d7)
        {
            loc_c8987 = loc_bc44b > loc_035a0.y;
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
        bool loc_35843 = loc_24753 < loc_30d7f.x;
        bool loc_85c37;
        if (!loc_35843)
        {
            loc_85c37 = loc_24753 > loc_035a0.x;
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
        float loc_d9ac7 = length(loc_e9fdb.xyz - loc_e90de);
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
            var_8ea63.zLightLookupArray[(loc_026da * loc_a217b) + loc_25246].lookup = float(loc_51439);
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
            var_8ea63.zLightLookupArray[(loc_026da * loc_a217b) + loc_ce739].lookup = float(loc_51439);
            loc_10073 = loc_25246;
        }
        loc_e8108 = loc_10073;
    }
    if (loc_25246 < loc_a217b)
    {
        var_8ea63.zLightLookupArray[(loc_026da * loc_a217b) + loc_25246].lookup = -1.0;
    }
}
void main() {
    uvec3 GlobalInvocationID = gl_GlobalInvocationID;
    func_8f344();
}
