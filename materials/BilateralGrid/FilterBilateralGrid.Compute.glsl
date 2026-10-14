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

layout(binding = 4, std430) buffer s_BilateralGrid { GridCell BilateralGrid[]; } var_04520;
layout(location = 0, binding = 3, rgba16f) uniform writeonly highp image3D s_FilteredBilateralGridOutput;
uniform vec4 BilateralFilterParams;
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
        int var_2c2b7 = int(BilateralFilterParams.x);
        float var_7aa16 = (0.5 * float(var_2c2b7)) * float(var_2c2b7);
        uint var_5b59e = uint(clamp(int(gl_GlobalInvocationID.x) - var_2c2b7, 0, int(GridDimensions.x) - 1));
        uint var_ac1fa = uint(clamp(int(gl_GlobalInvocationID.x) + var_2c2b7, 0, int(GridDimensions.x) - 1));
        uint var_aa84a = uint(clamp(int(gl_GlobalInvocationID.y) - var_2c2b7, 0, int(GridDimensions.y) - 1));
        uint var_f54a3 = uint(clamp(int(gl_GlobalInvocationID.y) + var_2c2b7, 0, int(GridDimensions.y) - 1));
        float var_0ec25;
        float var_5ffc7;
        float var_2e666;
        var_2e666 = 0.0;
        var_5ffc7 = 0.0;
        var_0ec25 = 0.0;
        float var_fb52b;
        float var_d321f;
        float var_c5565;
        for (uint var_08815 = var_aa84a; var_08815 <= var_f54a3; var_2e666 = var_d321f, var_5ffc7 = var_c5565, var_0ec25 = var_fb52b, var_08815++)
        {
            var_c5565 = var_5ffc7;
            var_d321f = var_2e666;
            var_fb52b = var_0ec25;
            float var_8de10;
            float var_73852;
            float var_5593e;
            for (uint var_175d2 = var_5b59e; var_175d2 <= var_ac1fa; var_c5565 = var_5593e, var_d321f = var_73852, var_fb52b = var_8de10, var_175d2++)
            {
                uvec3 var_9920a = uvec3(GridDimensions.xyz);
                uvec3 var_1b1c8 = uvec3(var_175d2, var_08815, gl_GlobalInvocationID.z);
                uint var_274b7 = (((var_1b1c8.z * var_9920a.x) * var_9920a.y) + (var_1b1c8.y * var_9920a.x)) + var_1b1c8.x;
                vec2 var_4c8c0 = vec2(float(var_175d2) - float(gl_GlobalInvocationID.x), float(var_08815) - float(gl_GlobalInvocationID.y));
                float var_064ee = exp((-((var_4c8c0.x * var_4c8c0.x) + (var_4c8c0.y * var_4c8c0.y))) / var_7aa16);
                var_8de10 = var_fb52b + (var_064ee * (float(var_04520.BilateralGrid[var_274b7].weight) * 0.00390625));
                var_73852 = var_d321f + (var_064ee * (float(var_04520.BilateralGrid[var_274b7].value) * 0.00390625));
                var_5593e = var_c5565 + var_064ee;
            }
        }
        imageStore(s_FilteredBilateralGridOutput, ivec3(int(gl_GlobalInvocationID.x), int(gl_GlobalInvocationID.y), int(gl_GlobalInvocationID.z)), vec4(var_0ec25 / var_5ffc7, var_2e666 / var_5ffc7, 0.0, 0.0));
    }
}
