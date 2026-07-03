#version 310 es

/*
* Available Macros:
*
* Passes:
* - COLOR_POST_PROCESS_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_AverageLuminance;
* - uniform lowp sampler2D s_ColorTexture;
* - uniform lowp sampler2D s_CustomExposureCompensation;
* - uniform lowp sampler2D s_PreExposureLuminance;
* - uniform lowp sampler2D s_RasterColor;
* - uniform lowp sampler2D s_RasterizedColor;
*
* Uniforms:
* - uniform vec4 ColorGrading_Contrast_Highlights;
* - uniform vec4 ColorGrading_Contrast_Midtones;
* - uniform vec4 ColorGrading_Contrast_Shadows;
* - uniform vec4 ColorGrading_Gain_Highlights;
* - uniform vec4 ColorGrading_Gain_Midtones;
* - uniform vec4 ColorGrading_Gain_Shadows;
* - uniform vec4 ColorGrading_Gamma_Highlights;
* - uniform vec4 ColorGrading_Gamma_Midtones;
* - uniform vec4 ColorGrading_Gamma_PlayerUI;
* - uniform vec4 ColorGrading_Gamma_Shadows;
* - uniform vec4 ColorGrading_Misc;
* - uniform vec4 ColorGrading_Offset_Highlights;
* - uniform vec4 ColorGrading_Offset_Midtones;
* - uniform vec4 ColorGrading_Offset_Shadows;
* - uniform vec4 ColorGrading_Saturation_Highlights;
* - uniform vec4 ColorGrading_Saturation_Midtones;
* - uniform vec4 ColorGrading_Saturation_Shadows;
* - uniform vec4 ColorGrading_Temperature_Params;
* - uniform vec4 ExposureCompensation;
* - uniform vec4 GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk;
* - uniform vec4 GenericTonemapperCrosstalkParams;
* - uniform vec4 LuminanceMinMaxAndWhitePointAndMinWhitePoint;
* - uniform vec4 RasterizedColorEnabled;
* - uniform vec4 ScreenSize;
* - uniform vec4 TonemapParams0;
* - uniform vec4 ViewportScale;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_AverageLuminance;
uniform highp sampler2D s_ColorTexture;
uniform highp sampler2D s_CustomExposureCompensation;
uniform highp sampler2D s_PreExposureLuminance;
uniform highp sampler2D s_RasterizedColor;
uniform highp vec4 ColorGrading_Contrast_Highlights;
uniform highp vec4 ColorGrading_Contrast_Midtones;
uniform highp vec4 ColorGrading_Contrast_Shadows;
uniform highp vec4 ColorGrading_Gain_Highlights;
uniform highp vec4 ColorGrading_Gain_Midtones;
uniform highp vec4 ColorGrading_Gain_Shadows;
uniform highp vec4 ColorGrading_Gamma_Highlights;
uniform highp vec4 ColorGrading_Gamma_Midtones;
uniform highp vec4 ColorGrading_Gamma_PlayerUI;
uniform highp vec4 ColorGrading_Gamma_Shadows;
uniform highp vec4 ColorGrading_Misc;
uniform highp vec4 ColorGrading_Offset_Highlights;
uniform highp vec4 ColorGrading_Offset_Midtones;
uniform highp vec4 ColorGrading_Offset_Shadows;
uniform highp vec4 ColorGrading_Saturation_Highlights;
uniform highp vec4 ColorGrading_Saturation_Midtones;
uniform highp vec4 ColorGrading_Saturation_Shadows;
uniform highp vec4 ColorGrading_Temperature_Params;
uniform highp vec4 ExposureCompensation;
uniform highp vec4 GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk;
uniform highp vec4 GenericTonemapperCrosstalkParams;
uniform highp vec4 LuminanceMinMaxAndWhitePointAndMinWhitePoint;
uniform highp vec4 RasterizedColorEnabled;
uniform highp vec4 TonemapParams0;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_be1e6 = texture(s_ColorTexture, v_texcoord0.xy);
    highp vec3 var_f0fbb = var_be1e6.xyz;
    highp vec3 var_9db8c;
    if (TonemapParams0.z > 0.0)
    {
        var_9db8c = var_f0fbb / vec3((0.180000007152557373046875 / texture(s_PreExposureLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_9db8c = var_f0fbb;
    }
    highp float var_b9f0e;
    if (ExposureCompensation.z > 0.5)
    {
        var_b9f0e = clamp(texture(s_AverageLuminance, vec2(0.5)).x, LuminanceMinMaxAndWhitePointAndMinWhitePoint.x, LuminanceMinMaxAndWhitePointAndMinWhitePoint.y);
    }
    else
    {
        var_b9f0e = 0.180000007152557373046875;
    }
    int var_bb4e7 = int(ExposureCompensation.x);
    highp float var_482cd;
    if ((var_bb4e7 > 0) && (var_bb4e7 < 2))
    {
        var_482cd = 1.0299999713897705078125 - (2.0 / ((0.4342944920063018798828125 * log(var_b9f0e + 1.0)) + 2.0));
    }
    else
    {
        highp float var_bc41e;
        if (var_bb4e7 > 1)
        {
            highp float var_1cefa;
            if (LuminanceMinMaxAndWhitePointAndMinWhitePoint.x == LuminanceMinMaxAndWhitePointAndMinWhitePoint.y)
            {
                var_1cefa = 0.5;
            }
            else
            {
                var_1cefa = ((log2(var_b9f0e) + 3.0) - (log2(LuminanceMinMaxAndWhitePointAndMinWhitePoint.x) + 3.0)) / ((log2(LuminanceMinMaxAndWhitePointAndMinWhitePoint.y) + 3.0) - (log2(LuminanceMinMaxAndWhitePointAndMinWhitePoint.x) + 3.0));
            }
            var_bc41e = texture(s_CustomExposureCompensation, vec2(var_1cefa, 0.5)).x;
        }
        else
        {
            var_bc41e = ExposureCompensation.y;
        }
        var_482cd = var_bc41e;
    }
    highp float var_830e7 = dot(var_9db8c, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
    highp vec3 var_89b58;
    if (ColorGrading_Temperature_Params.x != 0.0)
    {
        highp vec3 var_effe7 = vec3(0.312720000743865966796875, 0.3290300071239471435546875, 1.0);
        highp vec3 var_e9388 = mat3(vec3(0.732800006866455078125, 0.4296000003814697265625, -0.1624000072479248046875), vec3(-0.703599989414215087890625, 1.6974999904632568359375, 0.006099999882280826568603515625), vec3(0.0030000000260770320892333984375, 0.013600000180304050445556640625, 0.98339998722076416015625)) * vec3((var_effe7.x * var_effe7.z) / var_effe7.y, var_effe7.z, (((1.0 - var_effe7.x) - var_effe7.y) * var_effe7.z) / var_effe7.y);
        highp vec2 var_05857 = vec2(((0.860117733478546142578125 + (0.00015411825734190642833709716796875 * ColorGrading_Temperature_Params.y)) + ((1.2864121856637211749330163002014e-07 * ColorGrading_Temperature_Params.y) * ColorGrading_Temperature_Params.y)) / ((1.0 + (0.0008424202096648514270782470703125 * ColorGrading_Temperature_Params.y)) + ((7.0814513719597016461193561553955e-07 * ColorGrading_Temperature_Params.y) * ColorGrading_Temperature_Params.y)), ((0.317398726940155029296875 + (4.2280626075807958841323852539062e-05 * ColorGrading_Temperature_Params.y)) + ((4.2048167614439080352894961833954e-08 * ColorGrading_Temperature_Params.y) * ColorGrading_Temperature_Params.y)) / ((1.0 - (2.8974181986995972692966461181641e-05 * ColorGrading_Temperature_Params.y)) + ((1.6145605741257895715534687042236e-07 * ColorGrading_Temperature_Params.y) * ColorGrading_Temperature_Params.y)));
        highp vec3 var_a3514 = vec3(vec2(3.0 * var_05857.x, 2.0 * var_05857.y) / vec2(((2.0 * var_05857.x) - (8.0 * var_05857.y)) + 4.0), 1.0);
        highp vec3 var_acaf6 = mat3(vec3(0.732800006866455078125, 0.4296000003814697265625, -0.1624000072479248046875), vec3(-0.703599989414215087890625, 1.6974999904632568359375, 0.006099999882280826568603515625), vec3(0.0030000000260770320892333984375, 0.013600000180304050445556640625, 0.98339998722076416015625)) * vec3((var_a3514.x * var_a3514.z) / var_a3514.y, var_a3514.z, (((1.0 - var_a3514.x) - var_a3514.y) * var_a3514.z) / var_a3514.y);
        highp vec3 var_5eed8;
        if (int(ColorGrading_Temperature_Params.z) == 0)
        {
            var_5eed8 = var_e9388 / var_acaf6;
        }
        else
        {
            var_5eed8 = var_acaf6 / var_e9388;
        }
        highp vec3 var_06534 = var_5eed8;
        var_89b58 = (mat3(vec3(2.8589999675750732421875, -1.6289999485015869140625, -0.02500000037252902984619140625), vec3(-0.20999999344348907470703125, 1.15799999237060546875, 0.0), vec3(-0.0419999994337558746337890625, -0.1180000007152557373046875, 1.0690000057220458984375)) * (mat3(vec3(var_06534.x, 0.0, 0.0), vec3(0.0, var_06534.y, 0.0), vec3(0.0, 0.0, var_06534.z)) * mat3(vec3(0.38999998569488525390625, 0.550000011920928955078125, 0.0089999996125698089599609375), vec3(0.071000002324581146240234375, 0.962999999523162841796875, 0.001000000047497451305389404296875), vec3(0.02300000004470348358154296875, 0.12800000607967376708984375, 0.93599998950958251953125)))) * var_9db8c;
    }
    else
    {
        var_89b58 = var_9db8c;
    }
    bool var_710bf = ColorGrading_Contrast_Highlights.w != 0.0;
    bool var_3ddc3 = ColorGrading_Contrast_Shadows.w != 0.0;
    bool var_c60f8;
    if (var_710bf)
    {
        var_c60f8 = var_830e7 >= (var_b9f0e * ColorGrading_Misc.y);
    }
    else
    {
        var_c60f8 = var_710bf;
    }
    highp vec3 var_1cf7f;
    if (var_c60f8)
    {
        var_1cf7f = ColorGrading_Contrast_Highlights.xyz;
    }
    else
    {
        bool var_4356f;
        if (var_3ddc3)
        {
            var_4356f = var_830e7 <= (var_b9f0e * ColorGrading_Misc.z);
        }
        else
        {
            var_4356f = var_3ddc3;
        }
        highp vec3 var_b69b3;
        if (var_4356f)
        {
            var_b69b3 = ColorGrading_Contrast_Shadows.xyz;
        }
        else
        {
            highp vec3 var_9b38c;
            if (ColorGrading_Contrast_Midtones.w != 0.0)
            {
                highp vec3 var_704f5;
                if ((var_830e7 < var_b9f0e) && var_3ddc3)
                {
                    var_704f5 = mix(ColorGrading_Contrast_Shadows.xyz, ColorGrading_Contrast_Midtones.xyz, vec3((var_830e7 - (var_b9f0e * ColorGrading_Misc.z)) / (var_b9f0e - (var_b9f0e * ColorGrading_Misc.z))));
                }
                else
                {
                    highp vec3 var_48621;
                    if ((var_830e7 > var_b9f0e) && var_710bf)
                    {
                        var_48621 = mix(ColorGrading_Contrast_Midtones.xyz, ColorGrading_Contrast_Highlights.xyz, vec3((var_830e7 - var_b9f0e) / ((var_b9f0e * ColorGrading_Misc.y) - var_b9f0e)));
                    }
                    else
                    {
                        var_48621 = ColorGrading_Contrast_Midtones.xyz;
                    }
                    var_704f5 = var_48621;
                }
                var_9b38c = var_704f5;
            }
            else
            {
                var_9b38c = vec3(1.0);
            }
            var_b69b3 = var_9b38c;
        }
        var_1cf7f = var_b69b3;
    }
    highp vec3 var_dca8e = vec3(ColorGrading_Misc.x * var_b9f0e);
    highp vec3 var_9ec15 = max(var_dca8e * pow(max(var_89b58, vec3(0.0)) / var_dca8e, var_1cf7f), vec3(0.0));
    bool var_399ef = ColorGrading_Saturation_Highlights.w != 0.0;
    bool var_25f33 = ColorGrading_Saturation_Shadows.w != 0.0;
    bool var_01349;
    if (var_399ef)
    {
        var_01349 = var_830e7 >= (var_b9f0e * ColorGrading_Misc.y);
    }
    else
    {
        var_01349 = var_399ef;
    }
    highp vec3 var_71176;
    if (var_01349)
    {
        var_71176 = ColorGrading_Saturation_Highlights.xyz;
    }
    else
    {
        bool var_f8b69;
        if (var_25f33)
        {
            var_f8b69 = var_830e7 <= (var_b9f0e * ColorGrading_Misc.z);
        }
        else
        {
            var_f8b69 = var_25f33;
        }
        highp vec3 var_b1f12;
        if (var_f8b69)
        {
            var_b1f12 = ColorGrading_Saturation_Shadows.xyz;
        }
        else
        {
            highp vec3 var_3ac35;
            if (ColorGrading_Saturation_Midtones.w != 0.0)
            {
                highp vec3 var_1abde;
                if ((var_830e7 < var_b9f0e) && var_25f33)
                {
                    var_1abde = mix(ColorGrading_Saturation_Shadows.xyz, ColorGrading_Saturation_Midtones.xyz, vec3((var_830e7 - (var_b9f0e * ColorGrading_Misc.z)) / (var_b9f0e - (var_b9f0e * ColorGrading_Misc.z))));
                }
                else
                {
                    highp vec3 var_99fe9;
                    if ((var_830e7 > var_b9f0e) && var_399ef)
                    {
                        var_99fe9 = mix(ColorGrading_Saturation_Midtones.xyz, ColorGrading_Saturation_Highlights.xyz, vec3((var_830e7 - var_b9f0e) / ((var_b9f0e * ColorGrading_Misc.y) - var_b9f0e)));
                    }
                    else
                    {
                        var_99fe9 = ColorGrading_Saturation_Midtones.xyz;
                    }
                    var_1abde = var_99fe9;
                }
                var_3ac35 = var_1abde;
            }
            else
            {
                var_3ac35 = vec3(1.0);
            }
            var_b1f12 = var_3ac35;
        }
        var_71176 = var_b1f12;
    }
    bool var_79dd7 = ColorGrading_Gain_Highlights.w != 0.0;
    bool var_a07bd = ColorGrading_Gain_Shadows.w != 0.0;
    bool var_12e11;
    if (var_79dd7)
    {
        var_12e11 = var_830e7 >= (var_b9f0e * ColorGrading_Misc.y);
    }
    else
    {
        var_12e11 = var_79dd7;
    }
    highp vec3 var_e1a95;
    if (var_12e11)
    {
        var_e1a95 = ColorGrading_Gain_Highlights.xyz;
    }
    else
    {
        bool var_430d4;
        if (var_a07bd)
        {
            var_430d4 = var_830e7 <= (var_b9f0e * ColorGrading_Misc.z);
        }
        else
        {
            var_430d4 = var_a07bd;
        }
        highp vec3 var_6f06c;
        if (var_430d4)
        {
            var_6f06c = ColorGrading_Gain_Shadows.xyz;
        }
        else
        {
            highp vec3 var_d516e;
            if (ColorGrading_Gain_Midtones.w != 0.0)
            {
                highp vec3 var_162e8;
                if ((var_830e7 < var_b9f0e) && var_a07bd)
                {
                    var_162e8 = mix(ColorGrading_Gain_Shadows.xyz, ColorGrading_Gain_Midtones.xyz, vec3((var_830e7 - (var_b9f0e * ColorGrading_Misc.z)) / (var_b9f0e - (var_b9f0e * ColorGrading_Misc.z))));
                }
                else
                {
                    highp vec3 var_15cd3;
                    if ((var_830e7 > var_b9f0e) && var_79dd7)
                    {
                        var_15cd3 = mix(ColorGrading_Gain_Midtones.xyz, ColorGrading_Gain_Highlights.xyz, vec3((var_830e7 - var_b9f0e) / ((var_b9f0e * ColorGrading_Misc.y) - var_b9f0e)));
                    }
                    else
                    {
                        var_15cd3 = ColorGrading_Gain_Midtones.xyz;
                    }
                    var_162e8 = var_15cd3;
                }
                var_d516e = var_162e8;
            }
            else
            {
                var_d516e = vec3(1.0);
            }
            var_6f06c = var_d516e;
        }
        var_e1a95 = var_6f06c;
    }
    bool var_77cce = ColorGrading_Offset_Highlights.w != 0.0;
    bool var_6c659 = ColorGrading_Offset_Shadows.w != 0.0;
    bool var_1e2a1;
    if (var_77cce)
    {
        var_1e2a1 = var_830e7 >= (var_b9f0e * ColorGrading_Misc.y);
    }
    else
    {
        var_1e2a1 = var_77cce;
    }
    highp vec3 var_3ee3f;
    if (var_1e2a1)
    {
        var_3ee3f = ColorGrading_Offset_Highlights.xyz;
    }
    else
    {
        bool var_f7a29;
        if (var_6c659)
        {
            var_f7a29 = var_830e7 <= (var_b9f0e * ColorGrading_Misc.z);
        }
        else
        {
            var_f7a29 = var_6c659;
        }
        highp vec3 var_7f804;
        if (var_f7a29)
        {
            var_7f804 = ColorGrading_Offset_Shadows.xyz;
        }
        else
        {
            highp vec3 var_740c9;
            if (ColorGrading_Offset_Midtones.w != 0.0)
            {
                highp vec3 var_0e80d;
                if ((var_830e7 < var_b9f0e) && var_6c659)
                {
                    var_0e80d = mix(ColorGrading_Offset_Shadows.xyz, ColorGrading_Offset_Midtones.xyz, vec3((var_830e7 - (var_b9f0e * ColorGrading_Misc.z)) / (var_b9f0e - (var_b9f0e * ColorGrading_Misc.z))));
                }
                else
                {
                    highp vec3 var_c972b;
                    if ((var_830e7 > var_b9f0e) && var_77cce)
                    {
                        var_c972b = mix(ColorGrading_Offset_Midtones.xyz, ColorGrading_Offset_Highlights.xyz, vec3((var_830e7 - var_b9f0e) / ((var_b9f0e * ColorGrading_Misc.y) - var_b9f0e)));
                    }
                    else
                    {
                        var_c972b = ColorGrading_Offset_Midtones.xyz;
                    }
                    var_0e80d = var_c972b;
                }
                var_740c9 = var_0e80d;
            }
            else
            {
                var_740c9 = vec3(0.0);
            }
            var_7f804 = var_740c9;
        }
        var_3ee3f = var_7f804;
    }
    highp vec3 var_bfb98 = max(max(max(mix(vec3(dot(var_9ec15, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), var_9ec15, var_71176), vec3(0.0)) * var_e1a95, vec3(0.0)) + (vec3(var_b9f0e) * var_3ee3f), vec3(0.0));
    highp float var_4a042;
    if (LuminanceMinMaxAndWhitePointAndMinWhitePoint.z < LuminanceMinMaxAndWhitePointAndMinWhitePoint.w)
    {
        var_4a042 = LuminanceMinMaxAndWhitePointAndMinWhitePoint.w;
    }
    else
    {
        var_4a042 = LuminanceMinMaxAndWhitePointAndMinWhitePoint.z;
    }
    highp float var_cc29b = (0.180000007152557373046875 / var_b9f0e) * var_482cd;
    highp vec3 var_1f38f = var_bfb98 * var_cc29b;
    highp vec3 var_97858;
    if (TonemapParams0.y >= 0.5)
    {
        highp float var_a6dfd = var_cc29b * var_4a042;
        int var_fde43 = int(TonemapParams0.x);
        highp float var_8a41a = var_a6dfd * var_a6dfd;
        highp vec3 var_f1975;
        if (var_fde43 == 1)
        {
            var_f1975 = (var_1f38f * (vec3(1.0) + (var_1f38f / vec3(var_8a41a)))) / (vec3(1.0) + var_1f38f);
        }
        else
        {
            highp vec3 var_3a319;
            if (var_fde43 == 2)
            {
                highp float var_78bd9 = dot(var_1f38f, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
                var_3a319 = var_1f38f * (((var_78bd9 * (1.0 + (var_78bd9 / var_8a41a))) / (1.0 + var_78bd9)) / var_78bd9);
            }
            else
            {
                highp vec3 var_b9221;
                if (var_fde43 == 3)
                {
                    highp vec3 var_8c311 = var_1f38f * 2.0;
                    highp vec3 var_cb3d4 = vec3(var_8a41a);
                    var_b9221 = ((((var_8c311 * ((var_8c311 * 0.1500000059604644775390625) + vec3(0.0500000007450580596923828125))) + vec3(0.0040000001899898052215576171875)) / ((var_8c311 * ((var_8c311 * 0.1500000059604644775390625) + vec3(0.5))) + vec3(0.060000002384185791015625))) - vec3(0.066666662693023681640625)) * (vec3(1.0) / ((((var_cb3d4 * ((var_cb3d4 * 0.1500000059604644775390625) + vec3(0.0500000007450580596923828125))) + vec3(0.0040000001899898052215576171875)) / ((var_cb3d4 * ((var_cb3d4 * 0.1500000059604644775390625) + vec3(0.5))) + vec3(0.060000002384185791015625))) - vec3(0.066666662693023681640625)));
                }
                else
                {
                    highp vec3 var_ab2cf;
                    if (var_fde43 == 4)
                    {
                        highp vec3 var_07287 = transpose(mat3(vec3(0.59719002246856689453125, 0.354579985141754150390625, 0.048229999840259552001953125), vec3(0.075999997556209564208984375, 0.908339977264404296875, 0.0156599991023540496826171875), vec3(0.0284000001847743988037109375, 0.13382999598979949951171875, 0.837769985198974609375))) * var_1f38f;
                        var_ab2cf = clamp(transpose(mat3(vec3(1.60475003719329833984375, -0.5310800075531005859375, -0.0736699998378753662109375), vec3(-0.10208000242710113525390625, 1.108129978179931640625, -0.00604999996721744537353515625), vec3(-0.00326999998651444911956787109375, -0.07276000082492828369140625, 1.0760200023651123046875))) * (((var_07287 * (var_07287 + vec3(0.02457859925925731658935546875))) - vec3(9.0537003416102379560470581054688e-05)) / ((var_07287 * ((var_07287 * 0.98372900485992431640625) + vec3(0.4329510033130645751953125))) + vec3(0.23808099329471588134765625))), vec3(0.0), vec3(1.0));
                    }
                    else
                    {
                        highp vec3 var_60265;
                        if (var_fde43 == 5)
                        {
                            highp vec3 var_29097 = var_1f38f;
                            highp float var_d00e4 = max(var_29097.x, max(var_29097.y, var_29097.z));
                            highp float var_f9bf5 = pow(var_d00e4, GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk.x);
                            highp float var_1a9cc = var_f9bf5 / ((GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk.y * var_f9bf5) + GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk.z);
                            var_60265 = pow(mix(pow(var_1f38f / vec3(var_d00e4), vec3(1.0 / GenericTonemapperCrosstalkParams.x)), vec3(1.0), vec3(pow(var_1a9cc, GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk.w))), vec3(GenericTonemapperCrosstalkParams.x)) * var_1a9cc;
                        }
                        else
                        {
                            var_60265 = var_1f38f / (vec3(1.0) + var_1f38f);
                        }
                        var_ab2cf = var_60265;
                    }
                    var_b9221 = var_ab2cf;
                }
                var_3a319 = var_b9221;
            }
            var_f1975 = var_3a319;
        }
        highp float var_94025 = dot(var_f1975, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
        bool var_e978a = ColorGrading_Gamma_Highlights.w != 0.0;
        bool var_5a844 = ColorGrading_Gamma_Shadows.w != 0.0;
        bool var_b6f77;
        if (var_e978a)
        {
            var_b6f77 = var_94025 >= (0.180000007152557373046875 * ColorGrading_Misc.y);
        }
        else
        {
            var_b6f77 = var_e978a;
        }
        highp vec3 var_6cd50;
        if (var_b6f77)
        {
            var_6cd50 = ColorGrading_Gamma_Highlights.xyz;
        }
        else
        {
            bool var_71ac5;
            if (var_5a844)
            {
                var_71ac5 = var_94025 <= (0.180000007152557373046875 * ColorGrading_Misc.z);
            }
            else
            {
                var_71ac5 = var_5a844;
            }
            highp vec3 var_8da2a;
            if (var_71ac5)
            {
                var_8da2a = ColorGrading_Gamma_Shadows.xyz;
            }
            else
            {
                highp vec3 var_d7ae5;
                if (ColorGrading_Gamma_Midtones.w != 0.0)
                {
                    highp vec3 var_98ab8;
                    if ((var_94025 < 0.180000007152557373046875) && var_5a844)
                    {
                        var_98ab8 = mix(ColorGrading_Gamma_Shadows.xyz, ColorGrading_Gamma_Midtones.xyz, vec3((var_94025 - (0.180000007152557373046875 * ColorGrading_Misc.z)) / (0.180000007152557373046875 - (0.180000007152557373046875 * ColorGrading_Misc.z))));
                    }
                    else
                    {
                        highp vec3 var_feb1b;
                        if ((var_94025 > 0.180000007152557373046875) && var_e978a)
                        {
                            var_feb1b = mix(ColorGrading_Gamma_Midtones.xyz, ColorGrading_Gamma_Highlights.xyz, vec3((var_94025 - 0.180000007152557373046875) / ((0.180000007152557373046875 * ColorGrading_Misc.y) - 0.180000007152557373046875)));
                        }
                        else
                        {
                            var_feb1b = ColorGrading_Gamma_Midtones.xyz;
                        }
                        var_98ab8 = var_feb1b;
                    }
                    var_d7ae5 = var_98ab8;
                }
                else
                {
                    var_d7ae5 = vec3(1.0);
                }
                var_8da2a = var_d7ae5;
            }
            var_6cd50 = var_8da2a;
        }
        var_97858 = pow(max(var_f1975, vec3(0.0)), vec3(1.0) / (var_6cd50 * ColorGrading_Gamma_PlayerUI.x));
    }
    else
    {
        highp float var_349d1 = dot(var_bfb98, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
        bool var_a33a7 = ColorGrading_Gamma_Highlights.w != 0.0;
        bool var_e8f26 = ColorGrading_Gamma_Shadows.w != 0.0;
        bool var_fe369;
        if (var_a33a7)
        {
            var_fe369 = var_349d1 >= (0.180000007152557373046875 * ColorGrading_Misc.y);
        }
        else
        {
            var_fe369 = var_a33a7;
        }
        highp vec3 var_debbb;
        if (var_fe369)
        {
            var_debbb = ColorGrading_Gamma_Highlights.xyz;
        }
        else
        {
            bool var_61510;
            if (var_e8f26)
            {
                var_61510 = var_349d1 <= (0.180000007152557373046875 * ColorGrading_Misc.z);
            }
            else
            {
                var_61510 = var_e8f26;
            }
            highp vec3 var_a72da;
            if (var_61510)
            {
                var_a72da = ColorGrading_Gamma_Shadows.xyz;
            }
            else
            {
                highp vec3 var_65dc1;
                if (ColorGrading_Gamma_Midtones.w != 0.0)
                {
                    highp vec3 var_9e026;
                    if ((var_349d1 < 0.180000007152557373046875) && var_e8f26)
                    {
                        var_9e026 = mix(ColorGrading_Gamma_Shadows.xyz, ColorGrading_Gamma_Midtones.xyz, vec3((var_349d1 - (0.180000007152557373046875 * ColorGrading_Misc.z)) / (0.180000007152557373046875 - (0.180000007152557373046875 * ColorGrading_Misc.z))));
                    }
                    else
                    {
                        highp vec3 var_0e667;
                        if ((var_349d1 > 0.180000007152557373046875) && var_a33a7)
                        {
                            var_0e667 = mix(ColorGrading_Gamma_Midtones.xyz, ColorGrading_Gamma_Highlights.xyz, vec3((var_349d1 - 0.180000007152557373046875) / ((0.180000007152557373046875 * ColorGrading_Misc.y) - 0.180000007152557373046875)));
                        }
                        else
                        {
                            var_0e667 = ColorGrading_Gamma_Midtones.xyz;
                        }
                        var_9e026 = var_0e667;
                    }
                    var_65dc1 = var_9e026;
                }
                else
                {
                    var_65dc1 = vec3(1.0);
                }
                var_a72da = var_65dc1;
            }
            var_debbb = var_a72da;
        }
        var_97858 = pow(max(var_bfb98, vec3(0.0)), vec3(1.0) / (var_debbb * ColorGrading_Gamma_PlayerUI.x));
    }
    highp vec3 var_b53eb = clamp(var_97858, vec3(0.0), vec3(1.0));
    highp vec3 var_d9d1b;
    if (RasterizedColorEnabled.x > 0.0)
    {
        highp vec4 var_3c414 = texture(s_RasterizedColor, v_texcoord0.xy);
        highp vec4 var_bfce0 = var_3c414;
        var_d9d1b = (var_b53eb * (1.0 - var_bfce0.w)) + var_3c414.xyz;
    }
    else
    {
        var_d9d1b = var_b53eb;
    }
    bgfx_FragColor = vec4(var_d9d1b, 1.0);
}
