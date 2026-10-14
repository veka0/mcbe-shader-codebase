#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_txBuffer;
* - uniform lowp sampler2D s_txBuffer1;
* - uniform lowp sampler2D s_txBuffer2;
* - uniform lowp sampler2D s_txBuffer3;
*
* Uniforms:
* - uniform vec4 Data_PS[128];
* - uniform vec4 Data_VS[128];
* - uniform vec4 UVTransform[5];
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_txBuffer1;
uniform highp sampler2D s_txBuffer2;
uniform highp sampler2D s_txBuffer3;
uniform highp sampler2D s_txBuffer;
uniform highp vec4 Data_PS[128];
uniform highp vec4 UVTransform[5];
in highp vec4 v_Additional;
in highp vec3 v_ScreenNormalPosition;
flat in highp vec4 v_VaryingData;
layout(location = 0) out highp vec4 bgfx_FragData0;
void func_b96d4(inout highp vec3 arg_9109e, inout highp float arg_fc78a) {
    if (arg_9109e.x <= 0.040449999272823333740234375)
    {
        arg_fc78a = arg_9109e.x * 0.077399380505084991455078125;
        return;
    }
    arg_fc78a = pow((arg_9109e.x + 0.054999999701976776123046875) * 0.947867333889007568359375, 2.400000095367431640625);
}
void func_9b9e1(inout highp vec3 arg_9042f, inout highp float arg_031a2) {
    if (arg_9042f.y <= 0.040449999272823333740234375)
    {
        arg_031a2 = arg_9042f.y * 0.077399380505084991455078125;
        return;
    }
    arg_031a2 = pow((arg_9042f.y + 0.054999999701976776123046875) * 0.947867333889007568359375, 2.400000095367431640625);
}
void func_98fd5(inout highp vec3 arg_2f460, inout highp float arg_ac5fc) {
    if (arg_2f460.z <= 0.040449999272823333740234375)
    {
        arg_ac5fc = arg_2f460.z * 0.077399380505084991455078125;
        return;
    }
    arg_ac5fc = pow((arg_2f460.z + 0.054999999701976776123046875) * 0.947867333889007568359375, 2.400000095367431640625);
}
void func_438fb(inout highp vec3 arg_01f00, inout highp float arg_d703c) {
    if (arg_01f00.x <= 0.003130800090730190277099609375)
    {
        arg_d703c = arg_01f00.x * 12.9200000762939453125;
        return;
    }
    arg_d703c = (1.05499994754791259765625 * pow(arg_01f00.x, 0.4166666567325592041015625)) - 0.054999999701976776123046875;
}
void func_038c3(inout highp vec3 arg_5ef8a, inout highp float arg_db16f) {
    if (arg_5ef8a.y <= 0.003130800090730190277099609375)
    {
        arg_db16f = arg_5ef8a.y * 12.9200000762939453125;
        return;
    }
    arg_db16f = (1.05499994754791259765625 * pow(arg_5ef8a.y, 0.4166666567325592041015625)) - 0.054999999701976776123046875;
}
void func_8e34f(inout highp vec3 arg_7eff1, inout highp float arg_2ac25) {
    if (arg_7eff1.z <= 0.003130800090730190277099609375)
    {
        arg_2ac25 = arg_7eff1.z * 12.9200000762939453125;
        return;
    }
    arg_2ac25 = (1.05499994754791259765625 * pow(arg_7eff1.z, 0.4166666567325592041015625)) - 0.054999999701976776123046875;
}
void main() {
    highp vec4 var_e6fcd = vec4(0.0);
    uvec4 var_4370d = uvec4(v_VaryingData);
    uvec4 var_eb4ac = uvec4(v_VaryingData);
    int var_99696 = int((var_eb4ac.z << 4u) | ((var_eb4ac.y & 240u) >> 4u));
    int var_f473b = int(var_eb4ac.w);
    highp vec4 var_d4970 = Data_PS[var_99696];
    int var_c30fa = var_99696 + 1;
    highp vec4 var_ba6b7 = Data_PS[var_c30fa];
    int var_d04db = int(var_d4970.x);
    int var_f1761 = int(Data_PS[max(0, (var_d04db + (-1)))].y);
    highp vec4 var_22d81 = Data_PS[var_c30fa];
    highp float var_1bfef;
    if (1 == var_f473b)
    {
        var_1bfef = clamp(0.5 - (length(v_ScreenNormalPosition.xy - v_Additional.xy) - v_Additional.z), 0.0, 1.0);
    }
    else
    {
        highp float var_45af2;
        if (2 == var_f473b)
        {
            highp float var_55641 = length(v_ScreenNormalPosition.xy - v_Additional.xy);
            var_45af2 = clamp(0.5 - (var_55641 - v_Additional.z), 0.0, 1.0) * (1.0 - clamp(0.5 - (var_55641 - (v_Additional.z - v_Additional.w)), 0.0, 1.0));
        }
        else
        {
            highp float var_6c060;
            if (4 == var_f473b)
            {
                highp vec2 var_14fb7 = (v_ScreenNormalPosition.xy - v_Additional.xy) / v_Additional.zw;
                highp vec2 var_54443 = var_14fb7;
                highp vec2 var_deda4 = dFdx(var_14fb7);
                highp vec2 var_bf046 = dFdy(var_14fb7);
                highp vec2 var_c8c88 = vec2(((2.0 * var_54443.x) * var_deda4.x) + ((2.0 * var_54443.y) * var_deda4.y), ((2.0 * var_54443.x) * var_bf046.x) + ((2.0 * var_54443.y) * var_bf046.y));
                var_6c060 = clamp(0.5 - ((dot(var_14fb7, var_14fb7) - 1.0) * inversesqrt(max(dot(var_c8c88, var_c8c88), 9.9999997473787516355514526367188e-05))), 0.0, 1.0);
            }
            else
            {
                highp float var_694ba;
                if (5 == var_f473b)
                {
                    highp vec3 var_ab7b6 = Data_PS[var_99696].yzw;
                    highp vec2 var_4a762 = (v_ScreenNormalPosition.xy - v_Additional.xy) / (v_Additional.zw + vec2(var_ab7b6.x * 0.5));
                    highp vec2 var_87286 = var_4a762;
                    highp vec2 var_615cc = dFdx(var_4a762);
                    highp vec2 var_3fe1e = dFdy(var_4a762);
                    highp float var_682c6 = var_87286.x;
                    highp float var_6efe0 = var_615cc.x;
                    highp float var_4db26 = var_87286.y;
                    highp float var_fbdd3 = var_615cc.y;
                    highp float var_2d9d7 = var_87286.x;
                    highp float var_feb15 = var_3fe1e.x;
                    highp float var_0c52d = var_87286.y;
                    highp float var_0fdea = var_3fe1e.y;
                    highp vec2 var_04c69 = vec2(((2.0 * var_682c6) * var_6efe0) + ((2.0 * var_4db26) * var_fbdd3), ((2.0 * var_2d9d7) * var_feb15) + ((2.0 * var_0c52d) * var_0fdea));
                    highp vec2 var_6c3c2 = (v_ScreenNormalPosition.xy - v_Additional.xy) / (v_Additional.zw - vec2(var_ab7b6.x * 0.5));
                    var_87286 = var_6c3c2;
                    var_615cc = dFdx(var_6c3c2);
                    var_3fe1e = dFdy(var_6c3c2);
                    highp vec2 var_c2fe3 = vec2(((2.0 * var_87286.x) * var_615cc.x) + ((2.0 * var_87286.y) * var_615cc.y), ((2.0 * var_87286.x) * var_3fe1e.x) + ((2.0 * var_87286.y) * var_3fe1e.y));
                    var_694ba = clamp(0.5 - ((dot(var_4a762, var_4a762) - 1.0) * inversesqrt(max(dot(var_04c69, var_04c69), 9.9999997473787516355514526367188e-05))), 0.0, 1.0) * clamp(0.5 + ((dot(var_6c3c2, var_6c3c2) - 1.0) * inversesqrt(max(dot(var_c2fe3, var_c2fe3), 9.9999997473787516355514526367188e-05))), 0.0, 1.0);
                }
                else
                {
                    highp float var_ddde2;
                    if (6 == var_f473b)
                    {
                        var_22d81 = vec4(0.0);
                        highp vec4 var_94f17 = Data_PS[var_d04db + 1];
                        highp float var_7d97a;
                        if (Data_PS[var_d04db].x > 3.0)
                        {
                            var_7d97a = Data_PS[var_d04db].x * 0.307196319103240966796875;
                        }
                        else
                        {
                            var_7d97a = 0.60000002384185791015625 + (Data_PS[var_d04db].x * 0.100000001490116119384765625);
                        }
                        int var_868c8 = (int(Data_PS[var_d04db].x) * 2) + 1;
                        int var_a4dbb = var_868c8 / 2;
                        highp float var_61cbe;
                        var_61cbe = 0.0;
                        highp float var_20d98;
                        for (int var_21202 = 0; var_21202 < var_868c8; var_61cbe = var_20d98, var_21202++)
                        {
                            var_20d98 = var_61cbe + (exp((-0.5) * pow(float(var_21202 - var_a4dbb) / var_7d97a, 2.0)) / (2.5066282749176025390625 * var_7d97a));
                        }
                        int var_84061 = int(mod(Data_PS[var_d04db].x + 1.0, 2.0));
                        highp float var_4ee65 = ((exp((-0.5) * pow(float(var_a4dbb - var_a4dbb) / var_7d97a, 2.0)) / (2.5066282749176025390625 * var_7d97a)) / var_61cbe) * 0.5;
                        highp vec2 var_528d5 = vec2(0.0);
                        int var_825f8 = int((Data_PS[var_d04db].x * 0.5) + 1.0);
                        highp float var_b2b23;
                        int var_f6ced = 0;
                        highp float var_2ae5d = var_4ee65;
                        for (; var_f6ced < var_825f8; var_2ae5d = var_b2b23, var_f6ced++)
                        {
                            if ((var_f6ced != 0) || (var_84061 != 1))
                            {
                                highp float var_8fe19;
                                if (var_f6ced == 0)
                                {
                                    var_8fe19 = var_2ae5d;
                                }
                                else
                                {
                                    var_8fe19 = (exp((-0.5) * pow(float((var_a4dbb - ((var_f6ced * 2) - var_84061)) - var_a4dbb) / var_7d97a, 2.0)) / (2.5066282749176025390625 * var_7d97a)) / var_61cbe;
                                }
                                highp float var_e88e5 = (exp((-0.5) * pow(float((var_a4dbb - (((var_f6ced * 2) + 1) - var_84061)) - var_a4dbb) / var_7d97a, 2.0)) / (2.5066282749176025390625 * var_7d97a)) / var_61cbe;
                                highp float var_042ad = var_8fe19 + var_e88e5;
                                highp float var_1b6c6 = float((var_f6ced * 2) - var_84061) + (var_e88e5 / var_042ad);
                                var_528d5.x = var_1b6c6 * Data_PS[var_d04db].y;
                                var_528d5.y = var_1b6c6 * Data_PS[var_d04db].z;
                                var_b2b23 = var_042ad;
                            }
                            else
                            {
                                var_b2b23 = var_2ae5d;
                            }
                            highp vec4 var_af455 = vec4(v_Additional.xy + var_528d5, 0.0, 0.0);
                            highp vec4 var_df824 = vec4(v_Additional.xy - var_528d5, 0.0, 0.0);
                            bool var_050eb = var_94f17.z != (-1.0);
                            bool var_f434b;
                            if (!var_050eb)
                            {
                                var_f434b = var_94f17.w != (-1.0);
                            }
                            else
                            {
                                var_f434b = var_050eb;
                            }
                            if (var_f434b)
                            {
                                var_af455.x = clamp(v_Additional.x + var_528d5.x, var_94f17.x, var_94f17.x + var_94f17.z);
                                var_af455.y = clamp(v_Additional.y + var_528d5.y, var_94f17.y, var_94f17.y + var_94f17.w);
                                var_df824.x = clamp(v_Additional.x - var_528d5.x, var_94f17.x, var_94f17.x + var_94f17.z);
                                var_df824.y = clamp(v_Additional.y - var_528d5.y, var_94f17.y, var_94f17.y + var_94f17.w);
                            }
                            highp vec2 var_e88fa = vec2(var_af455.x, 1.0 - var_af455.y);
                            highp float var_7c2cb = var_e88fa.x;
                            highp float var_76ed8 = var_e88fa.y;
                            highp vec2 var_6177c = vec2(var_7c2cb, 1.0 - var_76ed8);
                            var_e88fa = var_6177c;
                            highp vec4 var_7c2ca = texture(s_txBuffer, vec2(((var_6177c * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_6177c * UVTransform[0].zw) + UVTransform[0].xy).y));
                            highp vec2 var_a6693 = vec2(var_df824.x, 1.0 - var_df824.y);
                            highp float var_a90b9 = var_a6693.x;
                            highp float var_497e4 = var_a6693.y;
                            highp vec2 var_2d165 = vec2(var_a90b9, 1.0 - var_497e4);
                            var_a6693 = var_2d165;
                            highp vec4 var_5da63 = texture(s_txBuffer, vec2(((var_2d165 * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_2d165 * UVTransform[0].zw) + UVTransform[0].xy).y));
                            if ((var_f1761 & 2) != 0)
                            {
                                highp vec3 var_a8992 = var_7c2ca.xyz;
                                highp float var_c0d55;
                                func_b96d4(var_a8992, var_c0d55);
                                highp float var_f38a1;
                                func_9b9e1(var_a8992, var_f38a1);
                                highp float var_53738;
                                func_98fd5(var_a8992, var_53738);
                                var_7c2ca.x = var_c0d55;
                                var_7c2ca.y = var_f38a1;
                                var_7c2ca.z = var_53738;
                                highp vec3 var_ff496 = var_5da63.xyz;
                                highp float var_1b006;
                                func_b96d4(var_ff496, var_1b006);
                                highp float var_ace58;
                                func_9b9e1(var_ff496, var_ace58);
                                highp float var_ea1a9;
                                func_98fd5(var_ff496, var_ea1a9);
                                var_5da63.x = var_1b006;
                                var_5da63.y = var_ace58;
                                var_5da63.z = var_ea1a9;
                            }
                            else
                            {
                                if ((var_f1761 & 16) != 0)
                                {
                                    highp vec3 var_b0d06 = var_7c2ca.xyz;
                                    highp float var_5e6fa;
                                    func_438fb(var_b0d06, var_5e6fa);
                                    highp float var_bcbbe;
                                    func_038c3(var_b0d06, var_bcbbe);
                                    highp float var_dec41;
                                    func_8e34f(var_b0d06, var_dec41);
                                    var_7c2ca.x = var_5e6fa;
                                    var_7c2ca.y = var_bcbbe;
                                    var_7c2ca.z = var_dec41;
                                    highp vec3 var_bbf1f = var_5da63.xyz;
                                    highp float var_d0954;
                                    func_438fb(var_bbf1f, var_d0954);
                                    highp float var_b6e88;
                                    func_038c3(var_bbf1f, var_b6e88);
                                    highp float var_36ca9;
                                    func_8e34f(var_bbf1f, var_36ca9);
                                    var_5da63.x = var_d0954;
                                    var_5da63.y = var_b6e88;
                                    var_5da63.z = var_36ca9;
                                }
                            }
                            var_22d81 += ((var_7c2ca + var_5da63) * var_b2b23);
                        }
                        var_ddde2 = var_ba6b7.w;
                    }
                    else
                    {
                        highp float var_2ccd6;
                        if (7 == var_f473b)
                        {
                            highp vec2 var_42b85 = v_Additional.xy;
                            highp vec4 var_c1770 = Data_PS[var_d04db];
                            bool var_b8db6 = var_c1770.z != (-1.0);
                            bool var_0b048;
                            if (!var_b8db6)
                            {
                                var_0b048 = var_c1770.w != (-1.0);
                            }
                            else
                            {
                                var_0b048 = var_b8db6;
                            }
                            if (var_0b048)
                            {
                                var_42b85.x = clamp(var_42b85.x, var_c1770.x, var_c1770.x + var_c1770.z);
                                var_42b85.y = clamp(var_42b85.y, var_c1770.y, var_c1770.y + var_c1770.w);
                            }
                            highp vec2 var_13541 = vec2(var_42b85.x, 1.0 - var_42b85.y);
                            highp float var_ca6f5 = var_13541.x;
                            highp float var_e424a = var_13541.y;
                            highp vec2 var_d2bf0 = vec2(var_ca6f5, 1.0 - var_e424a);
                            var_13541 = var_d2bf0;
                            highp vec4 var_fb3a4 = texture(s_txBuffer, vec2(((var_d2bf0 * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_d2bf0 * UVTransform[0].zw) + UVTransform[0].xy).y));
                            if ((var_f1761 & 2) != 0)
                            {
                                highp vec3 var_be626 = var_fb3a4.xyz;
                                highp float var_5e541;
                                func_b96d4(var_be626, var_5e541);
                                highp float var_caa09;
                                func_9b9e1(var_be626, var_caa09);
                                highp float var_a768d;
                                func_98fd5(var_be626, var_a768d);
                                var_fb3a4.x = var_5e541;
                                var_fb3a4.y = var_caa09;
                                var_fb3a4.z = var_a768d;
                            }
                            else
                            {
                                if ((var_f1761 & 16) != 0)
                                {
                                    highp vec3 var_7bca4 = var_fb3a4.xyz;
                                    highp float var_4ece2;
                                    func_438fb(var_7bca4, var_4ece2);
                                    highp float var_27389;
                                    func_038c3(var_7bca4, var_27389);
                                    highp float var_8a49f;
                                    func_8e34f(var_7bca4, var_8a49f);
                                    var_fb3a4.x = var_4ece2;
                                    var_fb3a4.y = var_27389;
                                    var_fb3a4.z = var_8a49f;
                                }
                            }
                            highp float var_6215c = var_fb3a4.w;
                            highp float var_598f3 = max(var_6215c, 9.9999997473787516355514526367188e-06);
                            highp vec4 var_176b1 = var_fb3a4;
                            highp vec4 var_729fe = vec4(var_176b1.xyz / vec3(var_598f3), var_598f3);
                            var_fb3a4 = var_729fe;
                            var_22d81.x = dot(var_729fe, Data_PS[var_d04db + 1]);
                            var_22d81.y = dot(var_729fe, Data_PS[var_d04db + 2]);
                            var_22d81.z = dot(var_729fe, Data_PS[var_d04db + 3]);
                            var_22d81.w = dot(var_729fe, Data_PS[var_d04db + 4]);
                            highp vec4 var_ea70f = var_22d81;
                            highp vec4 var_288d5 = var_ea70f + Data_PS[var_d04db + 5];
                            var_22d81 = var_288d5;
                            highp vec3 var_5ad70 = var_288d5.xyz;
                            var_22d81.w = mix(clamp(((0.2125999927520751953125 * var_5ad70.x) + (0.715200006961822509765625 * var_5ad70.y)) + (0.072200000286102294921875 * var_5ad70.z), 0.0, 1.0), var_22d81.w, var_ba6b7.z);
                            highp float var_bffc0 = var_22d81.w;
                            var_22d81.w = 1.0;
                            var_2ccd6 = (var_bffc0 * var_ba6b7.w) * clamp(v_Additional.z, 0.0, 1.0);
                        }
                        else
                        {
                            bool var_7973d = 9 == var_f473b;
                            bool var_bb487;
                            if (!var_7973d)
                            {
                                var_bb487 = 12 == var_f473b;
                            }
                            else
                            {
                                var_bb487 = var_7973d;
                            }
                            highp float var_97871;
                            if (var_bb487)
                            {
                                highp vec2 var_31608 = v_Additional.xy;
                                highp float var_7bb88 = var_31608.x;
                                highp float var_02a1a = var_31608.y;
                                highp vec2 var_b488c = vec2(var_7bb88, 1.0 - var_02a1a);
                                var_31608 = var_b488c;
                                highp vec3 var_9791e;
                                var_9791e.x = texture(s_txBuffer, vec2(((var_b488c * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_b488c * UVTransform[0].zw) + UVTransform[0].xy).y)).x;
                                highp vec2 var_339ee = v_Additional.xy;
                                highp float var_71dd7 = var_339ee.x;
                                highp float var_54d54 = var_339ee.y;
                                highp vec2 var_06981 = vec2(var_71dd7, 1.0 - var_54d54);
                                var_339ee = var_06981;
                                var_9791e.y = texture(s_txBuffer1, vec2(((var_06981 * UVTransform[1].zw) + UVTransform[1].xy).x, 1.0 - ((var_06981 * UVTransform[1].zw) + UVTransform[1].xy).y)).x;
                                highp vec2 var_b5d77 = v_Additional.xy;
                                highp float var_902d3 = var_b5d77.x;
                                highp float var_07b0f = var_b5d77.y;
                                highp vec2 var_a46df = vec2(var_902d3, 1.0 - var_07b0f);
                                var_b5d77 = var_a46df;
                                var_9791e.z = texture(s_txBuffer2, vec2(((var_a46df * UVTransform[2].zw) + UVTransform[2].xy).x, 1.0 - ((var_a46df * UVTransform[2].zw) + UVTransform[2].xy).y)).x;
                                highp vec3 var_0a617 = var_9791e;
                                highp vec3 var_94fe9 = var_0a617 - vec3(0.0625, 0.5, 0.5);
                                var_9791e = var_94fe9;
                                highp vec3 var_2e85c = mat3(vec3(1.164000034332275390625), vec3(0.0, -0.3910000026226043701171875, 2.0179998874664306640625), vec3(1.5959999561309814453125, -0.813000023365020751953125, 0.0)) * var_94fe9;
                                highp vec3 var_04011;
                                if ((var_f1761 & 2) != 0)
                                {
                                    highp vec3 var_176d2 = var_2e85c;
                                    highp float var_54e30;
                                    func_b96d4(var_176d2, var_54e30);
                                    highp float var_9cd97;
                                    func_9b9e1(var_176d2, var_9cd97);
                                    highp float var_4fcea;
                                    func_98fd5(var_176d2, var_4fcea);
                                    var_04011 = vec3(var_54e30, var_9cd97, var_4fcea);
                                }
                                else
                                {
                                    highp vec3 var_c1cae;
                                    if ((var_f1761 & 16) != 0)
                                    {
                                        highp vec3 var_b5340 = var_2e85c;
                                        highp float var_50855;
                                        func_438fb(var_b5340, var_50855);
                                        highp float var_8840f;
                                        func_038c3(var_b5340, var_8840f);
                                        highp float var_4de69;
                                        func_8e34f(var_b5340, var_4de69);
                                        var_c1cae = vec3(var_50855, var_8840f, var_4de69);
                                    }
                                    else
                                    {
                                        var_c1cae = var_2e85c;
                                    }
                                    var_04011 = var_c1cae;
                                }
                                var_22d81 = vec4(var_04011, 1.0);
                                highp float var_e2cb4;
                                if (12 == var_f473b)
                                {
                                    highp vec2 var_5506d = v_Additional.xy;
                                    highp float var_68bed = var_5506d.x;
                                    highp float var_3ba70 = var_5506d.y;
                                    highp vec2 var_bb58f = vec2(var_68bed, 1.0 - var_3ba70);
                                    var_5506d = var_bb58f;
                                    var_e2cb4 = (var_ba6b7.w * clamp(v_Additional.z, 0.0, 1.0)) * texture(s_txBuffer3, vec2(((var_bb58f * UVTransform[3].zw) + UVTransform[3].xy).x, 1.0 - ((var_bb58f * UVTransform[3].zw) + UVTransform[3].xy).y)).x;
                                }
                                else
                                {
                                    var_e2cb4 = var_ba6b7.w;
                                }
                                var_97871 = var_e2cb4;
                            }
                            else
                            {
                                highp float var_b4261;
                                if (11 == var_f473b)
                                {
                                    var_b4261 = clamp((1.0 - clamp(abs(dot(v_Additional.xyz, vec3(v_ScreenNormalPosition.xy, 1.0))), 0.0, 1.0)) * v_Additional.w, 0.0, 1.0);
                                }
                                else
                                {
                                    highp float var_ed456;
                                    if (19 == var_f473b)
                                    {
                                        highp vec2 var_a823e = v_Additional.xy;
                                        highp float var_d7208 = var_a823e.x;
                                        highp float var_15d8c = var_a823e.y;
                                        highp vec2 var_c83f0 = vec2(var_d7208, 1.0 - var_15d8c);
                                        var_a823e = var_c83f0;
                                        highp vec4 var_85a00 = Data_PS[var_d04db];
                                        highp float var_59f5d = sqrt(var_85a00.y * 0.5);
                                        highp float var_31273 = (0.5 * var_59f5d) - 0.89999997615814208984375;
                                        highp float var_07a02 = ((var_85a00.z / var_85a00.y) * 0.5) * var_59f5d;
                                        highp float var_2f2fd = texture(s_txBuffer, vec2(((var_c83f0 * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_c83f0 * UVTransform[0].zw) + UVTransform[0].xy).y)).x * var_59f5d;
                                        var_22d81 = mix(Data_PS[var_d04db + 1], Data_PS[var_c30fa], vec4(clamp(var_2f2fd - (var_31273 + var_07a02), 0.0, 1.0))) * clamp(var_2f2fd - max(0.0, var_31273 - var_07a02), 0.0, 1.0);
                                        var_ed456 = 1.0;
                                    }
                                    else
                                    {
                                        highp float var_e78af;
                                        if ((var_f473b == 32) || (var_f473b == 35))
                                        {
                                            highp vec2 var_b884f = v_Additional.zw;
                                            if (var_f473b == 35)
                                            {
                                                highp vec2 var_f7064 = var_b884f;
                                                highp vec2 var_f452d = (Data_PS[var_d04db].zw * vec2(fract(var_f7064).x, 1.0 - fract(var_f7064).y)) + Data_PS[var_d04db].xy;
                                                var_b884f = var_f452d;
                                                highp vec2 var_5655b = var_f452d;
                                                highp float var_749cb = var_5655b.x;
                                                highp float var_b39ea = var_5655b.y;
                                                highp vec2 var_82997 = vec2(var_749cb, 1.0 - var_b39ea);
                                                var_5655b = var_82997;
                                                var_22d81 = texture(s_txBuffer, vec2(((var_82997 * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_82997 * UVTransform[0].zw) + UVTransform[0].xy).y));
                                            }
                                            else
                                            {
                                                highp vec2 var_12bb9 = vec2(var_b884f.x, 1.0 - var_b884f.y);
                                                highp float var_f7f43 = var_12bb9.x;
                                                highp float var_731de = var_12bb9.y;
                                                highp vec2 var_cc6ff = vec2(var_f7f43, 1.0 - var_731de);
                                                var_12bb9 = var_cc6ff;
                                                var_22d81 = texture(s_txBuffer, vec2(((var_cc6ff * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_cc6ff * UVTransform[0].zw) + UVTransform[0].xy).y));
                                            }
                                            if ((var_f1761 & 2) != 0)
                                            {
                                                highp vec3 var_88946 = var_22d81.xyz;
                                                highp float var_ec711;
                                                func_b96d4(var_88946, var_ec711);
                                                highp float var_fc526;
                                                func_9b9e1(var_88946, var_fc526);
                                                highp float var_06e11;
                                                func_98fd5(var_88946, var_06e11);
                                                var_22d81.x = var_ec711;
                                                var_22d81.y = var_fc526;
                                                var_22d81.z = var_06e11;
                                            }
                                            else
                                            {
                                                if ((var_f1761 & 16) != 0)
                                                {
                                                    highp vec3 var_e5842 = var_22d81.xyz;
                                                    highp float var_0a69d;
                                                    func_438fb(var_e5842, var_0a69d);
                                                    highp float var_4d6f1;
                                                    func_038c3(var_e5842, var_4d6f1);
                                                    highp float var_1b905;
                                                    func_8e34f(var_e5842, var_1b905);
                                                    var_22d81.x = var_0a69d;
                                                    var_22d81.y = var_4d6f1;
                                                    var_22d81.z = var_1b905;
                                                }
                                            }
                                            var_22d81.w = mix(var_22d81.w, 1.0 - var_22d81.w, float((int(var_ba6b7.x) & 1) != 0));
                                            highp vec3 var_b21cc = var_22d81.xyz;
                                            var_22d81.w = mix(clamp(((0.2125999927520751953125 * var_b21cc.x) + (0.715200006961822509765625 * var_b21cc.y)) + (0.072200000286102294921875 * var_b21cc.z), 0.0, 1.0), var_22d81.w, var_ba6b7.z);
                                            var_22d81.w = mix(var_22d81.w, 1.0, float((int(var_ba6b7.x) & 2) != 0));
                                            highp vec2 var_b7903 = (v_ScreenNormalPosition.xy - v_Additional.xy) / vec2(v_ScreenNormalPosition.z, var_d4970.y);
                                            highp vec2 var_c88db = var_b7903;
                                            highp vec2 var_b3452 = dFdx(var_b7903);
                                            highp vec2 var_5297e = dFdy(var_b7903);
                                            highp vec2 var_78729 = vec2(((2.0 * var_c88db.x) * var_b3452.x) + ((2.0 * var_c88db.y) * var_b3452.y), ((2.0 * var_c88db.x) * var_5297e.x) + ((2.0 * var_c88db.y) * var_5297e.y));
                                            var_e78af = var_ba6b7.w * clamp(0.5 - ((dot(var_b7903, var_b7903) - 1.0) * inversesqrt(max(dot(var_78729, var_78729), 9.9999997473787516355514526367188e-05))), 0.0, 1.0);
                                        }
                                        else
                                        {
                                            highp float var_44de7;
                                            if (var_f473b == 33)
                                            {
                                                highp vec2 var_25a40 = Data_PS[var_d04db].xy;
                                                highp float var_efbbd;
                                                if (var_25a40.x < var_25a40.y)
                                                {
                                                    var_efbbd = var_25a40.x;
                                                }
                                                else
                                                {
                                                    var_efbbd = var_25a40.y;
                                                }
                                                highp vec2 var_df549 = (Data_PS[var_d04db + 1].zw * vec2(fract(v_Additional.zw).x, 1.0 - fract(v_Additional.zw).y)) + Data_PS[var_d04db + 1].xy;
                                                highp float var_04de2 = var_df549.x;
                                                highp float var_1a3f2 = var_df549.y;
                                                highp vec2 var_af99f = vec2(var_04de2, 1.0 - var_1a3f2);
                                                var_df549 = var_af99f;
                                                var_22d81 = texture(s_txBuffer, vec2(((var_af99f * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_af99f * UVTransform[0].zw) + UVTransform[0].xy).y));
                                                if ((var_f1761 & 2) != 0)
                                                {
                                                    highp vec3 var_f2f08 = var_22d81.xyz;
                                                    highp float var_9af0e;
                                                    func_b96d4(var_f2f08, var_9af0e);
                                                    highp float var_622a3;
                                                    func_9b9e1(var_f2f08, var_622a3);
                                                    highp float var_350bf;
                                                    func_98fd5(var_f2f08, var_350bf);
                                                    var_22d81.x = var_9af0e;
                                                    var_22d81.y = var_622a3;
                                                    var_22d81.z = var_350bf;
                                                }
                                                else
                                                {
                                                    if ((var_f1761 & 16) != 0)
                                                    {
                                                        highp vec3 var_e3e93 = var_22d81.xyz;
                                                        highp float var_73722;
                                                        func_438fb(var_e3e93, var_73722);
                                                        highp float var_a8b63;
                                                        func_038c3(var_e3e93, var_a8b63);
                                                        highp float var_9ddd6;
                                                        func_8e34f(var_e3e93, var_9ddd6);
                                                        var_22d81.x = var_73722;
                                                        var_22d81.y = var_a8b63;
                                                        var_22d81.z = var_9ddd6;
                                                    }
                                                }
                                                var_22d81.w = mix(1.0 - var_22d81.w, var_22d81.w, var_ba6b7.x);
                                                highp vec3 var_b5c5f = var_22d81.xyz;
                                                var_22d81.w = mix(clamp(((0.2125999927520751953125 * var_b5c5f.x) + (0.715200006961822509765625 * var_b5c5f.y)) + (0.072200000286102294921875 * var_b5c5f.z), 0.0, 1.0), var_22d81.w, var_ba6b7.z);
                                                var_22d81.w = mix(var_22d81.w, 1.0, var_d4970.y);
                                                var_44de7 = var_ba6b7.w * clamp(0.5 - (var_efbbd * (length(v_ScreenNormalPosition.xy - v_Additional.xy) - v_ScreenNormalPosition.z)), 0.0, 1.0);
                                            }
                                            else
                                            {
                                                highp float var_119dc;
                                                if (var_f473b == 23)
                                                {
                                                    highp vec2 var_c7ee7 = v_Additional.xy;
                                                    highp float var_7626b = var_c7ee7.x;
                                                    highp float var_81704 = var_c7ee7.y;
                                                    highp vec2 var_15243 = vec2(var_7626b, 1.0 - var_81704);
                                                    var_c7ee7 = var_15243;
                                                    highp vec4 var_ee3f4 = texture(s_txBuffer, vec2(((var_15243 * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_15243 * UVTransform[0].zw) + UVTransform[0].xy).y));
                                                    highp float var_26b24 = var_ee3f4.x;
                                                    highp vec4 var_5743b = Data_PS[var_d04db];
                                                    highp float var_6a413 = var_5743b.z * var_5743b.x;
                                                    highp float var_23cd3 = 0.5 + (0.5 * var_6a413);
                                                    highp float var_5ef07 = var_23cd3 - var_6a413;
                                                    highp float var_fd049 = smoothstep(var_5ef07 - var_5743b.x, var_5ef07 + var_5743b.x, var_26b24);
                                                    if (var_fd049 <= 0.0)
                                                    {
                                                        discard;
                                                    }
                                                    var_22d81 = mix(Data_PS[var_d04db + 1], Data_PS[var_c30fa], vec4(smoothstep(var_23cd3 - var_5743b.x, var_23cd3 + var_5743b.x, var_26b24))) * var_fd049;
                                                    var_119dc = 1.0;
                                                }
                                                else
                                                {
                                                    highp float var_33568;
                                                    if (var_f473b == 24)
                                                    {
                                                        highp vec2 var_08020 = v_Additional.xy;
                                                        highp float var_eb88c = var_08020.x;
                                                        highp float var_9e047 = var_08020.y;
                                                        highp vec2 var_e31cd = vec2(var_eb88c, 1.0 - var_9e047);
                                                        var_08020 = var_e31cd;
                                                        highp vec3 var_ff1b7 = texture(s_txBuffer3, vec2(((var_e31cd * UVTransform[3].zw) + UVTransform[3].xy).x, 1.0 - ((var_e31cd * UVTransform[3].zw) + UVTransform[3].xy).y)).xyz;
                                                        var_22d81 = Data_PS[var_c30fa] * smoothstep(0.5 - v_Additional.z, 0.5 + v_Additional.z, max(min(var_ff1b7.x, var_ff1b7.y), min(max(var_ff1b7.x, var_ff1b7.y), var_ff1b7.z)));
                                                        var_33568 = 1.0;
                                                    }
                                                    else
                                                    {
                                                        highp float var_8dc78;
                                                        if (var_f473b == 25)
                                                        {
                                                            highp vec2 var_31645 = v_Additional.xy;
                                                            highp float var_918df = var_31645.x;
                                                            highp float var_1a5e4 = var_31645.y;
                                                            highp vec2 var_a2224 = vec2(var_918df, 1.0 - var_1a5e4);
                                                            var_31645 = var_a2224;
                                                            highp vec3 var_b869a = texture(s_txBuffer, vec2(((var_a2224 * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_a2224 * UVTransform[0].zw) + UVTransform[0].xy).y)).xyz;
                                                            highp vec4 var_714ab = Data_PS[var_d04db];
                                                            highp float var_86ce8 = var_714ab.z * var_714ab.x;
                                                            highp float var_60d5d = 0.5 + (0.5 * var_86ce8);
                                                            highp float var_d3a86 = var_60d5d - var_86ce8;
                                                            highp float var_bc6ed = max(min(var_b869a.x, var_b869a.y), min(max(var_b869a.x, var_b869a.y), var_b869a.z));
                                                            highp float var_7f653 = smoothstep(var_d3a86 - var_714ab.x, var_d3a86 + var_714ab.x, var_bc6ed);
                                                            if (var_7f653 <= 0.0)
                                                            {
                                                                discard;
                                                            }
                                                            var_22d81 = mix(Data_PS[var_d04db + 1], Data_PS[var_c30fa], vec4(smoothstep(var_60d5d - var_714ab.x, var_60d5d + var_714ab.x, var_bc6ed))) * var_7f653;
                                                            var_8dc78 = 1.0;
                                                        }
                                                        else
                                                        {
                                                            highp float var_41cb3;
                                                            if (var_f473b == 31)
                                                            {
                                                                highp vec2 var_ac8fb = v_Additional.zw;
                                                                highp vec2 var_5f747 = vec2(var_ac8fb.x, 1.0 - var_ac8fb.y);
                                                                highp float var_3545c = var_5f747.x;
                                                                highp float var_e72f9 = var_5f747.y;
                                                                highp vec2 var_eaf6c = vec2(var_3545c, 1.0 - var_e72f9);
                                                                var_5f747 = var_eaf6c;
                                                                var_22d81 = texture(s_txBuffer, vec2(((var_eaf6c * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_eaf6c * UVTransform[0].zw) + UVTransform[0].xy).y));
                                                                if ((var_f1761 & 2) != 0)
                                                                {
                                                                    highp vec3 var_14c63 = var_22d81.xyz;
                                                                    highp float var_47bc6;
                                                                    func_b96d4(var_14c63, var_47bc6);
                                                                    highp float var_be186;
                                                                    func_9b9e1(var_14c63, var_be186);
                                                                    highp float var_77320;
                                                                    func_98fd5(var_14c63, var_77320);
                                                                    var_22d81.x = var_47bc6;
                                                                    var_22d81.y = var_be186;
                                                                    var_22d81.z = var_77320;
                                                                }
                                                                else
                                                                {
                                                                    if ((var_f1761 & 16) != 0)
                                                                    {
                                                                        highp vec3 var_37e42 = var_22d81.xyz;
                                                                        highp float var_15eb4;
                                                                        func_438fb(var_37e42, var_15eb4);
                                                                        highp float var_0f77b;
                                                                        func_038c3(var_37e42, var_0f77b);
                                                                        highp float var_6ef19;
                                                                        func_8e34f(var_37e42, var_6ef19);
                                                                        var_22d81.x = var_15eb4;
                                                                        var_22d81.y = var_0f77b;
                                                                        var_22d81.z = var_6ef19;
                                                                    }
                                                                }
                                                                var_22d81.w = mix(1.0 - var_22d81.w, var_22d81.w, var_ba6b7.x);
                                                                highp vec3 var_7c508 = var_22d81.xyz;
                                                                var_22d81.w = mix(clamp(((0.2125999927520751953125 * var_7c508.x) + (0.715200006961822509765625 * var_7c508.y)) + (0.072200000286102294921875 * var_7c508.z), 0.0, 1.0), var_22d81.w, var_ba6b7.z);
                                                                var_22d81.w = mix(var_22d81.w, 1.0, var_d4970.y);
                                                                highp vec2 var_6be68 = Data_PS[var_d04db].xy;
                                                                highp float var_059a9;
                                                                if (var_6be68.x < var_6be68.y)
                                                                {
                                                                    var_059a9 = var_6be68.x;
                                                                }
                                                                else
                                                                {
                                                                    var_059a9 = var_6be68.y;
                                                                }
                                                                var_41cb3 = var_ba6b7.w * clamp(0.5 - (var_059a9 * (length(v_ScreenNormalPosition.xy - v_Additional.xy) - v_ScreenNormalPosition.z)), 0.0, 1.0);
                                                            }
                                                            else
                                                            {
                                                                var_41cb3 = 1.0;
                                                            }
                                                            var_8dc78 = var_41cb3;
                                                        }
                                                        var_33568 = var_8dc78;
                                                    }
                                                    var_119dc = var_33568;
                                                }
                                                var_44de7 = var_119dc;
                                            }
                                            var_e78af = var_44de7;
                                        }
                                        var_ed456 = var_e78af;
                                    }
                                    var_b4261 = var_ed456;
                                }
                                var_97871 = var_b4261;
                            }
                            var_2ccd6 = var_97871;
                        }
                        var_ddde2 = var_2ccd6;
                    }
                    var_694ba = var_ddde2;
                }
                var_6c060 = var_694ba;
            }
            var_45af2 = var_6c060;
        }
        var_1bfef = var_45af2;
    }
    if ((var_f1761 & 64) != 0)
    {
        highp float var_98402 = var_22d81.w;
        highp vec4 var_01d52 = var_22d81;
        highp vec3 var_da06e = var_01d52.xyz * var_98402;
        var_22d81.x = var_da06e.x;
        var_22d81.y = var_da06e.y;
        var_22d81.z = var_da06e.z;
    }
    var_e6fcd = var_22d81;
    highp float var_49df2;
    if (int(var_4370d.w) == 3)
    {
        var_49df2 = var_e6fcd.w;
    }
    else
    {
        var_49df2 = var_1bfef;
    }
    if (var_49df2 < 0.00390625)
    {
        discard;
    }
    bgfx_FragData0 = vec4(0.0);
}
