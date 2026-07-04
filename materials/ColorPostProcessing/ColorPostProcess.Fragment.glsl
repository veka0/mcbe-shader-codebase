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
* - uniform vec4 ColorGrading_Gamma_Shadows;
* - uniform vec4 ColorGrading_Misc;
* - uniform vec4 ColorGrading_Misc2;
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
uniform highp vec4 ColorGrading_Gamma_Shadows;
uniform highp vec4 ColorGrading_Misc2;
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
void func_8e34f(inout highp vec3 arg_c3a8d, inout highp vec3 arg_95aa6, inout highp vec3 arg_2c425) {
    if (ColorGrading_Misc2.x != 0.0)
    {
        arg_c3a8d = pow(max(arg_95aa6, vec3(0.0)), vec3(1.0) / (arg_2c425 * ColorGrading_Misc.w));
        return;
    }
    else
    {
        highp vec3 loc_a7dcf = arg_95aa6;
        highp vec3 loc_f65c2 = arg_95aa6 * 12.9200000762939453125;
        highp vec3 loc_3a1d5 = (pow(abs(arg_95aa6), vec3(0.4166666567325592041015625)) * 1.05499994754791259765625) - vec3(0.054999999701976776123046875);
        highp float loc_e81ff;
        if (loc_a7dcf.x <= 0.003130800090730190277099609375)
        {
            loc_e81ff = loc_f65c2.x;
        }
        else
        {
            loc_e81ff = loc_3a1d5.x;
        }
        loc_a7dcf.x = loc_e81ff;
        highp float loc_007b0;
        if (loc_a7dcf.y <= 0.003130800090730190277099609375)
        {
            loc_007b0 = loc_f65c2.y;
        }
        else
        {
            loc_007b0 = loc_3a1d5.y;
        }
        loc_a7dcf.y = loc_007b0;
        highp float loc_fa4a6;
        if (loc_a7dcf.z <= 0.003130800090730190277099609375)
        {
            loc_fa4a6 = loc_f65c2.z;
        }
        else
        {
            loc_fa4a6 = loc_3a1d5.z;
        }
        loc_a7dcf.z = loc_fa4a6;
        arg_c3a8d = pow(loc_a7dcf, vec3(2.2000000476837158203125) / (arg_2c425 * ColorGrading_Misc.w));
        return;
    }
}
void main() {
    highp vec4 var_be1e6 = texture(s_ColorTexture, v_texcoord0.xy);
    highp vec3 var_f0fbb = var_be1e6.xyz;
    highp vec3 var_29e10;
    if (TonemapParams0.z > 0.0)
    {
        var_29e10 = var_f0fbb / vec3((0.180000007152557373046875 / texture(s_PreExposureLuminance, vec2(0.5)).x) + 9.9999997473787516355514526367188e-05);
    }
    else
    {
        var_29e10 = var_f0fbb;
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
    highp float var_830e7 = dot(var_29e10, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
    highp vec3 var_7fb11;
    if (ColorGrading_Temperature_Params.x != 0.0)
    {
        highp vec3 var_eaa8a = vec3(0.312720000743865966796875, 0.3290300071239471435546875, 1.0);
        highp vec3 var_545f1 = transpose(mat3(vec3(0.732800006866455078125, 0.4296000003814697265625, -0.1624000072479248046875), vec3(-0.703599989414215087890625, 1.6974999904632568359375, 0.006099999882280826568603515625), vec3(0.0030000000260770320892333984375, 0.013600000180304050445556640625, 0.98339998722076416015625))) * vec3((var_eaa8a.x * var_eaa8a.z) / var_eaa8a.y, var_eaa8a.z, (((1.0 - var_eaa8a.x) - var_eaa8a.y) * var_eaa8a.z) / var_eaa8a.y);
        highp vec2 var_05857 = vec2(((0.860117733478546142578125 + (0.00015411825734190642833709716796875 * ColorGrading_Temperature_Params.y)) + ((1.2864121856637211749330163002014e-07 * ColorGrading_Temperature_Params.y) * ColorGrading_Temperature_Params.y)) / ((1.0 + (0.0008424202096648514270782470703125 * ColorGrading_Temperature_Params.y)) + ((7.0814513719597016461193561553955e-07 * ColorGrading_Temperature_Params.y) * ColorGrading_Temperature_Params.y)), ((0.317398726940155029296875 + (4.2280626075807958841323852539062e-05 * ColorGrading_Temperature_Params.y)) + ((4.2048167614439080352894961833954e-08 * ColorGrading_Temperature_Params.y) * ColorGrading_Temperature_Params.y)) / ((1.0 - (2.8974181986995972692966461181641e-05 * ColorGrading_Temperature_Params.y)) + ((1.6145605741257895715534687042236e-07 * ColorGrading_Temperature_Params.y) * ColorGrading_Temperature_Params.y)));
        highp vec3 var_46514 = vec3(vec2(3.0 * var_05857.x, 2.0 * var_05857.y) / vec2(((2.0 * var_05857.x) - (8.0 * var_05857.y)) + 4.0), 1.0);
        highp vec3 var_25cb9 = transpose(mat3(vec3(0.732800006866455078125, 0.4296000003814697265625, -0.1624000072479248046875), vec3(-0.703599989414215087890625, 1.6974999904632568359375, 0.006099999882280826568603515625), vec3(0.0030000000260770320892333984375, 0.013600000180304050445556640625, 0.98339998722076416015625))) * vec3((var_46514.x * var_46514.z) / var_46514.y, var_46514.z, (((1.0 - var_46514.x) - var_46514.y) * var_46514.z) / var_46514.y);
        highp vec3 var_5eed8;
        if (int(ColorGrading_Temperature_Params.z) == 0)
        {
            var_5eed8 = var_545f1 / var_25cb9;
        }
        else
        {
            var_5eed8 = var_25cb9 / var_545f1;
        }
        highp vec3 var_eb5d1 = var_5eed8;
        var_7fb11 = (transpose(mat3(vec3(2.8589999675750732421875, -1.6289999485015869140625, -0.02500000037252902984619140625), vec3(-0.20999999344348907470703125, 1.15799999237060546875, 0.0), vec3(-0.0419999994337558746337890625, -0.1180000007152557373046875, 1.0690000057220458984375))) * (mat3(vec3(var_eb5d1.x, 0.0, 0.0), vec3(0.0, var_eb5d1.y, 0.0), vec3(0.0, 0.0, var_eb5d1.z)) * transpose(mat3(vec3(0.38999998569488525390625, 0.550000011920928955078125, 0.0089999996125698089599609375), vec3(0.071000002324581146240234375, 0.962999999523162841796875, 0.001000000047497451305389404296875), vec3(0.02300000004470348358154296875, 0.12800000607967376708984375, 0.93599998950958251953125))))) * var_29e10;
    }
    else
    {
        var_7fb11 = var_29e10;
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
    highp vec3 var_9ec15 = max(var_dca8e * pow(max(var_7fb11, vec3(0.0)) / var_dca8e, var_1cf7f), vec3(0.0));
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
    highp vec3 var_19d0d = max(max(max(mix(vec3(dot(var_9ec15, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875))), var_9ec15, var_71176), vec3(0.0)) * var_e1a95, vec3(0.0)) + (vec3(var_b9f0e) * var_3ee3f), vec3(0.0));
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
    highp vec3 var_fcf44 = var_19d0d * var_cc29b;
    highp vec3 var_95052;
    if (TonemapParams0.y >= 0.5)
    {
        highp float var_a6dfd = var_cc29b * var_4a042;
        highp float var_4069e = var_a6dfd * var_a6dfd;
        highp vec3 var_134d7;
        switch (int(TonemapParams0.x))
        {
            case 1:
            {
                highp vec3 var_30363 = (var_fcf44 * (vec3(1.0) + (var_fcf44 / vec3(var_4069e)))) / (vec3(1.0) + var_fcf44);
                highp float var_2f0f7 = dot(var_30363, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
                bool var_5dc78 = ColorGrading_Gamma_Highlights.w != 0.0;
                bool var_4ca72 = ColorGrading_Gamma_Shadows.w != 0.0;
                bool var_d2b2c;
                if (var_5dc78)
                {
                    var_d2b2c = var_2f0f7 >= (0.180000007152557373046875 * ColorGrading_Misc.y);
                }
                else
                {
                    var_d2b2c = var_5dc78;
                }
                highp vec3 var_cb6ea;
                if (var_d2b2c)
                {
                    var_cb6ea = ColorGrading_Gamma_Highlights.xyz;
                }
                else
                {
                    bool var_46096;
                    if (var_4ca72)
                    {
                        var_46096 = var_2f0f7 <= (0.180000007152557373046875 * ColorGrading_Misc.z);
                    }
                    else
                    {
                        var_46096 = var_4ca72;
                    }
                    highp vec3 var_264e3;
                    if (var_46096)
                    {
                        var_264e3 = ColorGrading_Gamma_Shadows.xyz;
                    }
                    else
                    {
                        highp vec3 var_fa7c6;
                        if (ColorGrading_Gamma_Midtones.w != 0.0)
                        {
                            highp vec3 var_38f77;
                            if ((var_2f0f7 < 0.180000007152557373046875) && var_4ca72)
                            {
                                var_38f77 = mix(ColorGrading_Gamma_Shadows.xyz, ColorGrading_Gamma_Midtones.xyz, vec3((var_2f0f7 - (0.180000007152557373046875 * ColorGrading_Misc.z)) / (0.180000007152557373046875 - (0.180000007152557373046875 * ColorGrading_Misc.z))));
                            }
                            else
                            {
                                highp vec3 var_23cda;
                                if ((var_2f0f7 > 0.180000007152557373046875) && var_5dc78)
                                {
                                    var_23cda = mix(ColorGrading_Gamma_Midtones.xyz, ColorGrading_Gamma_Highlights.xyz, vec3((var_2f0f7 - 0.180000007152557373046875) / ((0.180000007152557373046875 * ColorGrading_Misc.y) - 0.180000007152557373046875)));
                                }
                                else
                                {
                                    var_23cda = ColorGrading_Gamma_Midtones.xyz;
                                }
                                var_38f77 = var_23cda;
                            }
                            var_fa7c6 = var_38f77;
                        }
                        else
                        {
                            var_fa7c6 = vec3(2.2000000476837158203125);
                        }
                        var_264e3 = var_fa7c6;
                    }
                    var_cb6ea = var_264e3;
                }
                highp vec3 var_383e8;
                func_8e34f(var_383e8, var_30363, var_cb6ea);
                var_134d7 = var_383e8;
                break;
            }
            case 2:
            {
                highp float var_941e5 = dot(var_fcf44, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
                highp vec3 var_4cb26 = var_fcf44 * (((var_941e5 * (1.0 + (var_941e5 / var_4069e))) / (1.0 + var_941e5)) / var_941e5);
                highp float var_2687f = dot(var_4cb26, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
                bool var_48c28 = ColorGrading_Gamma_Highlights.w != 0.0;
                bool var_c6407 = ColorGrading_Gamma_Shadows.w != 0.0;
                bool var_3d585;
                if (var_48c28)
                {
                    var_3d585 = var_2687f >= (0.180000007152557373046875 * ColorGrading_Misc.y);
                }
                else
                {
                    var_3d585 = var_48c28;
                }
                highp vec3 var_8415a;
                if (var_3d585)
                {
                    var_8415a = ColorGrading_Gamma_Highlights.xyz;
                }
                else
                {
                    bool var_21403;
                    if (var_c6407)
                    {
                        var_21403 = var_2687f <= (0.180000007152557373046875 * ColorGrading_Misc.z);
                    }
                    else
                    {
                        var_21403 = var_c6407;
                    }
                    highp vec3 var_b1a85;
                    if (var_21403)
                    {
                        var_b1a85 = ColorGrading_Gamma_Shadows.xyz;
                    }
                    else
                    {
                        highp vec3 var_8a920;
                        if (ColorGrading_Gamma_Midtones.w != 0.0)
                        {
                            highp vec3 var_a81b8;
                            if ((var_2687f < 0.180000007152557373046875) && var_c6407)
                            {
                                var_a81b8 = mix(ColorGrading_Gamma_Shadows.xyz, ColorGrading_Gamma_Midtones.xyz, vec3((var_2687f - (0.180000007152557373046875 * ColorGrading_Misc.z)) / (0.180000007152557373046875 - (0.180000007152557373046875 * ColorGrading_Misc.z))));
                            }
                            else
                            {
                                highp vec3 var_27df8;
                                if ((var_2687f > 0.180000007152557373046875) && var_48c28)
                                {
                                    var_27df8 = mix(ColorGrading_Gamma_Midtones.xyz, ColorGrading_Gamma_Highlights.xyz, vec3((var_2687f - 0.180000007152557373046875) / ((0.180000007152557373046875 * ColorGrading_Misc.y) - 0.180000007152557373046875)));
                                }
                                else
                                {
                                    var_27df8 = ColorGrading_Gamma_Midtones.xyz;
                                }
                                var_a81b8 = var_27df8;
                            }
                            var_8a920 = var_a81b8;
                        }
                        else
                        {
                            var_8a920 = vec3(2.2000000476837158203125);
                        }
                        var_b1a85 = var_8a920;
                    }
                    var_8415a = var_b1a85;
                }
                highp vec3 var_ceb40;
                func_8e34f(var_ceb40, var_4cb26, var_8415a);
                var_134d7 = var_ceb40;
                break;
            }
            case 3:
            {
                highp vec3 var_7d4bb = var_fcf44 * 2.0;
                highp vec3 var_f240b = vec3(var_4069e);
                highp vec3 var_b2ca3 = ((((var_7d4bb * ((var_7d4bb * 0.1500000059604644775390625) + vec3(0.0500000007450580596923828125))) + vec3(0.0040000001899898052215576171875)) / ((var_7d4bb * ((var_7d4bb * 0.1500000059604644775390625) + vec3(0.5))) + vec3(0.060000002384185791015625))) - vec3(0.066666662693023681640625)) * (vec3(1.0) / ((((var_f240b * ((var_f240b * 0.1500000059604644775390625) + vec3(0.0500000007450580596923828125))) + vec3(0.0040000001899898052215576171875)) / ((var_f240b * ((var_f240b * 0.1500000059604644775390625) + vec3(0.5))) + vec3(0.060000002384185791015625))) - vec3(0.066666662693023681640625)));
                highp float var_bf995 = dot(var_b2ca3, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
                bool var_eb7d5 = ColorGrading_Gamma_Highlights.w != 0.0;
                bool var_08217 = ColorGrading_Gamma_Shadows.w != 0.0;
                bool var_f0dbb;
                if (var_eb7d5)
                {
                    var_f0dbb = var_bf995 >= (0.180000007152557373046875 * ColorGrading_Misc.y);
                }
                else
                {
                    var_f0dbb = var_eb7d5;
                }
                highp vec3 var_01f1e;
                if (var_f0dbb)
                {
                    var_01f1e = ColorGrading_Gamma_Highlights.xyz;
                }
                else
                {
                    bool var_ca7db;
                    if (var_08217)
                    {
                        var_ca7db = var_bf995 <= (0.180000007152557373046875 * ColorGrading_Misc.z);
                    }
                    else
                    {
                        var_ca7db = var_08217;
                    }
                    highp vec3 var_1ad24;
                    if (var_ca7db)
                    {
                        var_1ad24 = ColorGrading_Gamma_Shadows.xyz;
                    }
                    else
                    {
                        highp vec3 var_eca21;
                        if (ColorGrading_Gamma_Midtones.w != 0.0)
                        {
                            highp vec3 var_8bef9;
                            if ((var_bf995 < 0.180000007152557373046875) && var_08217)
                            {
                                var_8bef9 = mix(ColorGrading_Gamma_Shadows.xyz, ColorGrading_Gamma_Midtones.xyz, vec3((var_bf995 - (0.180000007152557373046875 * ColorGrading_Misc.z)) / (0.180000007152557373046875 - (0.180000007152557373046875 * ColorGrading_Misc.z))));
                            }
                            else
                            {
                                highp vec3 var_34b3a;
                                if ((var_bf995 > 0.180000007152557373046875) && var_eb7d5)
                                {
                                    var_34b3a = mix(ColorGrading_Gamma_Midtones.xyz, ColorGrading_Gamma_Highlights.xyz, vec3((var_bf995 - 0.180000007152557373046875) / ((0.180000007152557373046875 * ColorGrading_Misc.y) - 0.180000007152557373046875)));
                                }
                                else
                                {
                                    var_34b3a = ColorGrading_Gamma_Midtones.xyz;
                                }
                                var_8bef9 = var_34b3a;
                            }
                            var_eca21 = var_8bef9;
                        }
                        else
                        {
                            var_eca21 = vec3(2.2000000476837158203125);
                        }
                        var_1ad24 = var_eca21;
                    }
                    var_01f1e = var_1ad24;
                }
                highp vec3 var_f6e03;
                func_8e34f(var_f6e03, var_b2ca3, var_01f1e);
                var_134d7 = var_f6e03;
                break;
            }
            case 4:
            {
                highp vec3 var_cf5aa = transpose(mat3(vec3(0.59719002246856689453125, 0.354579985141754150390625, 0.048229999840259552001953125), vec3(0.075999997556209564208984375, 0.908339977264404296875, 0.0156599991023540496826171875), vec3(0.0284000001847743988037109375, 0.13382999598979949951171875, 0.837769985198974609375))) * var_fcf44;
                highp vec3 var_7fe3d = clamp(transpose(mat3(vec3(1.60475003719329833984375, -0.5310800075531005859375, -0.0736699998378753662109375), vec3(-0.10208000242710113525390625, 1.108129978179931640625, -0.00604999996721744537353515625), vec3(-0.00326999998651444911956787109375, -0.07276000082492828369140625, 1.0760200023651123046875))) * (((var_cf5aa * (var_cf5aa + vec3(0.02457859925925731658935546875))) - vec3(9.0537003416102379560470581054688e-05)) / ((var_cf5aa * ((var_cf5aa * 0.98372900485992431640625) + vec3(0.4329510033130645751953125))) + vec3(0.23808099329471588134765625))), vec3(0.0), vec3(1.0));
                highp float var_806df = dot(var_7fe3d, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
                bool var_9283d = ColorGrading_Gamma_Highlights.w != 0.0;
                bool var_bc1a9 = ColorGrading_Gamma_Shadows.w != 0.0;
                bool var_d0491;
                if (var_9283d)
                {
                    var_d0491 = var_806df >= (0.180000007152557373046875 * ColorGrading_Misc.y);
                }
                else
                {
                    var_d0491 = var_9283d;
                }
                highp vec3 var_4e8f9;
                if (var_d0491)
                {
                    var_4e8f9 = ColorGrading_Gamma_Highlights.xyz;
                }
                else
                {
                    bool var_e1178;
                    if (var_bc1a9)
                    {
                        var_e1178 = var_806df <= (0.180000007152557373046875 * ColorGrading_Misc.z);
                    }
                    else
                    {
                        var_e1178 = var_bc1a9;
                    }
                    highp vec3 var_76e6b;
                    if (var_e1178)
                    {
                        var_76e6b = ColorGrading_Gamma_Shadows.xyz;
                    }
                    else
                    {
                        highp vec3 var_9a198;
                        if (ColorGrading_Gamma_Midtones.w != 0.0)
                        {
                            highp vec3 var_3ac48;
                            if ((var_806df < 0.180000007152557373046875) && var_bc1a9)
                            {
                                var_3ac48 = mix(ColorGrading_Gamma_Shadows.xyz, ColorGrading_Gamma_Midtones.xyz, vec3((var_806df - (0.180000007152557373046875 * ColorGrading_Misc.z)) / (0.180000007152557373046875 - (0.180000007152557373046875 * ColorGrading_Misc.z))));
                            }
                            else
                            {
                                highp vec3 var_8e789;
                                if ((var_806df > 0.180000007152557373046875) && var_9283d)
                                {
                                    var_8e789 = mix(ColorGrading_Gamma_Midtones.xyz, ColorGrading_Gamma_Highlights.xyz, vec3((var_806df - 0.180000007152557373046875) / ((0.180000007152557373046875 * ColorGrading_Misc.y) - 0.180000007152557373046875)));
                                }
                                else
                                {
                                    var_8e789 = ColorGrading_Gamma_Midtones.xyz;
                                }
                                var_3ac48 = var_8e789;
                            }
                            var_9a198 = var_3ac48;
                        }
                        else
                        {
                            var_9a198 = vec3(2.2000000476837158203125);
                        }
                        var_76e6b = var_9a198;
                    }
                    var_4e8f9 = var_76e6b;
                }
                highp vec3 var_67c6d;
                func_8e34f(var_67c6d, var_7fe3d, var_4e8f9);
                var_134d7 = var_67c6d;
                break;
            }
            case 5:
            {
                highp vec3 var_b7865 = var_fcf44;
                highp float var_9614c = max(var_b7865.x, max(var_b7865.y, var_b7865.z));
                highp float var_1d527 = pow(var_9614c, GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk.x);
                highp float var_00ac2 = var_1d527 / ((GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk.y * var_1d527) + GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk.z);
                highp vec3 var_bd0ef = pow(mix(pow(var_fcf44 / vec3(var_9614c), vec3(1.0 / GenericTonemapperCrosstalkParams.x)), vec3(1.0), vec3(pow(var_00ac2, GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk.w))), vec3(GenericTonemapperCrosstalkParams.x)) * var_00ac2;
                highp float var_b89cc = dot(var_bd0ef, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
                bool var_2961f = ColorGrading_Gamma_Highlights.w != 0.0;
                bool var_a2459 = ColorGrading_Gamma_Shadows.w != 0.0;
                bool var_df4cf;
                if (var_2961f)
                {
                    var_df4cf = var_b89cc >= (0.180000007152557373046875 * ColorGrading_Misc.y);
                }
                else
                {
                    var_df4cf = var_2961f;
                }
                highp vec3 var_e2108;
                if (var_df4cf)
                {
                    var_e2108 = ColorGrading_Gamma_Highlights.xyz;
                }
                else
                {
                    bool var_5c349;
                    if (var_a2459)
                    {
                        var_5c349 = var_b89cc <= (0.180000007152557373046875 * ColorGrading_Misc.z);
                    }
                    else
                    {
                        var_5c349 = var_a2459;
                    }
                    highp vec3 var_41004;
                    if (var_5c349)
                    {
                        var_41004 = ColorGrading_Gamma_Shadows.xyz;
                    }
                    else
                    {
                        highp vec3 var_ce8ed;
                        if (ColorGrading_Gamma_Midtones.w != 0.0)
                        {
                            highp vec3 var_f8935;
                            if ((var_b89cc < 0.180000007152557373046875) && var_a2459)
                            {
                                var_f8935 = mix(ColorGrading_Gamma_Shadows.xyz, ColorGrading_Gamma_Midtones.xyz, vec3((var_b89cc - (0.180000007152557373046875 * ColorGrading_Misc.z)) / (0.180000007152557373046875 - (0.180000007152557373046875 * ColorGrading_Misc.z))));
                            }
                            else
                            {
                                highp vec3 var_a1bc4;
                                if ((var_b89cc > 0.180000007152557373046875) && var_2961f)
                                {
                                    var_a1bc4 = mix(ColorGrading_Gamma_Midtones.xyz, ColorGrading_Gamma_Highlights.xyz, vec3((var_b89cc - 0.180000007152557373046875) / ((0.180000007152557373046875 * ColorGrading_Misc.y) - 0.180000007152557373046875)));
                                }
                                else
                                {
                                    var_a1bc4 = ColorGrading_Gamma_Midtones.xyz;
                                }
                                var_f8935 = var_a1bc4;
                            }
                            var_ce8ed = var_f8935;
                        }
                        else
                        {
                            var_ce8ed = vec3(2.2000000476837158203125);
                        }
                        var_41004 = var_ce8ed;
                    }
                    var_e2108 = var_41004;
                }
                highp vec3 var_ab056;
                func_8e34f(var_ab056, var_bd0ef, var_e2108);
                var_134d7 = var_ab056;
                break;
            }
            default:
            {
                highp vec3 var_17d37 = var_fcf44 / (vec3(1.0) + var_fcf44);
                highp float var_2c3f0 = dot(var_17d37, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
                bool var_6c855 = ColorGrading_Gamma_Highlights.w != 0.0;
                bool var_e4d2f = ColorGrading_Gamma_Shadows.w != 0.0;
                bool var_d9fe2;
                if (var_6c855)
                {
                    var_d9fe2 = var_2c3f0 >= (0.180000007152557373046875 * ColorGrading_Misc.y);
                }
                else
                {
                    var_d9fe2 = var_6c855;
                }
                highp vec3 var_275ec;
                if (var_d9fe2)
                {
                    var_275ec = ColorGrading_Gamma_Highlights.xyz;
                }
                else
                {
                    bool var_09295;
                    if (var_e4d2f)
                    {
                        var_09295 = var_2c3f0 <= (0.180000007152557373046875 * ColorGrading_Misc.z);
                    }
                    else
                    {
                        var_09295 = var_e4d2f;
                    }
                    highp vec3 var_40cb6;
                    if (var_09295)
                    {
                        var_40cb6 = ColorGrading_Gamma_Shadows.xyz;
                    }
                    else
                    {
                        highp vec3 var_387a9;
                        if (ColorGrading_Gamma_Midtones.w != 0.0)
                        {
                            highp vec3 var_3c56c;
                            if ((var_2c3f0 < 0.180000007152557373046875) && var_e4d2f)
                            {
                                var_3c56c = mix(ColorGrading_Gamma_Shadows.xyz, ColorGrading_Gamma_Midtones.xyz, vec3((var_2c3f0 - (0.180000007152557373046875 * ColorGrading_Misc.z)) / (0.180000007152557373046875 - (0.180000007152557373046875 * ColorGrading_Misc.z))));
                            }
                            else
                            {
                                highp vec3 var_af891;
                                if ((var_2c3f0 > 0.180000007152557373046875) && var_6c855)
                                {
                                    var_af891 = mix(ColorGrading_Gamma_Midtones.xyz, ColorGrading_Gamma_Highlights.xyz, vec3((var_2c3f0 - 0.180000007152557373046875) / ((0.180000007152557373046875 * ColorGrading_Misc.y) - 0.180000007152557373046875)));
                                }
                                else
                                {
                                    var_af891 = ColorGrading_Gamma_Midtones.xyz;
                                }
                                var_3c56c = var_af891;
                            }
                            var_387a9 = var_3c56c;
                        }
                        else
                        {
                            var_387a9 = vec3(2.2000000476837158203125);
                        }
                        var_40cb6 = var_387a9;
                    }
                    var_275ec = var_40cb6;
                }
                highp vec3 var_f3498;
                func_8e34f(var_f3498, var_17d37, var_275ec);
                var_134d7 = var_f3498;
                break;
            }
        }
        var_95052 = var_134d7;
    }
    else
    {
        highp float var_94025 = dot(var_19d0d, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
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
        highp vec3 var_2da86;
        if (var_b6f77)
        {
            var_2da86 = ColorGrading_Gamma_Highlights.xyz;
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
                highp vec3 var_bea16;
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
                    var_bea16 = var_98ab8;
                }
                else
                {
                    var_bea16 = vec3(2.2000000476837158203125);
                }
                var_8da2a = var_bea16;
            }
            var_2da86 = var_8da2a;
        }
        highp vec3 var_c1949;
        func_8e34f(var_c1949, var_19d0d, var_2da86);
        var_95052 = var_c1949;
    }
    highp vec3 var_b53eb = clamp(var_95052, vec3(0.0), vec3(1.0));
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
