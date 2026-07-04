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
uniform highp samplerCube s_CubeMap;
uniform highp vec4 ConvolutionParameters;
uniform highp vec4 ConvolutionType;
uniform highp vec4 CurrentFace;
in highp vec2 v_texCoord;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec2 var_f95e1 = v_texCoord;
    var_f95e1 = (var_f95e1 * 2.0) - vec2(1.0);
    highp vec3 var_8731e;
    switch (int(CurrentFace.x))
    {
        case 0:
        {
            var_8731e = vec3(1.0, -var_f95e1.y, -var_f95e1.x);
            break;
        }
        case 1:
        {
            var_8731e = vec3(-1.0, -var_f95e1.y, var_f95e1.x);
            break;
        }
        case 2:
        {
            var_8731e = vec3(var_f95e1.x, 1.0, var_f95e1.y);
            break;
        }
        case 3:
        {
            var_8731e = vec3(var_f95e1.x, -1.0, -var_f95e1.y);
            break;
        }
        case 4:
        {
            var_8731e = vec3(var_f95e1.x, -var_f95e1.y, 1.0);
            break;
        }
        case 5:
        {
            var_8731e = vec3(-var_f95e1.x, -var_f95e1.y, -1.0);
            break;
        }
        default:
        {
            var_8731e = vec3(0.0);
            break;
        }
    }
    highp vec3 var_55706 = normalize(var_8731e);
    highp vec3 var_76913;
    if (int(ConvolutionType.x) == 1)
    {
        highp vec3 var_e8170;
        if (int(ConvolutionParameters.y) == 0)
        {
            highp vec3 var_da4e0 = var_55706;
            bool var_6cc03 = abs(var_da4e0.y) > abs(var_da4e0.x);
            bool var_49a91;
            if (var_6cc03)
            {
                var_49a91 = abs(var_da4e0.y) > abs(var_da4e0.z);
            }
            else
            {
                var_49a91 = var_6cc03;
            }
            if (var_49a91)
            {
                var_da4e0.z *= (-1.0);
            }
            else
            {
                var_da4e0.y *= (-1.0);
            }
            var_e8170 = textureLod(s_CubeMap, var_da4e0, 0.0).xyz;
        }
        else
        {
            highp float var_4bc40 = ConvolutionParameters.y / (ConvolutionParameters.w - 1.0);
            uint var_fcd28 = uint(ConvolutionParameters.x);
            highp float var_ecce1 = float(int(ConvolutionParameters.z));
            highp float var_50730;
            highp vec3 var_5270f;
            var_5270f = vec3(0.0);
            var_50730 = 0.0;
            highp vec3 var_7740d;
            highp float var_dd71d;
            highp vec3 var_c4548;
            for (int var_d63ec = 0; var_d63ec < int(var_fcd28); var_5270f = var_c4548, var_50730 = var_dd71d, var_d63ec++)
            {
                uint var_81d42 = uint(var_d63ec);
                uint var_075db = (var_81d42 << 16u) | (var_81d42 >> 16u);
                uint var_8ff20 = ((var_075db & 1431655765u) << 1u) | ((var_075db & 2863311530u) >> 1u);
                uint var_59fd1 = ((var_8ff20 & 858993459u) << 2u) | ((var_8ff20 & 3435973836u) >> 2u);
                uint var_dfbda = ((var_59fd1 & 252645135u) << 4u) | ((var_59fd1 & 4042322160u) >> 4u);
                highp vec2 var_dc049 = vec2(float(var_81d42) / float(var_fcd28), float(((var_dfbda & 16711935u) << 8u) | ((var_dfbda & 4278255360u) >> 8u)) * 2.3283064365386962890625e-10);
                highp vec3 var_33500 = var_55706;
                highp float var_3359a = var_4bc40 * var_4bc40;
                highp float var_1012a = 6.283185482025146484375 * var_dc049.x;
                highp float var_656a5 = sqrt((1.0 - var_dc049.y) / (1.0 + (((var_3359a * var_3359a) - 1.0) * var_dc049.y)));
                highp float var_26153 = sqrt(1.0 - (var_656a5 * var_656a5));
                var_7740d.x = cos(var_1012a) * var_26153;
                var_7740d.y = sin(var_1012a) * var_26153;
                var_7740d.z = var_656a5;
                highp vec3 var_94497 = normalize(cross(mix(vec3(1.0, 0.0, 0.0), vec3(0.0, 0.0, 1.0), bvec3(abs(var_33500.z) < 0.999000012874603271484375)), var_55706));
                highp vec3 var_0e276 = ((var_94497 * var_7740d.x) + (cross(var_55706, var_94497) * var_7740d.y)) + (var_55706 * var_7740d.z);
                highp vec3 var_f29d0 = normalize((var_0e276 * (2.0 * dot(var_55706, var_0e276))) - var_55706);
                highp float var_fc1d4 = clamp(dot(var_55706, var_f29d0), 0.0, 1.0);
                if (var_fc1d4 > 0.0)
                {
                    highp float var_b51f8 = var_4bc40 * var_4bc40;
                    highp float var_54a83 = var_b51f8 * var_b51f8;
                    highp float var_85dd9 = max(dot(var_55706, var_0e276), 0.0);
                    highp float var_4b174 = (((var_54a83 - 1.0) * var_85dd9) * var_85dd9) + 1.0;
                    highp vec3 var_539a3 = var_f29d0;
                    bool var_172e9 = abs(var_539a3.y) > abs(var_539a3.x);
                    bool var_aaa05;
                    if (var_172e9)
                    {
                        var_aaa05 = abs(var_539a3.y) > abs(var_539a3.z);
                    }
                    else
                    {
                        var_aaa05 = var_172e9;
                    }
                    if (var_aaa05)
                    {
                        var_539a3.z *= (-1.0);
                    }
                    else
                    {
                        var_539a3.y *= (-1.0);
                    }
                    var_c4548 = var_5270f + (textureLod(s_CubeMap, var_539a3, max(0.5 * log2((1.0 / (float(var_fcd28) * ((var_54a83 / ((var_4b174 * var_4b174) * 3.1415927410125732421875)) * 0.249993741512298583984375))) / (12.56637096405029296875 / ((6.0 * var_ecce1) * var_ecce1))), 0.0)).xyz * var_fc1d4);
                    var_dd71d = var_50730 + var_fc1d4;
                }
                else
                {
                    var_c4548 = var_5270f;
                    var_dd71d = var_50730;
                }
            }
            var_e8170 = var_5270f / vec3(max(0.001000000047497451305389404296875, var_50730));
        }
        var_76913 = var_e8170;
    }
    else
    {
        highp vec3 var_eaf53 = var_55706;
        bool var_fb1b0 = abs(var_eaf53.y) > abs(var_eaf53.x);
        bool var_50203;
        if (var_fb1b0)
        {
            var_50203 = abs(var_eaf53.y) > abs(var_eaf53.z);
        }
        else
        {
            var_50203 = var_fb1b0;
        }
        if (var_50203)
        {
            var_eaf53.z *= (-1.0);
        }
        else
        {
            var_eaf53.y *= (-1.0);
        }
        var_76913 = textureLod(s_CubeMap, var_eaf53, float(int(ConvolutionParameters.y))).xyz;
    }
    bgfx_FragColor = vec4(var_76913, 1.0);
}
