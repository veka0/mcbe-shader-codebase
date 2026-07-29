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
* - uniform lowp sampler2D s_txBuffer4;
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
uniform highp sampler2D s_txBuffer;
uniform highp vec4 Data_PS[128];
uniform highp vec4 UVTransform[5];
in highp vec4 v_Additional;
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
void func_011ac(inout highp float arg_6b2b2, inout highp float arg_ca2fb) {
    if (arg_6b2b2 <= 0.003130800090730190277099609375)
    {
        arg_ca2fb = arg_6b2b2 * 12.9200000762939453125;
        return;
    }
    arg_ca2fb = (1.05499994754791259765625 * pow(arg_6b2b2, 0.4166666567325592041015625)) - 0.054999999701976776123046875;
}
void func_4a7ec(inout highp vec4 arg_ad1a5, inout highp vec4 arg_534f4, inout highp float arg_59019) {
    uvec4 loc_36dcc = uvec4(v_VaryingData);
    int loc_4ef2a = int((loc_36dcc.z << 4u) | ((loc_36dcc.y & 240u) >> 4u));
    int loc_1d698 = int(loc_36dcc.w);
    highp vec4 loc_d549b = Data_PS[loc_4ef2a];
    int loc_b8d33 = loc_4ef2a + 1;
    highp vec4 loc_f9d71 = Data_PS[loc_b8d33];
    int loc_2051e = int(loc_d549b.x);
    int loc_6aa44 = max(0, (loc_2051e + (-1)));
    int loc_026da = int(Data_PS[loc_6aa44].y);
    int loc_256e2 = int(Data_PS[loc_6aa44].z);
    arg_ad1a5 = Data_PS[loc_b8d33];
    highp float loc_d1818;
    highp float loc_39dd0;
    if (0 == loc_1d698)
    {
        loc_39dd0 = min(1.0, arg_534f4.z * arg_534f4.w);
        loc_d1818 = 1.0;
    }
    else
    {
        highp float loc_df533;
        highp float loc_1387f;
        if (3 == loc_1d698)
        {
            highp vec2 loc_2ab1e = v_Additional.xy;
            highp vec4 loc_52c3c = Data_PS[loc_2051e];
            bool loc_3afc1 = loc_52c3c.z != (-1.0);
            bool loc_30475;
            if (!loc_3afc1)
            {
                loc_30475 = loc_52c3c.w != (-1.0);
            }
            else
            {
                loc_30475 = loc_3afc1;
            }
            if (loc_30475)
            {
                loc_2ab1e.x = clamp(arg_534f4.x, loc_52c3c.x, loc_52c3c.x + loc_52c3c.z);
                loc_2ab1e.y = clamp(arg_534f4.y, loc_52c3c.y, loc_52c3c.y + loc_52c3c.w);
            }
            highp vec2 loc_3ebfa = vec2(loc_2ab1e.x, 1.0 - loc_2ab1e.y);
            highp float loc_74cec = loc_3ebfa.x;
            highp float loc_83bc9 = loc_3ebfa.y;
            highp vec2 loc_e145a = vec2(loc_74cec, 1.0 - loc_83bc9);
            loc_3ebfa = loc_e145a;
            arg_ad1a5 = texture(s_txBuffer, vec2(((loc_e145a * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((loc_e145a * UVTransform[0].zw) + UVTransform[0].xy).y));
            if ((loc_026da & 2) != 0)
            {
                highp vec3 loc_4f09f = arg_ad1a5.xyz;
                highp float loc_75c31;
                func_b96d4(loc_4f09f, loc_75c31);
                highp float loc_1c9d4;
                func_9b9e1(loc_4f09f, loc_1c9d4);
                highp float loc_1ac3e;
                func_98fd5(loc_4f09f, loc_1ac3e);
                highp vec3 loc_4de2d = vec3(loc_75c31, loc_1c9d4, loc_1ac3e);
                arg_ad1a5 = vec4(loc_4de2d.x, loc_4de2d.y, loc_4de2d.z, arg_ad1a5.w);
            }
            else
            {
                if ((loc_026da & 16) != 0)
                {
                    highp vec3 loc_1231c = arg_ad1a5.xyz;
                    highp float loc_a2c18;
                    func_438fb(loc_1231c, loc_a2c18);
                    highp float loc_d3225;
                    func_038c3(loc_1231c, loc_d3225);
                    highp float loc_c6192;
                    func_8e34f(loc_1231c, loc_c6192);
                    highp vec3 loc_001c6 = vec3(loc_a2c18, loc_d3225, loc_c6192);
                    arg_ad1a5 = vec4(loc_001c6.x, loc_001c6.y, loc_001c6.z, arg_ad1a5.w);
                }
            }
            arg_ad1a5.w = mix(1.0 - arg_ad1a5.w, arg_ad1a5.w, loc_f9d71.x);
            highp vec3 loc_92be8 = arg_ad1a5.xyz;
            arg_ad1a5.w = mix(((0.2125999927520751953125 * loc_92be8.x) + (0.715200006961822509765625 * loc_92be8.y)) + (0.072200000286102294921875 * loc_92be8.z), arg_ad1a5.w, loc_f9d71.z);
            loc_1387f = loc_f9d71.w * clamp(arg_534f4.z, 0.0, 1.0);
            loc_df533 = loc_f9d71.z;
        }
        else
        {
            highp float loc_b5f11;
            highp float loc_1b304;
            if (17 == loc_1d698)
            {
                if ((loc_026da & 8) != 0)
                {
                    highp vec2 loc_b985e = v_Additional.xy;
                    highp float loc_1ce3f = loc_b985e.x;
                    highp float loc_eb157 = loc_b985e.y;
                    highp vec2 loc_cc917 = vec2(loc_1ce3f, 1.0 - loc_eb157);
                    loc_b985e = loc_cc917;
                    arg_ad1a5 = texture(s_txBuffer1, vec2(((loc_cc917 * UVTransform[1].zw) + UVTransform[1].xy).x, 1.0 - ((loc_cc917 * UVTransform[1].zw) + UVTransform[1].xy).y));
                    highp float loc_561f9;
                    if (loc_256e2 != (-1))
                    {
                        highp vec4 loc_70976 = arg_ad1a5;
                        highp vec4 loc_c5359 = vec4(0.0);
                        highp float loc_5601f = loc_70976.w;
                        highp float loc_a3b43 = max(loc_5601f, 9.9999997473787516355514526367188e-06);
                        highp vec4 loc_72edd = vec4(arg_ad1a5.xyz / vec3(loc_a3b43), loc_a3b43);
                        loc_70976 = loc_72edd;
                        loc_c5359.x = dot(loc_72edd, Data_PS[loc_256e2]);
                        loc_c5359.y = dot(loc_72edd, Data_PS[loc_256e2 + 1]);
                        loc_c5359.z = dot(loc_72edd, Data_PS[loc_256e2 + 2]);
                        loc_c5359.w = dot(loc_72edd, Data_PS[loc_256e2 + 3]);
                        loc_c5359 += Data_PS[loc_256e2 + 4];
                        loc_c5359.w = loc_c5359.w;
                        highp float loc_220d1 = loc_c5359.w;
                        loc_c5359.w = 1.0;
                        arg_ad1a5 = loc_c5359;
                        loc_561f9 = loc_f9d71.w * loc_220d1;
                    }
                    else
                    {
                        loc_561f9 = loc_f9d71.w;
                    }
                    arg_59019 = loc_561f9;
                    return;
                }
                else
                {
                    highp vec2 loc_3860d = v_Additional.xy;
                    highp float loc_ca5f3 = loc_3860d.x;
                    highp float loc_aff75 = loc_3860d.y;
                    highp vec2 loc_da2fb = vec2(loc_ca5f3, 1.0 - loc_aff75);
                    loc_3860d = loc_da2fb;
                    highp vec4 loc_8137b = texture(s_txBuffer1, vec2(((loc_da2fb * UVTransform[1].zw) + UVTransform[1].xy).x, 1.0 - ((loc_da2fb * UVTransform[1].zw) + UVTransform[1].xy).y));
                    highp vec3 loc_e6d23 = Data_PS[loc_b8d33].xyz;
                    highp float loc_b9e21 = ((0.2125999927520751953125 * loc_e6d23.x) + (0.715200006961822509765625 * loc_e6d23.y)) + (0.072200000286102294921875 * loc_e6d23.z);
                    highp float loc_acca2;
                    if ((loc_026da & 1) != 0)
                    {
                        highp float loc_6fbe6;
                        func_011ac(loc_b9e21, loc_6fbe6);
                        loc_acca2 = loc_6fbe6;
                    }
                    else
                    {
                        loc_acca2 = loc_b9e21;
                    }
                    arg_ad1a5 = Data_PS[loc_b8d33] * pow(abs(loc_8137b.x), max(abs(1.4500000476837158203125 - loc_acca2), 9.9999997473787516355514526367188e-05));
                }
                loc_1b304 = 1.0;
                loc_b5f11 = 1.0;
            }
            else
            {
                highp float loc_78c7e;
                highp float loc_e4a1b;
                if (18 == loc_1d698)
                {
                    highp vec2 loc_20fff = v_Additional.xy;
                    highp float loc_65729 = loc_20fff.x;
                    highp float loc_6a9b9 = loc_20fff.y;
                    highp vec2 loc_83fdd = vec2(loc_65729, 1.0 - loc_6a9b9);
                    loc_20fff = loc_83fdd;
                    highp vec4 loc_0e4a1 = texture(s_txBuffer2, vec2(((loc_83fdd * UVTransform[2].zw) + UVTransform[2].xy).x, 1.0 - ((loc_83fdd * UVTransform[2].zw) + UVTransform[2].xy).y));
                    highp vec3 loc_74724 = Data_PS[loc_b8d33].xyz;
                    highp float loc_2dc04 = ((0.2125999927520751953125 * loc_74724.x) + (0.715200006961822509765625 * loc_74724.y)) + (0.072200000286102294921875 * loc_74724.z);
                    highp float loc_6fa9f;
                    if ((loc_026da & 1) != 0)
                    {
                        highp float loc_cde2c;
                        func_011ac(loc_2dc04, loc_cde2c);
                        loc_6fa9f = loc_cde2c;
                    }
                    else
                    {
                        loc_6fa9f = loc_2dc04;
                    }
                    arg_ad1a5 = Data_PS[loc_b8d33] * pow(abs(smoothstep((-0.501960813999176025390625) / arg_534f4.z, 0.501960813999176025390625 / arg_534f4.z, (loc_0e4a1.x * 7.96875) - 3.984375)), max(abs(1.4500000476837158203125 - loc_6fa9f), 9.9999997473787516355514526367188e-05));
                    loc_e4a1b = 1.0;
                    loc_78c7e = 1.0;
                }
                else
                {
                    highp float loc_aef2c;
                    highp float loc_a06ec;
                    if (22 == loc_1d698)
                    {
                        highp vec2 loc_d32a2 = v_Additional.xy;
                        highp float loc_0587e = loc_d32a2.x;
                        highp float loc_347fa = loc_d32a2.y;
                        highp vec2 loc_f807e = vec2(loc_0587e, 1.0 - loc_347fa);
                        loc_d32a2 = loc_f807e;
                        highp vec4 loc_b664d = texture(s_txBuffer2, vec2(((loc_f807e * UVTransform[2].zw) + UVTransform[2].xy).x, 1.0 - ((loc_f807e * UVTransform[2].zw) + UVTransform[2].xy).y));
                        highp vec3 loc_f1b10 = Data_PS[loc_b8d33].xyz;
                        highp float loc_36ed2 = ((0.2125999927520751953125 * loc_f1b10.x) + (0.715200006961822509765625 * loc_f1b10.y)) + (0.072200000286102294921875 * loc_f1b10.z);
                        highp float loc_fcac9;
                        if ((loc_026da & 1) != 0)
                        {
                            highp float loc_742fc;
                            func_011ac(loc_36ed2, loc_742fc);
                            loc_fcac9 = loc_742fc;
                        }
                        else
                        {
                            loc_fcac9 = loc_36ed2;
                        }
                        arg_ad1a5 = Data_PS[loc_b8d33] * pow(abs(smoothstep(0.5 - arg_534f4.z, 0.5 + arg_534f4.z, loc_b664d.x)), max(abs(1.4500000476837158203125 - loc_fcac9), 9.9999997473787516355514526367188e-05));
                        loc_a06ec = 1.0;
                        loc_aef2c = 1.0;
                    }
                    else
                    {
                        highp float loc_4aa8a;
                        highp float loc_c36b4;
                        if (30 == loc_1d698)
                        {
                            highp vec2 loc_d7024 = v_Additional.xy;
                            highp float loc_7c2cb = loc_d7024.x;
                            highp float loc_76ed8 = loc_d7024.y;
                            highp vec2 loc_66ab2 = vec2(loc_7c2cb, 1.0 - loc_76ed8);
                            loc_d7024 = loc_66ab2;
                            loc_c36b4 = texture(s_txBuffer, vec2(((loc_66ab2 * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((loc_66ab2 * UVTransform[0].zw) + UVTransform[0].xy).y)).x;
                            loc_4aa8a = 1.0;
                        }
                        else
                        {
                            highp float loc_54d5f;
                            highp float loc_5b470;
                            if (34 == loc_1d698)
                            {
                                highp vec2 loc_00f4e = (Data_PS[loc_b8d33].zw * vec2(fract(v_Additional.xy).x, 1.0 - fract(v_Additional.xy).y)) + Data_PS[loc_b8d33].xy;
                                highp float loc_7bb88 = loc_00f4e.x;
                                highp float loc_02a1a = loc_00f4e.y;
                                highp vec2 loc_47f6e = vec2(loc_7bb88, 1.0 - loc_02a1a);
                                loc_00f4e = loc_47f6e;
                                arg_ad1a5 = texture(s_txBuffer, vec2(((loc_47f6e * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((loc_47f6e * UVTransform[0].zw) + UVTransform[0].xy).y));
                                if ((loc_026da & 2) != 0)
                                {
                                    highp vec3 loc_b0d06 = arg_ad1a5.xyz;
                                    highp float loc_66b11;
                                    func_b96d4(loc_b0d06, loc_66b11);
                                    highp float loc_383e0;
                                    func_9b9e1(loc_b0d06, loc_383e0);
                                    highp float loc_aade2;
                                    func_98fd5(loc_b0d06, loc_aade2);
                                    highp vec3 loc_72c9d = vec3(loc_66b11, loc_383e0, loc_aade2);
                                    arg_ad1a5 = vec4(loc_72c9d.x, loc_72c9d.y, loc_72c9d.z, arg_ad1a5.w);
                                }
                                else
                                {
                                    if ((loc_026da & 16) != 0)
                                    {
                                        highp vec3 loc_b55ea = arg_ad1a5.xyz;
                                        highp float loc_1f68c;
                                        func_438fb(loc_b55ea, loc_1f68c);
                                        highp float loc_5ed73;
                                        func_038c3(loc_b55ea, loc_5ed73);
                                        highp float loc_1c5b0;
                                        func_8e34f(loc_b55ea, loc_1c5b0);
                                        highp vec3 loc_29eec = vec3(loc_1f68c, loc_5ed73, loc_1c5b0);
                                        arg_ad1a5 = vec4(loc_29eec.x, loc_29eec.y, loc_29eec.z, arg_ad1a5.w);
                                    }
                                }
                                highp float loc_a6166;
                                if ((int(loc_d549b.y) & 1) != 0)
                                {
                                    loc_a6166 = 1.0 - arg_ad1a5.w;
                                }
                                else
                                {
                                    loc_a6166 = arg_ad1a5.w;
                                }
                                arg_ad1a5.w = loc_a6166;
                                highp float loc_d5391;
                                if ((int(loc_d549b.y) & 4) != 0)
                                {
                                    highp vec3 loc_cb1ef = arg_ad1a5.xyz;
                                    loc_d5391 = clamp(((0.2125999927520751953125 * loc_cb1ef.x) + (0.715200006961822509765625 * loc_cb1ef.y)) + (0.072200000286102294921875 * loc_cb1ef.z), 0.0, 1.0);
                                }
                                else
                                {
                                    loc_d5391 = arg_ad1a5.w;
                                }
                                arg_ad1a5.w = loc_d5391;
                                highp float loc_a8c62;
                                if ((int(loc_d549b.y) & 2) != 0)
                                {
                                    loc_a8c62 = 1.0;
                                }
                                else
                                {
                                    loc_a8c62 = arg_ad1a5.w;
                                }
                                arg_ad1a5.w = loc_a8c62;
                                loc_5b470 = arg_534f4.w * clamp(arg_534f4.z, 0.0, 1.0);
                                loc_54d5f = ((int(loc_d549b.y) & 4) != 0) ? 0.0 : 1.0;
                            }
                            else
                            {
                                loc_5b470 = 1.0;
                                loc_54d5f = 1.0;
                            }
                            loc_c36b4 = loc_5b470;
                            loc_4aa8a = loc_54d5f;
                        }
                        loc_a06ec = loc_c36b4;
                        loc_aef2c = loc_4aa8a;
                    }
                    loc_e4a1b = loc_a06ec;
                    loc_78c7e = loc_aef2c;
                }
                loc_1b304 = loc_e4a1b;
                loc_b5f11 = loc_78c7e;
            }
            loc_1387f = loc_1b304;
            loc_df533 = loc_b5f11;
        }
        loc_39dd0 = loc_1387f;
        loc_d1818 = loc_df533;
    }
    if ((loc_026da & 64) != 0)
    {
        highp vec3 loc_6d9b9 = arg_ad1a5.xyz * arg_ad1a5.w;
        arg_ad1a5 = vec4(loc_6d9b9.x, loc_6d9b9.y, loc_6d9b9.z, arg_ad1a5.w);
    }
    highp float loc_96834;
    if (loc_256e2 != (-1))
    {
        highp vec4 loc_c092d = arg_ad1a5;
        highp vec4 loc_71579 = vec4(0.0);
        highp float loc_855af = loc_c092d.w;
        highp float loc_13d7c = max(loc_855af, 9.9999997473787516355514526367188e-06);
        highp vec4 loc_4647f = vec4(arg_ad1a5.xyz / vec3(loc_13d7c), loc_13d7c);
        loc_c092d = loc_4647f;
        loc_71579.x = dot(loc_4647f, Data_PS[loc_256e2]);
        loc_71579.y = dot(loc_4647f, Data_PS[loc_256e2 + 1]);
        loc_71579.z = dot(loc_4647f, Data_PS[loc_256e2 + 2]);
        loc_71579.w = dot(loc_4647f, Data_PS[loc_256e2 + 3]);
        highp vec4 loc_80f8e = loc_71579;
        highp vec4 loc_1d7c0 = loc_80f8e + Data_PS[loc_256e2 + 4];
        loc_71579 = loc_1d7c0;
        highp vec3 loc_ff254 = loc_1d7c0.xyz;
        loc_71579.w = mix(clamp(((0.2125999927520751953125 * loc_ff254.x) + (0.715200006961822509765625 * loc_ff254.y)) + (0.072200000286102294921875 * loc_ff254.z), 0.0, 1.0), loc_71579.w, loc_d1818);
        highp float loc_c7af3 = loc_71579.w;
        loc_71579.w = 1.0;
        arg_ad1a5 = loc_71579;
        loc_96834 = loc_39dd0 * loc_c7af3;
    }
    else
    {
        loc_96834 = loc_39dd0;
    }
    arg_59019 = loc_96834;
}
void main() {
    highp vec4 var_844c6 = v_Additional;
    highp vec4 var_abc88 = vec4(0.0);
    highp float var_8975d;
    func_4a7ec(var_abc88, var_844c6, var_8975d);
    bgfx_FragData0 = var_abc88 * var_8975d;
}
