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
layout(location = 0) out highp vec4 bgfx_FragColor;
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
    highp vec4 var_eb383 = v_Additional;
    highp vec3 var_a2ee7 = v_ScreenNormalPosition;
    uvec4 var_eb4ac = uvec4(v_VaryingData);
    int var_99696 = int((var_eb4ac.z << 4u) | ((var_eb4ac.y & 240u) >> 4u));
    int var_f473b = int(var_eb4ac.w);
    highp vec4 var_ea3a1 = Data_PS[var_99696];
    int var_fedb0 = var_99696 + 1;
    highp vec4 var_300d7 = Data_PS[var_fedb0];
    int var_d04db = int(var_ea3a1.x);
    int var_f1761 = int(Data_PS[max(0, (var_d04db + (-1)))].y);
    highp vec4 var_8aa00 = Data_PS[var_fedb0];
    highp float var_241aa;
    if (1 == var_f473b)
    {
        var_241aa = clamp(0.5 - (length(v_ScreenNormalPosition.xy - v_Additional.xy) - var_eb383.z), 0.0, 1.0);
    }
    else
    {
        highp float var_736b5;
        if (2 == var_f473b)
        {
            highp float var_f2c71 = length(v_ScreenNormalPosition.xy - v_Additional.xy);
            var_736b5 = clamp(0.5 - (var_f2c71 - var_eb383.z), 0.0, 1.0) * (1.0 - clamp(0.5 - (var_f2c71 - (var_eb383.z - var_eb383.w)), 0.0, 1.0));
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
                        var_8aa00 = vec4(0.0);
                        highp vec4 var_79b72 = Data_PS[var_d04db + 1];
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
                        highp vec2 var_d4b82 = vec2(0.0);
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
                                var_d4b82.x = var_1b6c6 * Data_PS[var_d04db].y;
                                var_d4b82.y = var_1b6c6 * Data_PS[var_d04db].z;
                                var_b2b23 = var_042ad;
                            }
                            else
                            {
                                var_b2b23 = var_2ae5d;
                            }
                            highp vec4 var_d2dc7 = vec4(v_Additional.xy + var_d4b82, 0.0, 0.0);
                            highp vec4 var_9349e = vec4(v_Additional.xy - var_d4b82, 0.0, 0.0);
                            bool var_050eb = var_79b72.z != (-1.0);
                            bool var_f434b;
                            if (!var_050eb)
                            {
                                var_f434b = var_79b72.w != (-1.0);
                            }
                            else
                            {
                                var_f434b = var_050eb;
                            }
                            if (var_f434b)
                            {
                                var_d2dc7.x = clamp(var_eb383.x + var_d4b82.x, var_79b72.x, var_79b72.x + var_79b72.z);
                                var_d2dc7.y = clamp(var_eb383.y + var_d4b82.y, var_79b72.y, var_79b72.y + var_79b72.w);
                                var_9349e.x = clamp(var_eb383.x - var_d4b82.x, var_79b72.x, var_79b72.x + var_79b72.z);
                                var_9349e.y = clamp(var_eb383.y - var_d4b82.y, var_79b72.y, var_79b72.y + var_79b72.w);
                            }
                            highp vec2 var_e88fa = vec2(var_d2dc7.x, 1.0 - var_d2dc7.y);
                            highp float var_7c2cb = var_e88fa.x;
                            highp float var_76ed8 = var_e88fa.y;
                            highp vec2 var_6177c = vec2(var_7c2cb, 1.0 - var_76ed8);
                            var_e88fa = var_6177c;
                            highp vec4 var_8938e = texture(s_txBuffer, vec2(((var_6177c * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_6177c * UVTransform[0].zw) + UVTransform[0].xy).y));
                            highp vec2 var_a6693 = vec2(var_9349e.x, 1.0 - var_9349e.y);
                            highp float var_a90b9 = var_a6693.x;
                            highp float var_497e4 = var_a6693.y;
                            highp vec2 var_2d165 = vec2(var_a90b9, 1.0 - var_497e4);
                            var_a6693 = var_2d165;
                            highp vec4 var_25f9e = texture(s_txBuffer, vec2(((var_2d165 * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_2d165 * UVTransform[0].zw) + UVTransform[0].xy).y));
                            highp vec4 var_186b3;
                            highp vec4 var_9c734;
                            if ((var_f1761 & 2) != 0)
                            {
                                highp vec3 var_a8992 = var_8938e.xyz;
                                highp float var_7a20c;
                                func_b96d4(var_a8992, var_7a20c);
                                highp float var_3806c;
                                func_9b9e1(var_a8992, var_3806c);
                                highp float var_a0e49;
                                func_98fd5(var_a8992, var_a0e49);
                                highp vec3 var_6ca41 = vec3(var_7a20c, var_3806c, var_a0e49);
                                highp vec3 var_ff496 = var_25f9e.xyz;
                                highp float var_67d82;
                                func_b96d4(var_ff496, var_67d82);
                                highp float var_24832;
                                func_9b9e1(var_ff496, var_24832);
                                highp float var_67281;
                                func_98fd5(var_ff496, var_67281);
                                highp vec3 var_4495d = vec3(var_67d82, var_24832, var_67281);
                                var_9c734 = vec4(var_4495d.x, var_4495d.y, var_4495d.z, var_25f9e.w);
                                var_186b3 = vec4(var_6ca41.x, var_6ca41.y, var_6ca41.z, var_8938e.w);
                            }
                            else
                            {
                                highp vec4 var_3d9ef;
                                highp vec4 var_769ac;
                                if ((var_f1761 & 16) != 0)
                                {
                                    highp vec3 var_b0d06 = var_8938e.xyz;
                                    highp float var_66b11;
                                    func_438fb(var_b0d06, var_66b11);
                                    highp float var_383e0;
                                    func_038c3(var_b0d06, var_383e0);
                                    highp float var_aade2;
                                    func_8e34f(var_b0d06, var_aade2);
                                    highp vec3 var_558eb = vec3(var_66b11, var_383e0, var_aade2);
                                    highp vec3 var_bbf1f = var_25f9e.xyz;
                                    highp float var_4d0f9;
                                    func_438fb(var_bbf1f, var_4d0f9);
                                    highp float var_2545b;
                                    func_038c3(var_bbf1f, var_2545b);
                                    highp float var_39b80;
                                    func_8e34f(var_bbf1f, var_39b80);
                                    highp vec3 var_58a86 = vec3(var_4d0f9, var_2545b, var_39b80);
                                    var_769ac = vec4(var_58a86.x, var_58a86.y, var_58a86.z, var_25f9e.w);
                                    var_3d9ef = vec4(var_558eb.x, var_558eb.y, var_558eb.z, var_8938e.w);
                                }
                                else
                                {
                                    var_769ac = var_25f9e;
                                    var_3d9ef = var_8938e;
                                }
                                var_9c734 = var_769ac;
                                var_186b3 = var_3d9ef;
                            }
                            var_8aa00 += ((var_186b3 + var_9c734) * var_b2b23);
                        }
                        var_ddde2 = var_300d7.w;
                    }
                    else
                    {
                        highp float var_df5f8;
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
                            highp vec4 var_73df2 = texture(s_txBuffer, vec2(((var_d2bf0 * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_d2bf0 * UVTransform[0].zw) + UVTransform[0].xy).y));
                            if ((var_f1761 & 2) != 0)
                            {
                                highp vec3 var_be626 = var_73df2.xyz;
                                highp float var_1df72;
                                func_b96d4(var_be626, var_1df72);
                                highp float var_268d3;
                                func_9b9e1(var_be626, var_268d3);
                                highp float var_6b72d;
                                func_98fd5(var_be626, var_6b72d);
                                highp vec3 var_08b75 = vec3(var_1df72, var_268d3, var_6b72d);
                                var_73df2 = vec4(var_08b75.x, var_08b75.y, var_08b75.z, var_73df2.w);
                            }
                            else
                            {
                                if ((var_f1761 & 16) != 0)
                                {
                                    highp vec3 var_7bca4 = var_73df2.xyz;
                                    highp float var_eed46;
                                    func_438fb(var_7bca4, var_eed46);
                                    highp float var_c434e;
                                    func_038c3(var_7bca4, var_c434e);
                                    highp float var_3c0b0;
                                    func_8e34f(var_7bca4, var_3c0b0);
                                    highp vec3 var_51794 = vec3(var_eed46, var_c434e, var_3c0b0);
                                    var_73df2 = vec4(var_51794.x, var_51794.y, var_51794.z, var_73df2.w);
                                }
                            }
                            highp float var_6215c = var_73df2.w;
                            highp float var_598f3 = max(var_6215c, 9.9999997473787516355514526367188e-06);
                            highp vec4 var_176b1 = var_73df2;
                            highp vec4 var_729fe = vec4(var_176b1.xyz / vec3(var_598f3), var_598f3);
                            var_73df2 = var_729fe;
                            var_8aa00.x = dot(var_729fe, Data_PS[var_d04db + 1]);
                            var_8aa00.y = dot(var_729fe, Data_PS[var_d04db + 2]);
                            var_8aa00.z = dot(var_729fe, Data_PS[var_d04db + 3]);
                            var_8aa00.w = dot(var_729fe, Data_PS[var_d04db + 4]);
                            highp vec4 var_ea70f = var_8aa00;
                            highp vec4 var_288d5 = var_ea70f + Data_PS[var_d04db + 5];
                            var_8aa00 = var_288d5;
                            highp vec3 var_5ad70 = var_288d5.xyz;
                            var_8aa00.w = mix(clamp(((0.2125999927520751953125 * var_5ad70.x) + (0.715200006961822509765625 * var_5ad70.y)) + (0.072200000286102294921875 * var_5ad70.z), 0.0, 1.0), var_8aa00.w, var_300d7.z);
                            highp float var_9f710 = var_8aa00.w;
                            var_8aa00.w = 1.0;
                            var_df5f8 = (var_9f710 * var_300d7.w) * clamp(var_eb383.z, 0.0, 1.0);
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
                                highp vec3 var_cc3dd = var_0a617 - vec3(0.0625, 0.5, 0.5);
                                var_9791e = var_cc3dd;
                                highp vec3 var_2610e = transpose(mat3(vec3(1.164000034332275390625, 0.0, 1.5959999561309814453125), vec3(1.164000034332275390625, -0.3910000026226043701171875, -0.813000023365020751953125), vec3(1.164000034332275390625, 2.0179998874664306640625, 0.0))) * var_cc3dd;
                                highp vec3 var_04011;
                                if ((var_f1761 & 2) != 0)
                                {
                                    highp vec3 var_176d2 = var_2610e;
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
                                        highp vec3 var_b5340 = var_2610e;
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
                                        var_c1cae = var_2610e;
                                    }
                                    var_04011 = var_c1cae;
                                }
                                var_8aa00 = vec4(var_04011, 1.0);
                                highp float var_90d82;
                                if (12 == var_f473b)
                                {
                                    highp vec2 var_5506d = v_Additional.xy;
                                    highp float var_68bed = var_5506d.x;
                                    highp float var_3ba70 = var_5506d.y;
                                    highp vec2 var_32c93 = vec2(var_68bed, 1.0 - var_3ba70);
                                    var_5506d = var_32c93;
                                    var_90d82 = (var_300d7.w * clamp(var_eb383.z, 0.0, 1.0)) * texture(s_txBuffer3, vec2(((var_32c93 * UVTransform[3].zw) + UVTransform[3].xy).x, 1.0 - ((var_32c93 * UVTransform[3].zw) + UVTransform[3].xy).y)).x;
                                }
                                else
                                {
                                    var_90d82 = var_300d7.w;
                                }
                                var_97871 = var_90d82;
                            }
                            else
                            {
                                highp float var_2183b;
                                if (11 == var_f473b)
                                {
                                    var_2183b = clamp((1.0 - clamp(abs(dot(v_Additional.xyz, vec3(v_ScreenNormalPosition.xy, 1.0))), 0.0, 1.0)) * var_eb383.w, 0.0, 1.0);
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
                                        var_8aa00 = mix(Data_PS[var_d04db + 1], Data_PS[var_fedb0], vec4(clamp(var_2f2fd - (var_31273 + var_07a02), 0.0, 1.0))) * clamp(var_2f2fd - max(0.0, var_31273 - var_07a02), 0.0, 1.0);
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
                                                var_8aa00 = texture(s_txBuffer, vec2(((var_82997 * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_82997 * UVTransform[0].zw) + UVTransform[0].xy).y));
                                            }
                                            else
                                            {
                                                highp vec2 var_12bb9 = vec2(var_b884f.x, 1.0 - var_b884f.y);
                                                highp float var_f7f43 = var_12bb9.x;
                                                highp float var_731de = var_12bb9.y;
                                                highp vec2 var_cc6ff = vec2(var_f7f43, 1.0 - var_731de);
                                                var_12bb9 = var_cc6ff;
                                                var_8aa00 = texture(s_txBuffer, vec2(((var_cc6ff * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_cc6ff * UVTransform[0].zw) + UVTransform[0].xy).y));
                                            }
                                            if ((var_f1761 & 2) != 0)
                                            {
                                                highp vec3 var_88946 = var_8aa00.xyz;
                                                highp float var_68569;
                                                func_b96d4(var_88946, var_68569);
                                                highp float var_d242f;
                                                func_9b9e1(var_88946, var_d242f);
                                                highp float var_071ac;
                                                func_98fd5(var_88946, var_071ac);
                                                highp vec3 var_02fa6 = vec3(var_68569, var_d242f, var_071ac);
                                                var_8aa00 = vec4(var_02fa6.x, var_02fa6.y, var_02fa6.z, var_8aa00.w);
                                            }
                                            else
                                            {
                                                if ((var_f1761 & 16) != 0)
                                                {
                                                    highp vec3 var_e5842 = var_8aa00.xyz;
                                                    highp float var_7e2c4;
                                                    func_438fb(var_e5842, var_7e2c4);
                                                    highp float var_e8793;
                                                    func_038c3(var_e5842, var_e8793);
                                                    highp float var_56d32;
                                                    func_8e34f(var_e5842, var_56d32);
                                                    highp vec3 var_7ac79 = vec3(var_7e2c4, var_e8793, var_56d32);
                                                    var_8aa00 = vec4(var_7ac79.x, var_7ac79.y, var_7ac79.z, var_8aa00.w);
                                                }
                                            }
                                            var_8aa00.w = mix(var_8aa00.w, 1.0 - var_8aa00.w, float((int(var_300d7.x) & 1) != 0));
                                            highp vec3 var_b21cc = var_8aa00.xyz;
                                            var_8aa00.w = mix(clamp(((0.2125999927520751953125 * var_b21cc.x) + (0.715200006961822509765625 * var_b21cc.y)) + (0.072200000286102294921875 * var_b21cc.z), 0.0, 1.0), var_8aa00.w, var_300d7.z);
                                            var_8aa00.w = mix(var_8aa00.w, 1.0, float((int(var_300d7.x) & 2) != 0));
                                            highp vec2 var_9570c = (v_ScreenNormalPosition.xy - v_Additional.xy) / vec2(var_a2ee7.z, var_ea3a1.y);
                                            highp vec2 var_c88db = var_9570c;
                                            highp vec2 var_b3452 = dFdx(var_9570c);
                                            highp vec2 var_5297e = dFdy(var_9570c);
                                            highp vec2 var_78729 = vec2(((2.0 * var_c88db.x) * var_b3452.x) + ((2.0 * var_c88db.y) * var_b3452.y), ((2.0 * var_c88db.x) * var_5297e.x) + ((2.0 * var_c88db.y) * var_5297e.y));
                                            var_e78af = var_300d7.w * clamp(0.5 - ((dot(var_9570c, var_9570c) - 1.0) * inversesqrt(max(dot(var_78729, var_78729), 9.9999997473787516355514526367188e-05))), 0.0, 1.0);
                                        }
                                        else
                                        {
                                            highp float var_6143b;
                                            if (var_f473b == 33)
                                            {
                                                highp vec2 var_25a40 = Data_PS[var_d04db].xy;
                                                highp float var_ca1ef;
                                                if (var_25a40.x < var_25a40.y)
                                                {
                                                    var_ca1ef = var_25a40.x;
                                                }
                                                else
                                                {
                                                    var_ca1ef = var_25a40.y;
                                                }
                                                highp vec2 var_df549 = (Data_PS[var_d04db + 1].zw * vec2(fract(v_Additional.zw).x, 1.0 - fract(v_Additional.zw).y)) + Data_PS[var_d04db + 1].xy;
                                                highp float var_04de2 = var_df549.x;
                                                highp float var_1a3f2 = var_df549.y;
                                                highp vec2 var_af99f = vec2(var_04de2, 1.0 - var_1a3f2);
                                                var_df549 = var_af99f;
                                                var_8aa00 = texture(s_txBuffer, vec2(((var_af99f * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_af99f * UVTransform[0].zw) + UVTransform[0].xy).y));
                                                if ((var_f1761 & 2) != 0)
                                                {
                                                    highp vec3 var_f2f08 = var_8aa00.xyz;
                                                    highp float var_1d1ae;
                                                    func_b96d4(var_f2f08, var_1d1ae);
                                                    highp float var_7f7cf;
                                                    func_9b9e1(var_f2f08, var_7f7cf);
                                                    highp float var_01da6;
                                                    func_98fd5(var_f2f08, var_01da6);
                                                    highp vec3 var_87004 = vec3(var_1d1ae, var_7f7cf, var_01da6);
                                                    var_8aa00 = vec4(var_87004.x, var_87004.y, var_87004.z, var_8aa00.w);
                                                }
                                                else
                                                {
                                                    if ((var_f1761 & 16) != 0)
                                                    {
                                                        highp vec3 var_e3e93 = var_8aa00.xyz;
                                                        highp float var_fb3ec;
                                                        func_438fb(var_e3e93, var_fb3ec);
                                                        highp float var_4f4b2;
                                                        func_038c3(var_e3e93, var_4f4b2);
                                                        highp float var_acbf9;
                                                        func_8e34f(var_e3e93, var_acbf9);
                                                        highp vec3 var_ce391 = vec3(var_fb3ec, var_4f4b2, var_acbf9);
                                                        var_8aa00 = vec4(var_ce391.x, var_ce391.y, var_ce391.z, var_8aa00.w);
                                                    }
                                                }
                                                var_8aa00.w = mix(1.0 - var_8aa00.w, var_8aa00.w, var_300d7.x);
                                                highp vec3 var_b5c5f = var_8aa00.xyz;
                                                var_8aa00.w = mix(clamp(((0.2125999927520751953125 * var_b5c5f.x) + (0.715200006961822509765625 * var_b5c5f.y)) + (0.072200000286102294921875 * var_b5c5f.z), 0.0, 1.0), var_8aa00.w, var_300d7.z);
                                                var_8aa00.w = mix(var_8aa00.w, 1.0, var_ea3a1.y);
                                                var_6143b = var_300d7.w * clamp(0.5 - (var_ca1ef * (length(v_ScreenNormalPosition.xy - v_Additional.xy) - var_a2ee7.z)), 0.0, 1.0);
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
                                                    var_8aa00 = mix(Data_PS[var_d04db + 1], Data_PS[var_fedb0], vec4(smoothstep(var_23cd3 - var_5743b.x, var_23cd3 + var_5743b.x, var_26b24))) * var_fd049;
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
                                                        highp vec3 var_1d2f1 = texture(s_txBuffer3, vec2(((var_e31cd * UVTransform[3].zw) + UVTransform[3].xy).x, 1.0 - ((var_e31cd * UVTransform[3].zw) + UVTransform[3].xy).y)).xyz;
                                                        var_8aa00 = Data_PS[var_fedb0] * smoothstep(0.5 - var_eb383.z, 0.5 + var_eb383.z, max(min(var_1d2f1.x, var_1d2f1.y), min(max(var_1d2f1.x, var_1d2f1.y), var_1d2f1.z)));
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
                                                            var_8aa00 = mix(Data_PS[var_d04db + 1], Data_PS[var_fedb0], vec4(smoothstep(var_60d5d - var_714ab.x, var_60d5d + var_714ab.x, var_bc6ed))) * var_7f653;
                                                            var_8dc78 = 1.0;
                                                        }
                                                        else
                                                        {
                                                            highp float var_772b6;
                                                            if (var_f473b == 31)
                                                            {
                                                                highp vec2 var_ac8fb = v_Additional.zw;
                                                                highp vec2 var_5f747 = vec2(var_ac8fb.x, 1.0 - var_ac8fb.y);
                                                                highp float var_3545c = var_5f747.x;
                                                                highp float var_e72f9 = var_5f747.y;
                                                                highp vec2 var_eaf6c = vec2(var_3545c, 1.0 - var_e72f9);
                                                                var_5f747 = var_eaf6c;
                                                                var_8aa00 = texture(s_txBuffer, vec2(((var_eaf6c * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_eaf6c * UVTransform[0].zw) + UVTransform[0].xy).y));
                                                                if ((var_f1761 & 2) != 0)
                                                                {
                                                                    highp vec3 var_14c63 = var_8aa00.xyz;
                                                                    highp float var_ff9f9;
                                                                    func_b96d4(var_14c63, var_ff9f9);
                                                                    highp float var_a6fa5;
                                                                    func_9b9e1(var_14c63, var_a6fa5);
                                                                    highp float var_7d59b;
                                                                    func_98fd5(var_14c63, var_7d59b);
                                                                    highp vec3 var_c5d9b = vec3(var_ff9f9, var_a6fa5, var_7d59b);
                                                                    var_8aa00 = vec4(var_c5d9b.x, var_c5d9b.y, var_c5d9b.z, var_8aa00.w);
                                                                }
                                                                else
                                                                {
                                                                    if ((var_f1761 & 16) != 0)
                                                                    {
                                                                        highp vec3 var_37e42 = var_8aa00.xyz;
                                                                        highp float var_0303e;
                                                                        func_438fb(var_37e42, var_0303e);
                                                                        highp float var_eebe3;
                                                                        func_038c3(var_37e42, var_eebe3);
                                                                        highp float var_dd202;
                                                                        func_8e34f(var_37e42, var_dd202);
                                                                        highp vec3 var_3c09e = vec3(var_0303e, var_eebe3, var_dd202);
                                                                        var_8aa00 = vec4(var_3c09e.x, var_3c09e.y, var_3c09e.z, var_8aa00.w);
                                                                    }
                                                                }
                                                                var_8aa00.w = mix(1.0 - var_8aa00.w, var_8aa00.w, var_300d7.x);
                                                                highp vec3 var_7c508 = var_8aa00.xyz;
                                                                var_8aa00.w = mix(clamp(((0.2125999927520751953125 * var_7c508.x) + (0.715200006961822509765625 * var_7c508.y)) + (0.072200000286102294921875 * var_7c508.z), 0.0, 1.0), var_8aa00.w, var_300d7.z);
                                                                var_8aa00.w = mix(var_8aa00.w, 1.0, var_ea3a1.y);
                                                                highp vec2 var_6be68 = Data_PS[var_d04db].xy;
                                                                highp float var_40575;
                                                                if (var_6be68.x < var_6be68.y)
                                                                {
                                                                    var_40575 = var_6be68.x;
                                                                }
                                                                else
                                                                {
                                                                    var_40575 = var_6be68.y;
                                                                }
                                                                var_772b6 = var_300d7.w * clamp(0.5 - (var_40575 * (length(v_ScreenNormalPosition.xy - v_Additional.xy) - var_a2ee7.z)), 0.0, 1.0);
                                                            }
                                                            else
                                                            {
                                                                var_772b6 = 1.0;
                                                            }
                                                            var_8dc78 = var_772b6;
                                                        }
                                                        var_33568 = var_8dc78;
                                                    }
                                                    var_119dc = var_33568;
                                                }
                                                var_6143b = var_119dc;
                                            }
                                            var_e78af = var_6143b;
                                        }
                                        var_ed456 = var_e78af;
                                    }
                                    var_2183b = var_ed456;
                                }
                                var_97871 = var_2183b;
                            }
                            var_df5f8 = var_97871;
                        }
                        var_ddde2 = var_df5f8;
                    }
                    var_694ba = var_ddde2;
                }
                var_6c060 = var_694ba;
            }
            var_736b5 = var_6c060;
        }
        var_241aa = var_736b5;
    }
    if ((var_f1761 & 64) != 0)
    {
        highp vec3 var_74485 = var_8aa00.xyz * var_8aa00.w;
        var_8aa00 = vec4(var_74485.x, var_74485.y, var_74485.z, var_8aa00.w);
    }
    var_e6fcd = var_8aa00;
    highp float var_49df2;
    if (int(var_4370d.w) == 3)
    {
        var_49df2 = var_e6fcd.w;
    }
    else
    {
        var_49df2 = var_241aa;
    }
    if (var_49df2 < 0.00390625)
    {
        discard;
    }
    bgfx_FragColor = vec4(0.0);
}
