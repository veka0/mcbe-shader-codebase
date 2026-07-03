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
* - uniform vec4 ColorGrading_Offset_Highlights;
* - uniform vec4 ColorGrading_Offset_Midtones;
* - uniform vec4 ColorGrading_Offset_Shadows;
* - uniform vec4 ColorGrading_Saturation_Highlights;
* - uniform vec4 ColorGrading_Saturation_Midtones;
* - uniform vec4 ColorGrading_Saturation_Shadows;
* - uniform vec4 ExposureCompensation;
* - uniform vec4 GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk;
* - uniform vec4 GenericTonemapperCrosstalkParams;
* - uniform vec4 LuminanceMinMaxAndWhitePointAndMinWhitePoint;
* - uniform vec4 OutputTextureMaxValue;
* - uniform vec4 RasterizedColorEnabled;
* - uniform vec4 RenderMode;
* - uniform vec4 ScreenSize;
* - uniform vec4 TonemapParams0;
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
uniform highp vec4 ColorGrading_Offset_Highlights;
uniform highp vec4 ColorGrading_Offset_Midtones;
uniform highp vec4 ColorGrading_Offset_Shadows;
uniform highp vec4 ColorGrading_Saturation_Highlights;
uniform highp vec4 ColorGrading_Saturation_Midtones;
uniform highp vec4 ColorGrading_Saturation_Shadows;
uniform highp vec4 ExposureCompensation;
uniform highp vec4 GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk;
uniform highp vec4 LuminanceMinMaxAndWhitePointAndMinWhitePoint;
uniform highp vec4 OutputTextureMaxValue;
uniform highp vec4 RasterizedColorEnabled;
uniform highp vec4 TonemapParams0;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_97017 = texture(s_ColorTexture, v_texcoord0);
    highp vec3 var_60b24 = var_97017.xyz;
    highp vec3 var_559db;
    if (TonemapParams0.z > 0.0)
    {
        var_559db = var_60b24 / vec3(0.180000007152557373046875 / texture(s_PreExposureLuminance, vec2(0.5)).x);
    }
    else
    {
        var_559db = var_60b24;
    }
    highp vec3 var_8c2ae;
    if (TonemapParams0.y <= 0.5)
    {
        var_8c2ae = pow(max(var_559db, vec3(0.0)), vec3(0.4545454680919647216796875));
    }
    else
    {
        highp vec4 var_1c0c1 = texture(s_AverageLuminance, vec2(0.5));
        highp float var_89116 = clamp(var_1c0c1.x, LuminanceMinMaxAndWhitePointAndMinWhitePoint.x, LuminanceMinMaxAndWhitePointAndMinWhitePoint.y);
        int var_e2611 = int(ExposureCompensation.x);
        highp float var_4627d;
        if ((var_e2611 > 0) && (var_e2611 < 2))
        {
            var_4627d = 1.0299999713897705078125 - (2.0 / ((0.4342944920063018798828125 * log(var_89116 + 1.0)) + 2.0));
        }
        else
        {
            highp float var_2b74e;
            if (var_e2611 > 1)
            {
                highp float var_b3c5b;
                if (LuminanceMinMaxAndWhitePointAndMinWhitePoint.x == LuminanceMinMaxAndWhitePointAndMinWhitePoint.y)
                {
                    var_b3c5b = 0.5;
                }
                else
                {
                    var_b3c5b = ((log2(var_89116) + 3.0) - (log2(LuminanceMinMaxAndWhitePointAndMinWhitePoint.x) + 3.0)) / ((log2(LuminanceMinMaxAndWhitePointAndMinWhitePoint.y) + 3.0) - (log2(LuminanceMinMaxAndWhitePointAndMinWhitePoint.x) + 3.0));
                }
                var_2b74e = texture(s_CustomExposureCompensation, vec2(var_b3c5b, 0.5)).x;
            }
            else
            {
                var_2b74e = ExposureCompensation.y;
            }
            var_4627d = var_2b74e;
        }
        highp float var_26db5 = dot(var_559db, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
        bool var_04a39 = ColorGrading_Contrast_Midtones.w > 0.0;
        bool var_609b6;
        if (var_04a39)
        {
            var_609b6 = var_26db5 >= (var_89116 * ColorGrading_Saturation_Highlights.w);
        }
        else
        {
            var_609b6 = var_04a39;
        }
        highp vec3 var_266d0;
        if (var_609b6)
        {
            var_266d0 = ColorGrading_Contrast_Highlights.xyz;
        }
        else
        {
            bool var_de6c7 = ColorGrading_Contrast_Shadows.w > 0.0;
            bool var_bfa83;
            if (var_de6c7)
            {
                var_bfa83 = var_26db5 <= (var_89116 * ColorGrading_Saturation_Midtones.w);
            }
            else
            {
                var_bfa83 = var_de6c7;
            }
            highp vec3 var_a0b12;
            if (var_bfa83)
            {
                var_a0b12 = ColorGrading_Contrast_Shadows.xyz;
            }
            else
            {
                bool var_14b11 = var_26db5 < var_89116;
                bool var_76228;
                if (var_14b11)
                {
                    var_76228 = ColorGrading_Contrast_Shadows.w > 0.0;
                }
                else
                {
                    var_76228 = var_14b11;
                }
                highp vec3 var_230a3;
                if (var_76228)
                {
                    var_230a3 = mix(ColorGrading_Contrast_Shadows.xyz, ColorGrading_Contrast_Midtones.xyz, vec3((var_26db5 - (var_89116 * ColorGrading_Saturation_Midtones.w)) / (var_89116 - (var_89116 * ColorGrading_Saturation_Midtones.w))));
                }
                else
                {
                    bool var_65694 = var_26db5 > var_89116;
                    bool var_ea43a;
                    if (var_65694)
                    {
                        var_ea43a = ColorGrading_Contrast_Midtones.w > 0.0;
                    }
                    else
                    {
                        var_ea43a = var_65694;
                    }
                    highp vec3 var_e1d5d;
                    if (var_ea43a)
                    {
                        var_e1d5d = mix(ColorGrading_Contrast_Midtones.xyz, ColorGrading_Contrast_Highlights.xyz, vec3((var_26db5 - var_89116) / ((var_89116 * ColorGrading_Saturation_Highlights.w) - var_89116)));
                    }
                    else
                    {
                        var_e1d5d = ColorGrading_Contrast_Midtones.xyz;
                    }
                    var_230a3 = var_e1d5d;
                }
                var_a0b12 = var_230a3;
            }
            var_266d0 = var_a0b12;
        }
        highp vec3 var_82d76 = vec3(ColorGrading_Contrast_Highlights.w * var_89116);
        highp vec3 var_038f6 = clamp(var_82d76 * pow(max(var_559db, vec3(0.0)) / var_82d76, var_266d0), vec3(0.0), vec3(OutputTextureMaxValue.x));
        bool var_a1a03 = ColorGrading_Contrast_Midtones.w > 0.0;
        bool var_988cd;
        if (var_a1a03)
        {
            var_988cd = var_26db5 >= (var_89116 * ColorGrading_Saturation_Highlights.w);
        }
        else
        {
            var_988cd = var_a1a03;
        }
        highp vec3 var_52280;
        if (var_988cd)
        {
            var_52280 = ColorGrading_Saturation_Highlights.xyz;
        }
        else
        {
            bool var_fb801 = ColorGrading_Contrast_Shadows.w > 0.0;
            bool var_05af4;
            if (var_fb801)
            {
                var_05af4 = var_26db5 <= (var_89116 * ColorGrading_Saturation_Midtones.w);
            }
            else
            {
                var_05af4 = var_fb801;
            }
            highp vec3 var_1b584;
            if (var_05af4)
            {
                var_1b584 = ColorGrading_Saturation_Shadows.xyz;
            }
            else
            {
                bool var_906ef = var_26db5 < var_89116;
                bool var_3f79e;
                if (var_906ef)
                {
                    var_3f79e = ColorGrading_Contrast_Shadows.w > 0.0;
                }
                else
                {
                    var_3f79e = var_906ef;
                }
                highp vec3 var_ec4f8;
                if (var_3f79e)
                {
                    var_ec4f8 = mix(ColorGrading_Saturation_Shadows.xyz, ColorGrading_Saturation_Midtones.xyz, vec3((var_26db5 - (var_89116 * ColorGrading_Saturation_Midtones.w)) / (var_89116 - (var_89116 * ColorGrading_Saturation_Midtones.w))));
                }
                else
                {
                    bool var_b729d = var_26db5 > var_89116;
                    bool var_1c503;
                    if (var_b729d)
                    {
                        var_1c503 = ColorGrading_Contrast_Midtones.w > 0.0;
                    }
                    else
                    {
                        var_1c503 = var_b729d;
                    }
                    highp vec3 var_cf542;
                    if (var_1c503)
                    {
                        var_cf542 = mix(ColorGrading_Saturation_Midtones.xyz, ColorGrading_Saturation_Highlights.xyz, vec3((var_26db5 - var_89116) / ((var_89116 * ColorGrading_Saturation_Highlights.w) - var_89116)));
                    }
                    else
                    {
                        var_cf542 = ColorGrading_Saturation_Midtones.xyz;
                    }
                    var_ec4f8 = var_cf542;
                }
                var_1b584 = var_ec4f8;
            }
            var_52280 = var_1b584;
        }
        highp vec3 var_5e976 = var_038f6;
        highp vec3 var_738d6 = var_52280;
        highp float var_e26c4 = dot(var_038f6, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
        highp float var_cf4f4;
        if (var_5e976.x < var_e26c4)
        {
            var_cf4f4 = 1.0 + (var_5e976.x / (var_e26c4 - var_5e976.x));
        }
        else
        {
            highp float var_73c8e;
            if (var_5e976.x > var_e26c4)
            {
                var_73c8e = 1.0 + ((OutputTextureMaxValue.x - var_5e976.x) / (var_5e976.x - var_e26c4));
            }
            else
            {
                var_73c8e = var_738d6.x;
            }
            var_cf4f4 = var_73c8e;
        }
        highp float var_79e1a;
        if (var_5e976.y < var_e26c4)
        {
            var_79e1a = 1.0 + (var_5e976.y / (var_e26c4 - var_5e976.y));
        }
        else
        {
            highp float var_781b1;
            if (var_5e976.y > var_e26c4)
            {
                var_781b1 = 1.0 + ((OutputTextureMaxValue.x - var_5e976.y) / (var_5e976.y - var_e26c4));
            }
            else
            {
                var_781b1 = var_738d6.y;
            }
            var_79e1a = var_781b1;
        }
        highp float var_90267;
        if (var_5e976.z < var_e26c4)
        {
            var_90267 = 1.0 + (var_5e976.z / (var_e26c4 - var_5e976.z));
        }
        else
        {
            highp float var_d4269;
            if (var_5e976.z > var_e26c4)
            {
                var_d4269 = 1.0 + ((OutputTextureMaxValue.x - var_5e976.z) / (var_5e976.z - var_e26c4));
            }
            else
            {
                var_d4269 = var_738d6.z;
            }
            var_90267 = var_d4269;
        }
        highp vec3 var_e6752 = vec3(var_cf4f4, var_79e1a, var_90267);
        if (var_738d6.x > var_e6752.x)
        {
            var_738d6 *= (var_e6752.x / var_738d6.x);
        }
        if (var_738d6.y > var_e6752.y)
        {
            var_738d6 *= (var_e6752.y / var_738d6.y);
        }
        if (var_738d6.z > var_e6752.z)
        {
            var_738d6 *= (var_e6752.z / var_738d6.z);
        }
        bool var_1b16c = ColorGrading_Contrast_Midtones.w > 0.0;
        bool var_ef027;
        if (var_1b16c)
        {
            var_ef027 = var_26db5 >= (var_89116 * ColorGrading_Saturation_Highlights.w);
        }
        else
        {
            var_ef027 = var_1b16c;
        }
        highp vec3 var_45fb0;
        if (var_ef027)
        {
            var_45fb0 = ColorGrading_Gain_Highlights.xyz;
        }
        else
        {
            bool var_08d61 = ColorGrading_Contrast_Shadows.w > 0.0;
            bool var_919e2;
            if (var_08d61)
            {
                var_919e2 = var_26db5 <= (var_89116 * ColorGrading_Saturation_Midtones.w);
            }
            else
            {
                var_919e2 = var_08d61;
            }
            highp vec3 var_a2cbb;
            if (var_919e2)
            {
                var_a2cbb = ColorGrading_Gain_Shadows.xyz;
            }
            else
            {
                bool var_04960 = var_26db5 < var_89116;
                bool var_a1427;
                if (var_04960)
                {
                    var_a1427 = ColorGrading_Contrast_Shadows.w > 0.0;
                }
                else
                {
                    var_a1427 = var_04960;
                }
                highp vec3 var_ce923;
                if (var_a1427)
                {
                    var_ce923 = mix(ColorGrading_Gain_Shadows.xyz, ColorGrading_Gain_Midtones.xyz, vec3((var_26db5 - (var_89116 * ColorGrading_Saturation_Midtones.w)) / (var_89116 - (var_89116 * ColorGrading_Saturation_Midtones.w))));
                }
                else
                {
                    bool var_a33af = var_26db5 > var_89116;
                    bool var_ab640;
                    if (var_a33af)
                    {
                        var_ab640 = ColorGrading_Contrast_Midtones.w > 0.0;
                    }
                    else
                    {
                        var_ab640 = var_a33af;
                    }
                    highp vec3 var_199ff;
                    if (var_ab640)
                    {
                        var_199ff = mix(ColorGrading_Gain_Midtones.xyz, ColorGrading_Gain_Highlights.xyz, vec3((var_26db5 - var_89116) / ((var_89116 * ColorGrading_Saturation_Highlights.w) - var_89116)));
                    }
                    else
                    {
                        var_199ff = ColorGrading_Gain_Midtones.xyz;
                    }
                    var_ce923 = var_199ff;
                }
                var_a2cbb = var_ce923;
            }
            var_45fb0 = var_a2cbb;
        }
        bool var_42531 = ColorGrading_Contrast_Midtones.w > 0.0;
        bool var_eb3fc;
        if (var_42531)
        {
            var_eb3fc = var_26db5 >= (var_89116 * ColorGrading_Saturation_Highlights.w);
        }
        else
        {
            var_eb3fc = var_42531;
        }
        highp vec3 var_6484d;
        if (var_eb3fc)
        {
            var_6484d = ColorGrading_Offset_Highlights.xyz;
        }
        else
        {
            bool var_9b30f = ColorGrading_Contrast_Shadows.w > 0.0;
            bool var_7449b;
            if (var_9b30f)
            {
                var_7449b = var_26db5 <= (var_89116 * ColorGrading_Saturation_Midtones.w);
            }
            else
            {
                var_7449b = var_9b30f;
            }
            highp vec3 var_c31a9;
            if (var_7449b)
            {
                var_c31a9 = ColorGrading_Offset_Shadows.xyz;
            }
            else
            {
                bool var_201d7 = var_26db5 < var_89116;
                bool var_7b8f2;
                if (var_201d7)
                {
                    var_7b8f2 = ColorGrading_Contrast_Shadows.w > 0.0;
                }
                else
                {
                    var_7b8f2 = var_201d7;
                }
                highp vec3 var_cc391;
                if (var_7b8f2)
                {
                    var_cc391 = mix(ColorGrading_Offset_Shadows.xyz, ColorGrading_Offset_Midtones.xyz, vec3((var_26db5 - (var_89116 * ColorGrading_Saturation_Midtones.w)) / (var_89116 - (var_89116 * ColorGrading_Saturation_Midtones.w))));
                }
                else
                {
                    bool var_7ec38 = var_26db5 > var_89116;
                    bool var_34e14;
                    if (var_7ec38)
                    {
                        var_34e14 = ColorGrading_Contrast_Midtones.w > 0.0;
                    }
                    else
                    {
                        var_34e14 = var_7ec38;
                    }
                    highp vec3 var_c5eab;
                    if (var_34e14)
                    {
                        var_c5eab = mix(ColorGrading_Offset_Midtones.xyz, ColorGrading_Offset_Highlights.xyz, vec3((var_26db5 - var_89116) / ((var_89116 * ColorGrading_Saturation_Highlights.w) - var_89116)));
                    }
                    else
                    {
                        var_c5eab = ColorGrading_Offset_Midtones.xyz;
                    }
                    var_cc391 = var_c5eab;
                }
                var_c31a9 = var_cc391;
            }
            var_6484d = var_c31a9;
        }
        highp float var_37ec1;
        if (LuminanceMinMaxAndWhitePointAndMinWhitePoint.z < LuminanceMinMaxAndWhitePointAndMinWhitePoint.w)
        {
            var_37ec1 = LuminanceMinMaxAndWhitePointAndMinWhitePoint.w;
        }
        else
        {
            var_37ec1 = LuminanceMinMaxAndWhitePointAndMinWhitePoint.z;
        }
        int var_fde43 = int(TonemapParams0.x);
        highp float var_f0228 = (0.180000007152557373046875 / var_89116) * var_4627d;
        highp vec3 var_6003d = clamp(clamp(mix(vec3(var_e26c4), var_038f6, var_738d6) * var_45fb0, vec3(0.0), vec3(OutputTextureMaxValue.x)) + (vec3(var_89116) * var_6484d), vec3(0.0), vec3(OutputTextureMaxValue.x)) * var_f0228;
        highp float var_a6dfd = var_f0228 * var_37ec1;
        highp float var_8a41a = var_a6dfd * var_a6dfd;
        highp vec3 var_f1975;
        if (var_fde43 == 1)
        {
            var_f1975 = (var_6003d * (vec3(1.0) + (var_6003d / vec3(var_8a41a)))) / (vec3(1.0) + var_6003d);
        }
        else
        {
            highp vec3 var_3a319;
            if (var_fde43 == 2)
            {
                highp float var_78bd9 = dot(var_6003d, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
                var_3a319 = var_6003d * (((var_78bd9 * (1.0 + (var_78bd9 / var_8a41a))) / (1.0 + var_78bd9)) / var_78bd9);
            }
            else
            {
                highp vec3 var_b9221;
                if (var_fde43 == 3)
                {
                    highp vec3 var_8c311 = var_6003d * 2.0;
                    highp vec3 var_cb3d4 = vec3(var_8a41a);
                    var_b9221 = ((((var_8c311 * ((var_8c311 * 0.1500000059604644775390625) + vec3(0.0500000007450580596923828125))) + vec3(0.0040000001899898052215576171875)) / ((var_8c311 * ((var_8c311 * 0.1500000059604644775390625) + vec3(0.5))) + vec3(0.060000002384185791015625))) - vec3(0.066666662693023681640625)) * (vec3(1.0) / ((((var_cb3d4 * ((var_cb3d4 * 0.1500000059604644775390625) + vec3(0.0500000007450580596923828125))) + vec3(0.0040000001899898052215576171875)) / ((var_cb3d4 * ((var_cb3d4 * 0.1500000059604644775390625) + vec3(0.5))) + vec3(0.060000002384185791015625))) - vec3(0.066666662693023681640625)));
                }
                else
                {
                    highp vec3 var_ab2cf;
                    if (var_fde43 == 4)
                    {
                        highp vec3 var_07287 = transpose(mat3(vec3(0.59719002246856689453125, 0.354579985141754150390625, 0.048229999840259552001953125), vec3(0.075999997556209564208984375, 0.908339977264404296875, 0.0156599991023540496826171875), vec3(0.0284000001847743988037109375, 0.13382999598979949951171875, 0.837769985198974609375))) * var_6003d;
                        var_ab2cf = clamp(transpose(mat3(vec3(1.60475003719329833984375, -0.5310800075531005859375, -0.0736699998378753662109375), vec3(-0.10208000242710113525390625, 1.108129978179931640625, -0.00604999996721744537353515625), vec3(-0.00326999998651444911956787109375, -0.07276000082492828369140625, 1.0760200023651123046875))) * (((var_07287 * (var_07287 + vec3(0.02457859925925731658935546875))) - vec3(9.0537003416102379560470581054688e-05)) / ((var_07287 * ((var_07287 * 0.98372900485992431640625) + vec3(0.4329510033130645751953125))) + vec3(0.23808099329471588134765625))), vec3(0.0), vec3(1.0));
                    }
                    else
                    {
                        highp vec3 var_ee8a2;
                        if (var_fde43 == 5)
                        {
                            highp vec3 var_29097 = var_6003d;
                            highp float var_829b3 = max(var_29097.x, max(var_29097.y, var_29097.z));
                            highp float var_f9bf5 = pow(var_829b3, GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk.x);
                            highp float var_b9ec4 = var_f9bf5 / ((GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk.y * var_f9bf5) + GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk.z);
                            var_ee8a2 = mix(var_6003d / vec3(var_829b3), vec3(1.0), vec3(pow(var_b9ec4, GenericTonemapperContrastAndScaleAndOffsetAndCrosstalk.w))) * var_b9ec4;
                        }
                        else
                        {
                            var_ee8a2 = var_6003d / (vec3(1.0) + var_6003d);
                        }
                        var_ab2cf = var_ee8a2;
                    }
                    var_b9221 = var_ab2cf;
                }
                var_3a319 = var_b9221;
            }
            var_f1975 = var_3a319;
        }
        highp float var_861d0 = dot(var_f1975, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
        bool var_b594d = ColorGrading_Contrast_Midtones.w > 0.0;
        bool var_6401f;
        if (var_b594d)
        {
            var_6401f = var_861d0 >= (0.180000007152557373046875 * ColorGrading_Saturation_Highlights.w);
        }
        else
        {
            var_6401f = var_b594d;
        }
        highp vec3 var_6cd50;
        if (var_6401f)
        {
            var_6cd50 = ColorGrading_Gamma_Highlights.xyz;
        }
        else
        {
            bool var_712a8 = ColorGrading_Contrast_Shadows.w > 0.0;
            bool var_be963;
            if (var_712a8)
            {
                var_be963 = var_861d0 <= (0.180000007152557373046875 * ColorGrading_Saturation_Midtones.w);
            }
            else
            {
                var_be963 = var_712a8;
            }
            highp vec3 var_8da2a;
            if (var_be963)
            {
                var_8da2a = ColorGrading_Gamma_Shadows.xyz;
            }
            else
            {
                bool var_b2bef = var_861d0 < 0.180000007152557373046875;
                bool var_2736a;
                if (var_b2bef)
                {
                    var_2736a = ColorGrading_Contrast_Shadows.w > 0.0;
                }
                else
                {
                    var_2736a = var_b2bef;
                }
                highp vec3 var_3ba05;
                if (var_2736a)
                {
                    var_3ba05 = mix(ColorGrading_Gamma_Shadows.xyz, ColorGrading_Gamma_Midtones.xyz, vec3((var_861d0 - (0.180000007152557373046875 * ColorGrading_Saturation_Midtones.w)) / (0.180000007152557373046875 - (0.180000007152557373046875 * ColorGrading_Saturation_Midtones.w))));
                }
                else
                {
                    bool var_1e695 = var_861d0 > 0.180000007152557373046875;
                    bool var_29880;
                    if (var_1e695)
                    {
                        var_29880 = ColorGrading_Contrast_Midtones.w > 0.0;
                    }
                    else
                    {
                        var_29880 = var_1e695;
                    }
                    highp vec3 var_9da02;
                    if (var_29880)
                    {
                        var_9da02 = mix(ColorGrading_Gamma_Midtones.xyz, ColorGrading_Gamma_Highlights.xyz, vec3((var_861d0 - 0.180000007152557373046875) / ((0.180000007152557373046875 * ColorGrading_Saturation_Highlights.w) - 0.180000007152557373046875)));
                    }
                    else
                    {
                        var_9da02 = ColorGrading_Gamma_Midtones.xyz;
                    }
                    var_3ba05 = var_9da02;
                }
                var_8da2a = var_3ba05;
            }
            var_6cd50 = var_8da2a;
        }
        var_8c2ae = pow(max(var_f1975, vec3(0.0)), vec3(1.0) / (var_6cd50 * ColorGrading_Gamma_PlayerUI.x));
    }
    highp vec3 var_b53eb = clamp(var_8c2ae, vec3(0.0), vec3(1.0));
    highp vec3 var_d9d1b;
    if (RasterizedColorEnabled.x > 0.0)
    {
        highp vec4 var_ccefb = texture(s_RasterizedColor, v_texcoord0);
        highp vec4 var_bfce0 = var_ccefb;
        var_d9d1b = (var_b53eb * (1.0 - var_bfce0.w)) + var_ccefb.xyz;
    }
    else
    {
        var_d9d1b = var_b53eb;
    }
    bgfx_FragColor = vec4(var_d9d1b, 1.0);
}
