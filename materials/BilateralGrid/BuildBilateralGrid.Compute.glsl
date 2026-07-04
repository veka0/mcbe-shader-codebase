#version 310 es

/*
* Available Macros:
*
* Passes:
* - BUILD_BILATERAL_GRID_PASS (not used)
* - CLEAR_BILATERAL_GRID_PASS (not used)
* - FILTER_BILATERAL_GRID_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_AverageLuminance;
* - layout(binding = 1, std430) buffer s_BilateralGridBuffer { GridCell s_BilateralGrid[]; };
* - uniform lowp sampler3D s_FilteredBilateralGridOutput;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
* - uniform lowp sampler2D s_SceneColor;
*
* Uniforms:
* - uniform vec4 BilateralFilterParams;
* - uniform vec4 BilateralGridParams;
* - uniform vec4 GridDimensions;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 SceneResolutionAndRecipSceneResolution;
*/

layout(local_size_x = 16, local_size_y = 16, local_size_z = 1) in;
struct GridCell {
    uint weight;
    uint value;
};

layout(binding = 1, std430) buffer s_BilateralGrid { GridCell BilateralGrid[]; } var_1f7e0;
uniform highp sampler2D s_PreviousFrameAverageLuminance;
uniform highp sampler2D s_SceneColor;
uniform vec4 BilateralGridParams;
uniform vec4 GridDimensions;
uniform vec4 PreExposureEnabled;
uniform vec4 SceneResolutionAndRecipSceneResolution;
void main() {
    uvec3 GlobalInvocationID = gl_GlobalInvocationID;
    bool var_f7783 = GlobalInvocationID.x < uint(SceneResolutionAndRecipSceneResolution.x);
    bool var_834b5;
    if (var_f7783)
    {
        var_834b5 = GlobalInvocationID.y < uint(SceneResolutionAndRecipSceneResolution.y);
    }
    else
    {
        var_834b5 = var_f7783;
    }
    if (var_834b5)
    {
        vec3 var_8120d = texelFetch(s_SceneColor, ivec2(int(GlobalInvocationID.x), int(GlobalInvocationID.y)), 0).xyz;
        vec3 var_f2211;
        if (PreExposureEnabled.x > 0.0)
        {
            var_f2211 = var_8120d / vec3((0.180000007152557373046875 / texelFetch(s_PreviousFrameAverageLuminance, ivec2(0), 0).x) + 9.9999997473787516355514526367188e-05);
        }
        else
        {
            var_f2211 = var_8120d;
        }
        float var_cc2f2 = (log2(dot(var_f2211, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))) - BilateralGridParams.x) / (BilateralGridParams.y - BilateralGridParams.x);
        float var_a69ee = GridDimensions.z * var_cc2f2;
        uvec2 var_8ce2e = uvec2(((vec2(float(GlobalInvocationID.x), float(GlobalInvocationID.y)) + vec2(0.5)) * SceneResolutionAndRecipSceneResolution.zw) * GridDimensions.xy);
        uint var_79fc6 = uint(clamp(int(var_a69ee), 0, int(GridDimensions.z) - 2));
        uvec3 var_18f28 = uvec3(GridDimensions.xyz);
        uvec3 var_e7e5c = uvec3(var_8ce2e, var_79fc6);
        uint var_6324c = (((var_e7e5c.z * var_18f28.x) * var_18f28.y) + (var_e7e5c.y * var_18f28.x)) + var_e7e5c.x;
        uvec3 var_3e70a = uvec3(GridDimensions.xyz);
        uvec3 var_8f053 = uvec3(var_8ce2e, var_79fc6 + 1u);
        uint var_78299 = (((var_8f053.z * var_3e70a.x) * var_3e70a.y) + (var_8f053.y * var_3e70a.x)) + var_8f053.x;
        float var_b5d7d = clamp(var_a69ee - float(var_79fc6), 0.0, 1.0);
        float var_ce1f7 = 1.0 - var_b5d7d;
        uint var_aa3f4 = atomicAdd(var_1f7e0.BilateralGrid[var_6324c].weight, uint(var_ce1f7 * 256.0));
        uint var_0bf9a = atomicAdd(var_1f7e0.BilateralGrid[var_6324c].value, uint((var_ce1f7 * var_cc2f2) * 256.0));
        uint var_4e27e = atomicAdd(var_1f7e0.BilateralGrid[var_78299].weight, uint(var_b5d7d * 256.0));
        uint var_88e9f = atomicAdd(var_1f7e0.BilateralGrid[var_78299].value, uint((var_b5d7d * var_cc2f2) * 256.0));
    }
}
