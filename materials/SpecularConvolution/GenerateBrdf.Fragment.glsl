#version 310 es

/*
* Available Macros:
*
* Passes:
* - CONVOLVE_PASS (not used)
* - FALLBACK_PASS (not used)
* - GENERATE_BRDF_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp samplerCube s_CubeMap;
*
* Uniforms:
* - uniform vec4 ConvolutionParameters;
* - uniform vec4 ConvolutionType;
* - uniform vec4 CurrentFace;
*/

precision mediump float;
precision highp int;
uniform highp vec4 ConvolutionParameters;
in highp vec2 v_texCoord;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec2 var_66eed = v_texCoord;
    highp vec3 var_eb3d3;
    var_eb3d3.x = sqrt(1.0 - (var_66eed.x * var_66eed.x));
    var_eb3d3.y = 0.0;
    var_eb3d3.z = var_66eed.x;
    highp float var_a4178;
    highp float var_54144;
    var_54144 = 0.0;
    var_a4178 = 0.0;
    highp vec3 var_c05c2;
    highp float var_49334;
    highp float var_36767;
    for (int var_6b7f2 = 0; var_6b7f2 < int(ConvolutionParameters.x); var_54144 = var_36767, var_a4178 = var_49334, var_6b7f2++)
    {
        uint var_ba9cd = uint(var_6b7f2);
        uint var_8edf4 = (var_ba9cd << 16u) | (var_ba9cd >> 16u);
        uint var_412c8 = ((var_8edf4 & 1431655765u) << 1u) | ((var_8edf4 & 2863311530u) >> 1u);
        uint var_8f8af = ((var_412c8 & 858993459u) << 2u) | ((var_412c8 & 3435973836u) >> 2u);
        uint var_5e4f2 = ((var_8f8af & 252645135u) << 4u) | ((var_8f8af & 4042322160u) >> 4u);
        highp vec2 var_3de28 = vec2(float(var_ba9cd) / float(uint(ConvolutionParameters.x)), float(((var_5e4f2 & 16711935u) << 8u) | ((var_5e4f2 & 4278255360u) >> 8u)) * 2.3283064365386962890625e-10);
        highp vec3 var_7f064 = vec3(0.0, 0.0, 1.0);
        highp float var_0b907 = var_66eed.y * var_66eed.y;
        highp float var_c9f6e = 6.283185482025146484375 * var_3de28.x;
        highp float var_38116 = sqrt((1.0 - var_3de28.y) / (1.0 + (((var_0b907 * var_0b907) - 1.0) * var_3de28.y)));
        highp float var_07aff = sqrt(1.0 - (var_38116 * var_38116));
        var_c05c2.x = cos(var_c9f6e) * var_07aff;
        var_c05c2.y = sin(var_c9f6e) * var_07aff;
        var_c05c2.z = var_38116;
        bool var_70d22 = abs(var_7f064.z) > abs(var_7f064.x);
        bool var_c8de1;
        if (var_70d22)
        {
            var_c8de1 = abs(var_7f064.z) > abs(var_7f064.y);
        }
        else
        {
            var_c8de1 = var_70d22;
        }
        highp vec3 var_888e1;
        if (var_c8de1)
        {
            var_888e1 = vec3(1.0, 0.0, 0.0);
        }
        else
        {
            var_888e1 = vec3(0.0, 0.0, 1.0);
        }
        highp vec3 var_c2558 = normalize(cross(var_888e1, vec3(0.0, 0.0, 1.0)));
        highp vec3 var_109c0 = ((var_c2558 * var_c05c2.x) + (cross(vec3(0.0, 0.0, 1.0), var_c2558) * var_c05c2.y)) + (vec3(0.0, 0.0, 1.0) * var_c05c2.z);
        highp vec3 var_9b4ae = var_109c0;
        highp vec3 var_7aacc = (var_109c0 * (2.0 * dot(var_eb3d3, var_109c0))) - var_eb3d3;
        highp float var_8c821 = clamp(var_7aacc.z, 0.0, 1.0);
        highp float var_16929 = clamp(dot(var_eb3d3, var_109c0), 0.0, 1.0);
        if (var_8c821 > 0.0)
        {
            highp float var_7c701 = (var_66eed.y * var_66eed.y) * 0.5;
            highp float var_8a442 = (((var_66eed.x / (((var_66eed.x * (1.0 - var_7c701)) + var_7c701) + 9.9999997473787516355514526367188e-05)) * (var_8c821 / (((var_8c821 * (1.0 - var_7c701)) + var_7c701) + 9.9999997473787516355514526367188e-05))) * var_16929) / (clamp(var_9b4ae.z, 0.0, 1.0) * var_66eed.x);
            highp float var_ac0d0 = 1.0 - var_16929;
            highp float var_a0dea = var_ac0d0 * var_ac0d0;
            highp float var_6d628 = (var_a0dea * var_a0dea) * var_ac0d0;
            var_36767 = var_54144 + (var_6d628 * var_8a442);
            var_49334 = var_a4178 + ((1.0 - var_6d628) * var_8a442);
        }
        else
        {
            var_36767 = var_54144;
            var_49334 = var_a4178;
        }
    }
    highp vec2 var_67543 = vec2(var_a4178 / ConvolutionParameters.x, var_54144 / ConvolutionParameters.x);
    bgfx_FragColor = vec4(var_67543.x, var_67543.y, 0.0, 1.0);
}
