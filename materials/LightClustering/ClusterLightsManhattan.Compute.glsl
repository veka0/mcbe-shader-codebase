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
* - CHANGE_MAX_LIGHT_PER_CLUSTER__HIGHER
* - CHANGE_MAX_LIGHT_PER_CLUSTER__LOWER
* - CHANGE_MAX_LIGHT_PER_CLUSTER__OFF
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

layout(binding = 1, std430) buffer s_Extends { LightExtends Extends[]; } var_6d060;
layout(binding = 0, std430) buffer s_LightLookupArray { LightData LightLookupArray[]; } var_2f33b;
uniform mat4 ProjMat;
uniform mat4 ViewMat;
uniform vec4 CameraClusterWeight;
uniform vec4 ClusterDimensions;
uniform vec4 ClusterNearFarWidthHeight;
uniform vec4 ClusterSize;
uniform vec4 LightsPerCluster;
#ifdef CHANGE_MAX_LIGHT_PER_CLUSTER__HIGHER
shared LightContribution contributionArray[64][64];
#endif
#ifdef CHANGE_MAX_LIGHT_PER_CLUSTER__LOWER
shared LightContribution contributionArray[64][16];
#endif
#ifdef CHANGE_MAX_LIGHT_PER_CLUSTER__OFF
shared LightContribution contributionArray[64][32];
#endif
void func_920ae(inout float arg_906aa, inout float arg_24f67, inout vec2 arg_bd839) {
    if (arg_906aa == 0.0)
    {
        arg_24f67 = arg_bd839.x;
        return;
    }
    if (arg_906aa == 1.0)
    {
        arg_24f67 = 1.0;
        return;
    }
    arg_24f67 = exp2((log2(arg_bd839.y * 0.666666686534881591796875) * (arg_906aa - 2.0)) / (ClusterDimensions.z - 2.0));
}
void func_07fed(inout float arg_82de1, inout float arg_bdb7a, inout vec2 arg_0d0ae, inout float arg_515bf) {
    if (arg_82de1 == 0.0)
    {
        arg_bdb7a = arg_0d0ae.x;
        return;
    }
    if (arg_82de1 == 1.0)
    {
        arg_bdb7a = 1.0;
        return;
    }
    arg_bdb7a = exp2((log2(arg_0d0ae.y * 0.666666686534881591796875) * (arg_515bf + (-1.0))) / (ClusterDimensions.z - 2.0));
}
void func_be74c(inout float arg_82de1, inout float arg_0e454, inout vec2 arg_56080, inout float arg_c5c17) {
    if (arg_82de1 == 0.0)
    {
        arg_0e454 = arg_56080.x;
        return;
    }
    if (arg_82de1 == 1.0)
    {
        arg_0e454 = 1.0;
        return;
    }
    arg_0e454 = exp2((log2(arg_56080.y * 0.666666686534881591796875) * (arg_c5c17 + (-1.5))) / (ClusterDimensions.z - 2.0));
}
void func_f8902() {
    float loc_b9559 = float(GlobalInvocationID.x);
    float loc_95f7a = float(GlobalInvocationID.y);
    float loc_084cb = float(GlobalInvocationID.z);
    int loc_6f4b5 = int(ClusterDimensions.w);
    int loc_aa6c6 = int(LightsPerCluster.x);
    bool loc_2313e = loc_b9559 >= ClusterDimensions.x;
    bool loc_069b0;
    if (!loc_2313e)
    {
        loc_069b0 = loc_95f7a >= ClusterDimensions.y;
    }
    else
    {
        loc_069b0 = loc_2313e;
    }
    bool loc_84f5f;
    if (!loc_069b0)
    {
        loc_84f5f = loc_084cb >= ClusterDimensions.z;
    }
    else
    {
        loc_84f5f = loc_069b0;
    }
    if (loc_84f5f)
    {
        return;
    }
    int loc_faa56 = int((loc_b9559 + (loc_95f7a * ClusterDimensions.x)) + ((loc_084cb * ClusterDimensions.x) * ClusterDimensions.y));
    vec2 loc_74198[7];
    loc_74198[0] = vec2(1.0, 0.0);
    loc_74198[1] = vec2(0.0, 1.0);
    loc_74198[2] = vec2(1.0);
    loc_74198[3] = vec2(1.0);
    loc_74198[4] = vec2(0.0, 1.0);
    loc_74198[5] = vec2(1.0, 0.0);
    loc_74198[6] = vec2(0.0);
    float loc_0c327 = loc_b9559 + 1.0;
    float loc_71561 = loc_95f7a + 1.0;
    bool loc_31a98 = loc_0c327 < (ClusterDimensions.x * 0.5);
    bool loc_d5568;
    if (loc_31a98)
    {
        loc_d5568 = loc_71561 < (ClusterDimensions.y * 0.5);
    }
    else
    {
        loc_d5568 = loc_31a98;
    }
    int loc_fcddd;
    if (loc_d5568)
    {
        loc_fcddd = 2;
    }
    else
    {
        bool loc_985f4 = loc_b9559 > (ClusterDimensions.x * 0.5);
        bool loc_ce202;
        if (loc_985f4)
        {
            loc_ce202 = loc_71561 < (ClusterDimensions.y * 0.5);
        }
        else
        {
            loc_ce202 = loc_985f4;
        }
        int loc_a4c15;
        if (loc_ce202)
        {
            loc_a4c15 = 1;
        }
        else
        {
            bool loc_239c4 = loc_0c327 < (ClusterDimensions.x * 0.5);
            bool loc_d2588;
            if (loc_239c4)
            {
                loc_d2588 = loc_95f7a > (ClusterDimensions.y * 0.5);
            }
            else
            {
                loc_d2588 = loc_239c4;
            }
            int loc_8b75c;
            if (loc_d2588)
            {
                loc_8b75c = 0;
            }
            else
            {
                bool loc_c2a67 = loc_b9559 > (ClusterDimensions.x * 0.5);
                bool loc_1de6d;
                if (loc_c2a67)
                {
                    loc_1de6d = loc_95f7a > (ClusterDimensions.y * 0.5);
                }
                else
                {
                    loc_1de6d = loc_c2a67;
                }
                int loc_2c7c3;
                if (loc_1de6d)
                {
                    loc_2c7c3 = -1;
                }
                else
                {
                    loc_2c7c3 = 3;
                }
                loc_8b75c = loc_2c7c3;
            }
            loc_a4c15 = loc_8b75c;
        }
        loc_fcddd = loc_a4c15;
    }
    int loc_ecc6d = 4 + loc_fcddd;
    int loc_95601;
    loc_95601 = 0;
    int loc_e8108;
    for (int loc_0c57c = 0; loc_0c57c < loc_6f4b5; loc_95601 = loc_e8108, loc_0c57c++)
    {
        vec4 loc_88c6d = var_6d060.Extends[loc_0c57c].pos;
        int loc_e25b3 = var_6d060.Extends[loc_0c57c].index;
        vec4 loc_30d7f = var_6d060.Extends[loc_0c57c]._min;
        vec4 loc_035a0 = var_6d060.Extends[loc_0c57c]._max;
        bool loc_25a54 = loc_084cb < loc_30d7f.z;
        bool loc_a8060;
        if (!loc_25a54)
        {
            loc_a8060 = loc_084cb > loc_035a0.z;
        }
        else
        {
            loc_a8060 = loc_25a54;
        }
        if (loc_a8060)
        {
            loc_e8108 = loc_95601;
            continue;
        }
        bool loc_9f6d7 = loc_95f7a < loc_30d7f.y;
        bool loc_c8987;
        if (!loc_9f6d7)
        {
            loc_c8987 = loc_95f7a > loc_035a0.y;
        }
        else
        {
            loc_c8987 = loc_9f6d7;
        }
        if (loc_c8987)
        {
            loc_e8108 = loc_95601;
            continue;
        }
        bool loc_35843 = loc_b9559 < loc_30d7f.x;
        bool loc_85c37;
        if (!loc_35843)
        {
            loc_85c37 = loc_b9559 > loc_035a0.x;
        }
        else
        {
            loc_85c37 = loc_35843;
        }
        if (loc_85c37)
        {
            loc_e8108 = loc_95601;
            continue;
        }
        vec2 loc_2e98e = ClusterNearFarWidthHeight.xy;
        float loc_d20b9;
        func_920ae(loc_084cb, loc_d20b9, loc_2e98e);
        vec3 loc_e9bcc;
        if (loc_fcddd == (-1))
        {
            loc_e9bcc = vec3((loc_d20b9 * ((min(loc_b9559 * ClusterSize.x, ClusterNearFarWidthHeight.z) - (ClusterNearFarWidthHeight.z * 0.5)) / ClusterNearFarWidthHeight.z)) / ProjMat[0].x, (loc_d20b9 * ((min(loc_95f7a * ClusterSize.y, ClusterNearFarWidthHeight.w) - (ClusterNearFarWidthHeight.w * 0.5)) / ClusterNearFarWidthHeight.w)) / ProjMat[1].y, -loc_d20b9);
        }
        else
        {
            loc_e9bcc = vec3(0.0);
        }
        vec3 loc_b747c;
        if (loc_fcddd == 3)
        {
            loc_b747c = vec3((loc_d20b9 * ((min((loc_b9559 + 0.5) * ClusterSize.x, ClusterNearFarWidthHeight.z) - (ClusterNearFarWidthHeight.z * 0.5)) / ClusterNearFarWidthHeight.z)) / ProjMat[0].x, (loc_d20b9 * ((min((loc_95f7a + 0.5) * ClusterSize.y, ClusterNearFarWidthHeight.w) - (ClusterNearFarWidthHeight.w * 0.5)) / ClusterNearFarWidthHeight.w)) / ProjMat[1].y, -loc_d20b9);
        }
        else
        {
            loc_b747c = loc_e9bcc;
        }
        vec3 loc_5fc8c;
        loc_5fc8c = loc_b747c;
        vec3 loc_62a7e;
        for (int loc_b7579 = 0; loc_b7579 < 3; loc_5fc8c = loc_62a7e, loc_b7579++)
        {
            if (loc_fcddd == loc_b7579)
            {
                loc_62a7e = vec3((loc_d20b9 * ((min((loc_b9559 + loc_74198[loc_b7579].x) * ClusterSize.x, ClusterNearFarWidthHeight.z) - (ClusterNearFarWidthHeight.z * 0.5)) / ClusterNearFarWidthHeight.z)) / ProjMat[0].x, (loc_d20b9 * ((min((loc_95f7a + loc_74198[loc_b7579].y) * ClusterSize.y, ClusterNearFarWidthHeight.w) - (ClusterNearFarWidthHeight.w * 0.5)) / ClusterNearFarWidthHeight.w)) / ProjMat[1].y, -loc_d20b9);
            }
            else
            {
                loc_62a7e = loc_5fc8c;
            }
        }
        float loc_59c94 = loc_084cb + 1.0;
        vec2 loc_7f96a = ClusterNearFarWidthHeight.xy;
        float loc_b89da;
        func_07fed(loc_59c94, loc_b89da, loc_7f96a, loc_084cb);
        vec3 loc_e5f5c;
        loc_e5f5c = vec3(0.0);
        vec3 loc_c4421;
        for (int loc_ed667 = 3; loc_ed667 < 7; loc_e5f5c = loc_c4421, loc_ed667++)
        {
            if (loc_ecc6d == loc_ed667)
            {
                loc_c4421 = vec3((loc_b89da * ((min((loc_b9559 + loc_74198[loc_ed667].x) * ClusterSize.x, ClusterNearFarWidthHeight.z) - (ClusterNearFarWidthHeight.z * 0.5)) / ClusterNearFarWidthHeight.z)) / ProjMat[0].x, (loc_b89da * ((min((loc_95f7a + loc_74198[loc_ed667].y) * ClusterSize.y, ClusterNearFarWidthHeight.w) - (ClusterNearFarWidthHeight.w * 0.5)) / ClusterNearFarWidthHeight.w)) / ProjMat[1].y, -loc_b89da);
            }
            else
            {
                loc_c4421 = loc_e5f5c;
            }
        }
        vec3 loc_9a286;
        if (loc_ecc6d == 7)
        {
            loc_9a286 = vec3((loc_b89da * ((min((loc_b9559 + 0.5) * ClusterSize.x, ClusterNearFarWidthHeight.z) - (ClusterNearFarWidthHeight.z * 0.5)) / ClusterNearFarWidthHeight.z)) / ProjMat[0].x, (loc_b89da * ((min((loc_95f7a + 0.5) * ClusterSize.y, ClusterNearFarWidthHeight.w) - (ClusterNearFarWidthHeight.w * 0.5)) / ClusterNearFarWidthHeight.w)) / ProjMat[1].y, -loc_b89da);
        }
        else
        {
            loc_9a286 = loc_e5f5c;
        }
        float loc_fc5c3 = loc_084cb + 0.5;
        vec2 loc_ebda0 = ClusterNearFarWidthHeight.xy;
        float loc_71d2f;
        func_be74c(loc_fc5c3, loc_71d2f, loc_ebda0, loc_084cb);
        vec3 loc_b09bd = (ViewMat * vec4(loc_88c6d.xyz, 1.0)).xyz;
        float loc_fd6dc = (CameraClusterWeight.x * max(1.0 - (length(loc_b09bd) / length(loc_9a286)), 0.0)) + (CameraClusterWeight.y * max(1.0 - (length(loc_b09bd - vec3((loc_71d2f * ((min((loc_b9559 + 0.5) * ClusterSize.x, ClusterNearFarWidthHeight.z) - (ClusterNearFarWidthHeight.z * 0.5)) / ClusterNearFarWidthHeight.z)) / ProjMat[0].x, (loc_71d2f * ((min((loc_95f7a + 0.5) * ClusterSize.y, ClusterNearFarWidthHeight.w) - (ClusterNearFarWidthHeight.w * 0.5)) / ClusterNearFarWidthHeight.w)) / ProjMat[1].y, -loc_71d2f)) / (length(loc_9a286 - loc_5fc8c) * 0.5)), 0.0));
        bool loc_c1fd8 = loc_95601 >= loc_aa6c6;
        bool loc_9937a;
        if (loc_c1fd8)
        {
            loc_9937a = loc_fd6dc <= contributionArray[gl_LocalInvocationIndex][loc_95601 - 1].contribution;
        }
        else
        {
            loc_9937a = loc_c1fd8;
        }
        if (loc_9937a)
        {
            loc_e8108 = loc_95601;
            continue;
        }
        int loc_ce01b;
        loc_ce01b = 0;
        int loc_9b799;
        int loc_a0258;
        for (int loc_8b5f4 = loc_95601; loc_ce01b < loc_8b5f4; loc_8b5f4 = loc_a0258, loc_ce01b = loc_9b799)
        {
            int loc_cd6f4 = (loc_ce01b + loc_8b5f4) / 2;
            if (contributionArray[gl_LocalInvocationIndex][loc_cd6f4].contribution >= loc_fd6dc)
            {
                loc_a0258 = loc_8b5f4;
                loc_9b799 = loc_cd6f4 + 1;
            }
            else
            {
                loc_a0258 = loc_cd6f4;
                loc_9b799 = loc_ce01b;
            }
        }
        int loc_10073;
        if (loc_95601 < loc_aa6c6)
        {
            int loc_890eb = loc_95601 - 1;
            for (int loc_e6b9c = loc_890eb; loc_e6b9c >= loc_ce01b; loc_e6b9c--)
            {
                contributionArray[gl_LocalInvocationIndex][loc_e6b9c + 1] = contributionArray[gl_LocalInvocationIndex][loc_e6b9c];
            }
            contributionArray[gl_LocalInvocationIndex][loc_ce01b].contribution = loc_fd6dc;
            contributionArray[gl_LocalInvocationIndex][loc_ce01b].indexInLookUp = loc_95601;
            var_2f33b.LightLookupArray[(loc_faa56 * loc_aa6c6) + loc_95601].lookup = float(loc_e25b3);
            loc_10073 = loc_95601 + 1;
        }
        else
        {
            int loc_a107b = loc_aa6c6 - 1;
            int loc_99825 = contributionArray[gl_LocalInvocationIndex][loc_a107b].indexInLookUp;
            int loc_eb4bc = loc_aa6c6 - 2;
            for (int loc_a3cd4 = loc_eb4bc; loc_a3cd4 >= loc_ce01b; loc_a3cd4--)
            {
                contributionArray[gl_LocalInvocationIndex][loc_a3cd4 + 1] = contributionArray[gl_LocalInvocationIndex][loc_a3cd4];
            }
            contributionArray[gl_LocalInvocationIndex][loc_ce01b].contribution = loc_fd6dc;
            contributionArray[gl_LocalInvocationIndex][loc_ce01b].indexInLookUp = loc_99825;
            var_2f33b.LightLookupArray[(loc_faa56 * loc_aa6c6) + loc_99825].lookup = float(loc_e25b3);
            loc_10073 = loc_95601;
        }
        loc_e8108 = loc_10073;
    }
    if (loc_95601 < loc_aa6c6)
    {
        var_2f33b.LightLookupArray[(loc_faa56 * loc_aa6c6) + loc_95601].lookup = -1.0;
    }
}
void main() {
    uvec3 GlobalInvocationID = gl_GlobalInvocationID;
    func_f8902();
}
