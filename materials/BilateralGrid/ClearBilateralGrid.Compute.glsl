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
* - layout(binding = 4, std430) buffer s_BilateralGridBuffer { GridCell s_BilateralGrid[]; };
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

layout(binding = 4, std430) buffer s_BilateralGrid { GridCell BilateralGrid[]; } var_f763a;
uniform vec4 GridDimensions;
void main() {
    bool var_ea030 = gl_GlobalInvocationID.x < uint(GridDimensions.x);
    bool var_b7c23;
    if (var_ea030)
    {
        var_b7c23 = gl_GlobalInvocationID.y < uint(GridDimensions.y);
    }
    else
    {
        var_b7c23 = var_ea030;
    }
    bool var_a111d;
    if (var_b7c23)
    {
        var_a111d = gl_GlobalInvocationID.z < uint(GridDimensions.z);
    }
    else
    {
        var_a111d = var_b7c23;
    }
    if (var_a111d)
    {
        uint var_80c70 = (((gl_GlobalInvocationID.y * uint(GridDimensions.x)) + gl_GlobalInvocationID.x) * uint(GridDimensions.z)) + gl_GlobalInvocationID.z;
        var_f763a.BilateralGrid[var_80c70].weight = 0u;
        var_f763a.BilateralGrid[var_80c70].value = 0u;
    }
}
