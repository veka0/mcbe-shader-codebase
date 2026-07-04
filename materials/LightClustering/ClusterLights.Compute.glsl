#version 310 es

/*
* Available Macros:
*
* Passes:
* - CLUSTER_LIGHTS_PASS (not used)
* - CLUSTER_LIGHTS_MANHATTAN_PASS (not used)
* - FALLBACK_PASS (not used)
*
* ChangeMaxLightPerCluster:
* - CHANGE_MAX_LIGHT_PER_CLUSTER__HIGHER (not used)
* - CHANGE_MAX_LIGHT_PER_CLUSTER__LOWER (not used)
* - CHANGE_MAX_LIGHT_PER_CLUSTER__OFF (not used)
*
* Available Resources:
*
* Buffers:
* - layout(binding = 1, std430) buffer s_ExtendsBuffer { LightExtends s_Extends[]; };
* - layout(binding = 0, std430) buffer s_LightLookupArrayBuffer { LightData s_LightLookupArray[]; };
*
* Uniforms:
* - uniform vec4 CameraClusterWeight;
* - uniform vec4 CameraFarPlane;
* - uniform vec4 ClusterDimensions;
* - uniform vec4 ClusterNearFarWidthHeight;
* - uniform vec4 ClusterSize;
* - uniform mat4 InvViewMat;
* - uniform vec4 LightsPerCluster;
* - uniform mat4 ProjMat;
* - uniform mat4 ViewMat;
* - uniform vec4 WorldOrigin;
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

layout(binding = 1, std430) buffer s_Extends { LightExtends Extends[]; } var_63228;
layout(binding = 0, std430) buffer s_LightLookupArray { LightData LightLookupArray[]; } var_26955;
uniform vec4 CameraFarPlane;
uniform vec4 ClusterDimensions;
uniform vec4 ClusterNearFarWidthHeight;
uniform vec4 ClusterSize;
uniform vec4 LightsPerCluster;
void func_b9786(inout float arg_82de1, inout float arg_400d4, inout vec2 arg_11328, inout float arg_e3063) {
    if (arg_82de1 == 0.0)
    {
        arg_400d4 = arg_11328.x;
        return;
    }
    if (arg_82de1 == 1.0)
    {
        arg_400d4 = 1.0;
        return;
    }
    arg_400d4 = pow(2.0, (log2(arg_11328.y * 0.666666686534881591796875) * (arg_e3063 + (-1.5))) / (ClusterDimensions.z - 2.0));
}
void func_a7e78() {
    float loc_24753 = float(GlobalInvocationID.x);
    float loc_bc44b = float(GlobalInvocationID.y);
    float loc_a3df9 = float(GlobalInvocationID.z);
    int loc_6f4b5 = int(ClusterDimensions.w);
    int loc_aa6c6 = int(LightsPerCluster.x);
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
        loc_84f5f = loc_a3df9 >= ClusterDimensions.z;
    }
    else
    {
        loc_84f5f = loc_069b0;
    }
    if (loc_84f5f)
    {
        return;
    }
    int loc_faa56 = int((loc_24753 + (loc_bc44b * ClusterDimensions.x)) + ((loc_a3df9 * ClusterDimensions.x) * ClusterDimensions.y));
    float loc_a0b8b = loc_a3df9 + 0.5;
    vec2 loc_77a9e = ClusterNearFarWidthHeight.xy;
    float loc_ade86;
    func_b9786(loc_a0b8b, loc_ade86, loc_77a9e, loc_a3df9);
    float loc_8aa53 = loc_ade86 / CameraFarPlane.z;
    vec3 loc_e90de = vec3(((((loc_24753 + 0.5) * ClusterSize.x) - (ClusterNearFarWidthHeight.z * 0.5)) / ClusterNearFarWidthHeight.z) * (CameraFarPlane.x * loc_8aa53), ((((loc_bc44b + 0.5) * ClusterSize.y) - (ClusterNearFarWidthHeight.w * 0.5)) / ClusterNearFarWidthHeight.w) * (CameraFarPlane.y * loc_8aa53), -loc_ade86);
    int loc_c6dc4;
    loc_c6dc4 = 0;
    LightContribution loc_8d965[32];
    int loc_e8108;
    for (int loc_0c57c = 0; loc_0c57c < loc_6f4b5; loc_c6dc4 = loc_e8108, loc_0c57c++)
    {
        vec4 loc_e9fdb = var_63228.Extends[loc_0c57c].pos;
        int loc_e25b3 = var_63228.Extends[loc_0c57c].index;
        vec4 loc_30d7f = var_63228.Extends[loc_0c57c]._min;
        vec4 loc_035a0 = var_63228.Extends[loc_0c57c]._max;
        bool loc_25a54 = loc_a3df9 < loc_30d7f.z;
        bool loc_a8060;
        if (!loc_25a54)
        {
            loc_a8060 = loc_a3df9 > loc_035a0.z;
        }
        else
        {
            loc_a8060 = loc_25a54;
        }
        if (loc_a8060)
        {
            loc_e8108 = loc_c6dc4;
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
            loc_e8108 = loc_c6dc4;
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
            loc_e8108 = loc_c6dc4;
            continue;
        }
        float loc_d9ac7 = length(loc_e9fdb.xyz - loc_e90de);
        bool loc_c1fd8 = loc_c6dc4 >= loc_aa6c6;
        bool loc_0799d;
        if (loc_c1fd8)
        {
            loc_0799d = loc_d9ac7 >= loc_8d965[loc_c6dc4 - 1].contribution;
        }
        else
        {
            loc_0799d = loc_c1fd8;
        }
        if (loc_0799d)
        {
            loc_e8108 = loc_c6dc4;
            continue;
        }
        int loc_8aa6b;
        loc_8aa6b = 0;
        int loc_9b799;
        int loc_a0258;
        for (int loc_8b5f4 = loc_c6dc4; loc_8aa6b < loc_8b5f4; loc_8b5f4 = loc_a0258, loc_8aa6b = loc_9b799)
        {
            int loc_bdce6 = (loc_8aa6b + loc_8b5f4) / 2;
            if (loc_8d965[loc_bdce6].contribution < loc_d9ac7)
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
        if (loc_c6dc4 < loc_aa6c6)
        {
            int loc_890eb = loc_c6dc4 - 1;
            for (int loc_df430 = loc_890eb; loc_df430 >= loc_8aa6b; loc_df430--)
            {
                loc_8d965[loc_df430 + 1] = loc_8d965[loc_df430];
            }
            loc_8d965[loc_8aa6b].contribution = loc_d9ac7;
            loc_8d965[loc_8aa6b].indexInLookUp = loc_c6dc4;
            var_26955.LightLookupArray[(loc_faa56 * loc_aa6c6) + loc_c6dc4].lookup = float(loc_e25b3);
            loc_10073 = loc_c6dc4 + 1;
        }
        else
        {
            int loc_a422d = loc_aa6c6 - 1;
            int loc_afad4 = loc_8d965[loc_a422d].indexInLookUp;
            int loc_eb4bc = loc_aa6c6 - 2;
            for (int loc_2b888 = loc_eb4bc; loc_2b888 >= loc_8aa6b; loc_2b888--)
            {
                loc_8d965[loc_2b888 + 1] = loc_8d965[loc_2b888];
            }
            loc_8d965[loc_8aa6b].contribution = loc_d9ac7;
            loc_8d965[loc_8aa6b].indexInLookUp = loc_afad4;
            var_26955.LightLookupArray[(loc_faa56 * loc_aa6c6) + loc_afad4].lookup = float(loc_e25b3);
            loc_10073 = loc_c6dc4;
        }
        loc_e8108 = loc_10073;
    }
    if (loc_c6dc4 < loc_aa6c6)
    {
        var_26955.LightLookupArray[(loc_faa56 * loc_aa6c6) + loc_c6dc4].lookup = -1.0;
    }
}
void main() {
    uvec3 GlobalInvocationID = gl_GlobalInvocationID;
    func_a7e78();
}
