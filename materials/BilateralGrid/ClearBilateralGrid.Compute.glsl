#version 310 es

/*
* Available Macros:
*
* Passes:
* - BUILD_BILATERAL_GRID_PASS (not used)
* - CLEAR_BILATERAL_GRID_PASS (not used)
* - FILTER_BILATERAL_GRID_PASS (not used)
*
* ThreadLimit:
* - THREAD_LIMIT__LIMITED_AT128
* - THREAD_LIMIT__LIMITED_AT256
* - THREAD_LIMIT__LIMITED_AT64 (not used)
* - THREAD_LIMIT__NATIVE
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
* - uniform vec4 GridDimensions;
* - uniform vec4 LuminanceRangeParams;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 SceneResolutionAndRecipSceneResolution;
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
struct GridCell {
    uint weight;
    uint value;
};

layout(binding = 1, std430) buffer s_BilateralGrid { GridCell BilateralGrid[]; } var_2890f;
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
        uint var_dfcaa = (((GlobalInvocationID.y * uint(GridDimensions.x)) + GlobalInvocationID.x) * uint(GridDimensions.z)) + GlobalInvocationID.z;
        var_2890f.BilateralGrid[var_dfcaa].weight = 0u;
        var_2890f.BilateralGrid[var_dfcaa].value = 0u;
    }
}
