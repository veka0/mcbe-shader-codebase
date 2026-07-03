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
* - uniform vec4 CurrentFace;
*/

precision mediump float;
precision highp int;
uniform highp samplerCube s_CubeMap;
uniform highp vec4 ConvolutionParameters;
uniform highp vec4 CurrentFace;
in highp vec2 v_texCoord;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    int var_a9bf2 = int(CurrentFace.x);
    highp vec2 var_51b71 = (v_texCoord * 2.0) - vec2(1.0);
    highp vec3 var_4e08d;
    if (var_a9bf2 == 0)
    {
        var_4e08d = vec3(1.0, -var_51b71.y, -var_51b71.x);
    }
    else
    {
        highp vec3 var_4c2c6;
        if (var_a9bf2 == 1)
        {
            var_4c2c6 = vec3(-1.0, -var_51b71.y, var_51b71.x);
        }
        else
        {
            highp vec3 var_5c2b4;
            if (var_a9bf2 == 2)
            {
                var_5c2b4 = vec3(var_51b71.x, 1.0, var_51b71.y);
            }
            else
            {
                highp vec3 var_34e6b;
                if (var_a9bf2 == 3)
                {
                    var_34e6b = vec3(var_51b71.x, -1.0, -var_51b71.y);
                }
                else
                {
                    highp vec3 var_48d9d;
                    if (var_a9bf2 == 4)
                    {
                        var_48d9d = vec3(var_51b71.x, -var_51b71.y, 1.0);
                    }
                    else
                    {
                        highp vec3 var_f340e;
                        if (var_a9bf2 == 5)
                        {
                            var_f340e = vec3(-var_51b71.x, -var_51b71.y, -1.0);
                        }
                        else
                        {
                            var_f340e = vec3(0.0);
                        }
                        var_48d9d = var_f340e;
                    }
                    var_34e6b = var_48d9d;
                }
                var_5c2b4 = var_34e6b;
            }
            var_4c2c6 = var_5c2b4;
        }
        var_4e08d = var_4c2c6;
    }
    highp vec3 var_87300 = normalize(var_4e08d);
    highp vec3 var_bb7ff;
    if (int(ConvolutionParameters.y) == 0)
    {
        var_bb7ff = textureLod(s_CubeMap, var_87300, 0.0).xyz;
    }
    else
    {
        highp float var_74b01 = ConvolutionParameters.y / (ConvolutionParameters.w - 1.0);
        uint var_49670 = uint(ConvolutionParameters.x);
        highp float var_c2ebf = float(int(ConvolutionParameters.z));
        highp float var_5813b;
        highp vec3 var_f6f4d;
        var_f6f4d = vec3(0.0);
        var_5813b = 0.0;
        highp vec3 var_c86e6;
        highp float var_8354f;
        highp vec3 var_fcb6a;
        for (int var_cf774 = 0; var_cf774 < int(var_49670); var_f6f4d = var_fcb6a, var_5813b = var_8354f, var_cf774++)
        {
            uint var_80ede = uint(var_cf774);
            uint var_bf26b = (var_80ede << 16u) | (var_80ede >> 16u);
            uint var_31931 = ((var_bf26b & 1431655765u) << 1u) | ((var_bf26b & 2863311530u) >> 1u);
            uint var_c6ea2 = ((var_31931 & 858993459u) << 2u) | ((var_31931 & 3435973836u) >> 2u);
            uint var_87e84 = ((var_c6ea2 & 252645135u) << 4u) | ((var_c6ea2 & 4042322160u) >> 4u);
            highp vec2 var_39d57 = vec2(float(var_80ede) / float(var_49670), float(((var_87e84 & 16711935u) << 8u) | ((var_87e84 & 4278255360u) >> 8u)) * 2.3283064365386962890625e-10);
            highp vec3 var_cff2e = var_87300;
            highp float var_558e0 = var_74b01 * var_74b01;
            highp float var_186fc = 6.283185482025146484375 * var_39d57.x;
            highp float var_03a14 = sqrt((1.0 - var_39d57.y) / (1.0 + (((var_558e0 * var_558e0) - 1.0) * var_39d57.y)));
            highp float var_203f5 = sqrt(1.0 - (var_03a14 * var_03a14));
            var_c86e6.x = cos(var_186fc) * var_203f5;
            var_c86e6.y = sin(var_186fc) * var_203f5;
            var_c86e6.z = var_03a14;
            bool var_0f180 = abs(var_cff2e.z) > abs(var_cff2e.x);
            bool var_42fd4;
            if (var_0f180)
            {
                var_42fd4 = abs(var_cff2e.z) > abs(var_cff2e.y);
            }
            else
            {
                var_42fd4 = var_0f180;
            }
            highp vec3 var_49cb9;
            if (var_42fd4)
            {
                var_49cb9 = vec3(1.0, 0.0, 0.0);
            }
            else
            {
                var_49cb9 = vec3(0.0, 0.0, 1.0);
            }
            highp vec3 var_3d8ac = normalize(cross(var_49cb9, var_87300));
            highp vec3 var_27349 = ((var_3d8ac * var_c86e6.x) + (cross(var_87300, var_3d8ac) * var_c86e6.y)) + (var_87300 * var_c86e6.z);
            highp vec3 var_4a4ca = (var_27349 * (2.0 * dot(var_87300, var_27349))) - var_87300;
            highp float var_2b693 = clamp(dot(var_87300, var_4a4ca), 0.0, 1.0);
            if (var_2b693 > 0.0)
            {
                highp float var_464ee = var_74b01 * var_74b01;
                highp float var_14b02 = var_464ee * var_464ee;
                highp float var_7e8fc = max(dot(var_87300, var_27349), 0.0);
                highp float var_f444a = (((var_14b02 - 1.0) * var_7e8fc) * var_7e8fc) + 1.0;
                var_fcb6a = var_f6f4d + (textureLod(s_CubeMap, var_4a4ca, max(0.5 * log2((1.0 / (float(var_49670) * ((var_14b02 / ((var_f444a * var_f444a) * 3.1415927410125732421875)) * 0.249993741512298583984375))) / (12.56637096405029296875 / ((6.0 * var_c2ebf) * var_c2ebf))), 0.0)).xyz * var_2b693);
                var_8354f = var_5813b + var_2b693;
            }
            else
            {
                var_fcb6a = var_f6f4d;
                var_8354f = var_5813b;
            }
        }
        var_bb7ff = var_f6f4d / vec3(max(0.001000000047497451305389404296875, var_5813b));
    }
    bgfx_FragColor = vec4(var_bb7ff, 1.0);
}
