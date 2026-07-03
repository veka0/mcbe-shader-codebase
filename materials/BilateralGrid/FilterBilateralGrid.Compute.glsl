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

layout(local_size_x = 8, local_size_y = 8, local_size_z = 8) in;
struct GridCell {
    uint weight;
    uint value;
};

layout(binding = 1, std430) buffer s_BilateralGrid { GridCell BilateralGrid[]; } var_18ab7;
layout(location = 0, binding = 2, rgba16f) uniform writeonly highp image3D s_FilteredBilateralGridOutput;
uniform vec4 BilateralFilterParams;
uniform vec4 GridDimensions;
void main() {
    uvec3 GlobalInvocationID = gl_GlobalInvocationID;
    bool var_0c978 = GlobalInvocationID.x < uint(GridDimensions.x);
    bool var_8269e;
    if (var_0c978)
    {
        var_8269e = GlobalInvocationID.y < uint(GridDimensions.y);
    }
    else
    {
        var_8269e = var_0c978;
    }
    bool var_86d1f;
    if (var_8269e)
    {
        var_86d1f = GlobalInvocationID.z < uint(GridDimensions.z);
    }
    else
    {
        var_86d1f = var_8269e;
    }
    if (var_86d1f)
    {
        int var_c1413 = int(BilateralFilterParams.x);
        float var_7aa16 = (0.5 * float(var_c1413)) * float(var_c1413);
        uint var_9020e = uint(clamp(int(GlobalInvocationID.x) - var_c1413, 0, int(GridDimensions.x) - 1));
        uint var_284d9 = uint(clamp(int(GlobalInvocationID.x) + var_c1413, 0, int(GridDimensions.x) - 1));
        uint var_1bdce = uint(clamp(int(GlobalInvocationID.y) - var_c1413, 0, int(GridDimensions.y) - 1));
        uint var_76aee = uint(clamp(int(GlobalInvocationID.y) + var_c1413, 0, int(GridDimensions.y) - 1));
        float var_4d489;
        float var_60e32;
        float var_56db5;
        var_56db5 = 0.0;
        var_60e32 = 0.0;
        var_4d489 = 0.0;
        float var_fb52b;
        float var_d321f;
        float var_c5565;
        for (uint var_b0725 = var_1bdce; var_b0725 <= var_76aee; var_56db5 = var_d321f, var_60e32 = var_c5565, var_4d489 = var_fb52b, var_b0725++)
        {
            var_c5565 = var_60e32;
            var_d321f = var_56db5;
            var_fb52b = var_4d489;
            float var_8de10;
            float var_73852;
            float var_5593e;
            for (uint var_c27ce = var_9020e; var_c27ce <= var_284d9; var_c5565 = var_5593e, var_d321f = var_73852, var_fb52b = var_8de10, var_c27ce++)
            {
                uvec3 var_9920a = uvec3(GridDimensions.xyz);
                uvec3 var_e40a1 = uvec3(var_c27ce, var_b0725, GlobalInvocationID.z);
                uint var_274b7 = (((var_e40a1.z * var_9920a.x) * var_9920a.y) + (var_e40a1.y * var_9920a.x)) + var_e40a1.x;
                vec2 var_dcf15 = vec2(float(var_c27ce) - float(GlobalInvocationID.x), float(var_b0725) - float(GlobalInvocationID.y));
                float var_064ee = exp((-((var_dcf15.x * var_dcf15.x) + (var_dcf15.y * var_dcf15.y))) / var_7aa16);
                var_8de10 = var_fb52b + (var_064ee * (float(var_18ab7.BilateralGrid[var_274b7].weight) * 0.00390625));
                var_73852 = var_d321f + (var_064ee * (float(var_18ab7.BilateralGrid[var_274b7].value) * 0.00390625));
                var_5593e = var_c5565 + var_064ee;
            }
        }
        imageStore(s_FilteredBilateralGridOutput, ivec3(int(GlobalInvocationID.x), int(GlobalInvocationID.y), int(GlobalInvocationID.z)), vec4(var_4d489 / var_60e32, var_56db5 / var_60e32, 0.0, 0.0));
    }
}
