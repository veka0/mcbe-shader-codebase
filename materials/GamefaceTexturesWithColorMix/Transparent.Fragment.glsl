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
* - uniform lowp sampler2D s_Texture0;
* - uniform lowp sampler2D s_Texture1;
*
* Uniforms:
* - uniform vec4 PrimProps0;
* - uniform mat4 Transform;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_Texture0;
uniform highp sampler2D s_Texture1;
uniform highp vec4 PrimProps0;
in highp vec4 v_additional;
in highp vec4 v_color;
layout(location = 0) out highp vec4 bgfx_FragColor;
vec3 var_8add6;
void func_f2389(inout int arg_3bfbb, inout highp vec3 arg_296ba, inout highp vec3 arg_fff24, inout highp vec3 arg_77b6c) {
    if (arg_3bfbb == 0)
    {
        arg_296ba = arg_fff24;
        return;
    }
    else
    {
        if (arg_3bfbb == 1)
        {
            arg_296ba = arg_77b6c * arg_fff24;
            return;
        }
        else
        {
            if (arg_3bfbb == 2)
            {
                arg_296ba = (arg_77b6c + arg_fff24) - (arg_77b6c * arg_fff24);
                return;
            }
            else
            {
                if (arg_3bfbb == 3)
                {
                    highp vec3 loc_7d8e6 = (arg_77b6c * 2.0) - vec3(1.0);
                    arg_296ba = mix((arg_fff24 + loc_7d8e6) - (arg_fff24 * loc_7d8e6), arg_fff24 * (arg_77b6c * 2.0), step(vec3(0.5), arg_77b6c));
                    return;
                }
                else
                {
                    if (arg_3bfbb == 4)
                    {
                        arg_296ba = min(arg_fff24, arg_77b6c);
                        return;
                    }
                    else
                    {
                        if (arg_3bfbb == 5)
                        {
                            arg_296ba = max(arg_fff24, arg_77b6c);
                            return;
                        }
                        else
                        {
                            if (arg_3bfbb == 6)
                            {
                                arg_296ba = min(arg_77b6c / max(vec3(1.0) - arg_fff24, vec3(9.9999997473787516355514526367188e-05)), vec3(1.0));
                                return;
                            }
                            else
                            {
                                if (arg_3bfbb == 7)
                                {
                                    arg_296ba = vec3(1.0) - min((vec3(1.0) - arg_77b6c) / max(arg_fff24, vec3(9.9999997473787516355514526367188e-05)), vec3(1.0));
                                    return;
                                }
                                else
                                {
                                    if (arg_3bfbb == 8)
                                    {
                                        highp vec3 loc_98a4c = (arg_fff24 * 2.0) - vec3(1.0);
                                        arg_296ba = mix((arg_77b6c + loc_98a4c) - (arg_77b6c * loc_98a4c), arg_77b6c * (arg_fff24 * 2.0), step(vec3(0.5), arg_fff24));
                                        return;
                                    }
                                    else
                                    {
                                        if (arg_3bfbb == 9)
                                        {
                                            arg_296ba = mix(arg_77b6c + (((arg_fff24 * 2.0) - vec3(1.0)) * (mix(sqrt(arg_77b6c), ((((arg_77b6c * 16.0) - vec3(12.0)) * arg_77b6c) + vec3(4.0)) * arg_77b6c, step(vec3(0.25), arg_77b6c)) - arg_77b6c)), arg_77b6c - (((vec3(1.0) - (arg_fff24 * 2.0)) * arg_77b6c) * (vec3(1.0) - arg_77b6c)), step(vec3(0.5), arg_fff24));
                                            return;
                                        }
                                        else
                                        {
                                            if (arg_3bfbb == 10)
                                            {
                                                arg_296ba = abs(arg_77b6c - arg_fff24);
                                                return;
                                            }
                                            else
                                            {
                                                if (arg_3bfbb == 11)
                                                {
                                                    arg_296ba = (arg_77b6c + arg_fff24) - ((arg_77b6c * 2.0) * arg_fff24);
                                                    return;
                                                }
                                                else
                                                {
                                                    if (arg_3bfbb == 12)
                                                    {
                                                        highp vec3 loc_978f9 = arg_77b6c;
                                                        highp float loc_5d049 = max(max(loc_978f9.x, loc_978f9.y), loc_978f9.z) - min(min(loc_978f9.x, loc_978f9.y), loc_978f9.z);
                                                        highp vec3 loc_f097b = arg_fff24;
                                                        if (loc_f097b.x <= loc_f097b.y)
                                                        {
                                                            if (loc_f097b.y <= loc_f097b.z)
                                                            {
                                                                highp vec3 loc_407da = loc_f097b;
                                                                if (loc_407da.z > loc_407da.x)
                                                                {
                                                                    loc_407da.y = ((loc_407da.y - loc_407da.x) * loc_5d049) / (loc_407da.z - loc_407da.x);
                                                                    loc_407da.z = loc_5d049;
                                                                }
                                                                else
                                                                {
                                                                    loc_407da = vec3(loc_407da.x, vec2(0.0).x, vec2(0.0).y);
                                                                }
                                                                loc_f097b = vec3(0.0, loc_407da.y, loc_407da.z);
                                                            }
                                                            else
                                                            {
                                                                if (loc_f097b.x <= loc_f097b.z)
                                                                {
                                                                    highp vec3 loc_ebbca = loc_f097b.xzy;
                                                                    if (loc_ebbca.z > loc_ebbca.x)
                                                                    {
                                                                        loc_ebbca.y = ((loc_ebbca.y - loc_ebbca.x) * loc_5d049) / (loc_ebbca.z - loc_ebbca.x);
                                                                        loc_ebbca.z = loc_5d049;
                                                                    }
                                                                    else
                                                                    {
                                                                        loc_ebbca = vec3(loc_ebbca.x, vec2(0.0).x, vec2(0.0).y);
                                                                    }
                                                                    highp vec3 loc_7d8d3 = vec3(0.0, loc_ebbca.y, loc_ebbca.z);
                                                                    loc_f097b = vec3(loc_7d8d3.x, loc_7d8d3.z, loc_7d8d3.y);
                                                                }
                                                                else
                                                                {
                                                                    highp vec3 loc_81d30 = loc_f097b.zxy;
                                                                    if (loc_81d30.z > loc_81d30.x)
                                                                    {
                                                                        loc_81d30.y = ((loc_81d30.y - loc_81d30.x) * loc_5d049) / (loc_81d30.z - loc_81d30.x);
                                                                        loc_81d30.z = loc_5d049;
                                                                    }
                                                                    else
                                                                    {
                                                                        loc_81d30 = vec3(loc_81d30.x, vec2(0.0).x, vec2(0.0).y);
                                                                    }
                                                                    highp vec3 loc_75c95 = vec3(0.0, loc_81d30.y, loc_81d30.z);
                                                                    loc_f097b = vec3(loc_75c95.y, loc_75c95.z, loc_75c95.x);
                                                                }
                                                            }
                                                        }
                                                        else
                                                        {
                                                            if (loc_f097b.x <= loc_f097b.z)
                                                            {
                                                                highp vec3 loc_747e3 = loc_f097b.yxz;
                                                                if (loc_747e3.z > loc_747e3.x)
                                                                {
                                                                    loc_747e3.y = ((loc_747e3.y - loc_747e3.x) * loc_5d049) / (loc_747e3.z - loc_747e3.x);
                                                                    loc_747e3.z = loc_5d049;
                                                                }
                                                                else
                                                                {
                                                                    loc_747e3 = vec3(loc_747e3.x, vec2(0.0).x, vec2(0.0).y);
                                                                }
                                                                highp vec3 loc_d5362 = vec3(0.0, loc_747e3.y, loc_747e3.z);
                                                                loc_f097b = vec3(loc_d5362.y, loc_d5362.x, loc_d5362.z);
                                                            }
                                                            else
                                                            {
                                                                if (loc_f097b.y <= loc_f097b.z)
                                                                {
                                                                    highp vec3 loc_1fbfc = loc_f097b.yzx;
                                                                    if (loc_1fbfc.z > loc_1fbfc.x)
                                                                    {
                                                                        loc_1fbfc.y = ((loc_1fbfc.y - loc_1fbfc.x) * loc_5d049) / (loc_1fbfc.z - loc_1fbfc.x);
                                                                        loc_1fbfc.z = loc_5d049;
                                                                    }
                                                                    else
                                                                    {
                                                                        loc_1fbfc = vec3(loc_1fbfc.x, vec2(0.0).x, vec2(0.0).y);
                                                                    }
                                                                    highp vec3 loc_22a4f = vec3(0.0, loc_1fbfc.y, loc_1fbfc.z);
                                                                    loc_f097b = vec3(loc_22a4f.z, loc_22a4f.x, loc_22a4f.y);
                                                                }
                                                                else
                                                                {
                                                                    highp vec3 loc_0a257 = loc_f097b.zyx;
                                                                    if (loc_0a257.z > loc_0a257.x)
                                                                    {
                                                                        loc_0a257.y = ((loc_0a257.y - loc_0a257.x) * loc_5d049) / (loc_0a257.z - loc_0a257.x);
                                                                        loc_0a257.z = loc_5d049;
                                                                    }
                                                                    else
                                                                    {
                                                                        loc_0a257 = vec3(loc_0a257.x, vec2(0.0).x, vec2(0.0).y);
                                                                    }
                                                                    highp vec3 loc_c9a8b = vec3(0.0, loc_0a257.y, loc_0a257.z);
                                                                    loc_f097b = vec3(loc_c9a8b.z, loc_c9a8b.y, loc_c9a8b.x);
                                                                }
                                                            }
                                                        }
                                                        highp vec3 loc_918fd = arg_77b6c;
                                                        highp vec3 loc_b4f13 = loc_f097b;
                                                        highp vec3 loc_9970b = loc_f097b + vec3((((0.300000011920928955078125 * loc_918fd.x) + (0.589999973773956298828125 * loc_918fd.y)) + (0.10999999940395355224609375 * loc_918fd.z)) - (((0.300000011920928955078125 * loc_b4f13.x) + (0.589999973773956298828125 * loc_b4f13.y)) + (0.10999999940395355224609375 * loc_b4f13.z)));
                                                        highp vec3 loc_dc1ef = loc_9970b;
                                                        highp vec3 loc_594ae = loc_9970b;
                                                        highp float loc_069de = ((0.300000011920928955078125 * loc_594ae.x) + (0.589999973773956298828125 * loc_594ae.y)) + (0.10999999940395355224609375 * loc_594ae.z);
                                                        highp float loc_915b2 = min(min(loc_dc1ef.x, loc_dc1ef.y), loc_dc1ef.z);
                                                        highp float loc_a439c = loc_dc1ef.x;
                                                        highp float loc_fb04c = loc_dc1ef.y;
                                                        highp float loc_88b31 = loc_dc1ef.z;
                                                        highp float loc_c3758 = max(max(loc_a439c, loc_fb04c), loc_88b31);
                                                        if (loc_915b2 < 0.0)
                                                        {
                                                            loc_dc1ef = vec3(loc_069de) + (((loc_dc1ef - vec3(loc_069de)) * loc_069de) / vec3(loc_069de - loc_915b2));
                                                        }
                                                        if (loc_c3758 > 1.0)
                                                        {
                                                            loc_dc1ef = vec3(loc_069de) + (((loc_dc1ef - vec3(loc_069de)) * (1.0 - loc_069de)) / vec3(loc_c3758 - loc_069de));
                                                        }
                                                        arg_296ba = loc_dc1ef;
                                                        return;
                                                    }
                                                    else
                                                    {
                                                        if (arg_3bfbb == 13)
                                                        {
                                                            highp vec3 loc_ed3c2 = arg_fff24;
                                                            highp float loc_6c058 = max(max(loc_ed3c2.x, loc_ed3c2.y), loc_ed3c2.z) - min(min(loc_ed3c2.x, loc_ed3c2.y), loc_ed3c2.z);
                                                            highp vec3 loc_aefb0 = arg_77b6c;
                                                            if (loc_aefb0.x <= loc_aefb0.y)
                                                            {
                                                                if (loc_aefb0.y <= loc_aefb0.z)
                                                                {
                                                                    highp vec3 loc_fb2fb = loc_aefb0;
                                                                    if (loc_fb2fb.z > loc_fb2fb.x)
                                                                    {
                                                                        loc_fb2fb.y = ((loc_fb2fb.y - loc_fb2fb.x) * loc_6c058) / (loc_fb2fb.z - loc_fb2fb.x);
                                                                        loc_fb2fb.z = loc_6c058;
                                                                    }
                                                                    else
                                                                    {
                                                                        loc_fb2fb = vec3(loc_fb2fb.x, vec2(0.0).x, vec2(0.0).y);
                                                                    }
                                                                    loc_aefb0 = vec3(0.0, loc_fb2fb.y, loc_fb2fb.z);
                                                                }
                                                                else
                                                                {
                                                                    if (loc_aefb0.x <= loc_aefb0.z)
                                                                    {
                                                                        highp vec3 loc_fe421 = loc_aefb0.xzy;
                                                                        if (loc_fe421.z > loc_fe421.x)
                                                                        {
                                                                            loc_fe421.y = ((loc_fe421.y - loc_fe421.x) * loc_6c058) / (loc_fe421.z - loc_fe421.x);
                                                                            loc_fe421.z = loc_6c058;
                                                                        }
                                                                        else
                                                                        {
                                                                            loc_fe421 = vec3(loc_fe421.x, vec2(0.0).x, vec2(0.0).y);
                                                                        }
                                                                        highp vec3 loc_b8a2c = vec3(0.0, loc_fe421.y, loc_fe421.z);
                                                                        loc_aefb0 = vec3(loc_b8a2c.x, loc_b8a2c.z, loc_b8a2c.y);
                                                                    }
                                                                    else
                                                                    {
                                                                        highp vec3 loc_c3bce = loc_aefb0.zxy;
                                                                        if (loc_c3bce.z > loc_c3bce.x)
                                                                        {
                                                                            loc_c3bce.y = ((loc_c3bce.y - loc_c3bce.x) * loc_6c058) / (loc_c3bce.z - loc_c3bce.x);
                                                                            loc_c3bce.z = loc_6c058;
                                                                        }
                                                                        else
                                                                        {
                                                                            loc_c3bce = vec3(loc_c3bce.x, vec2(0.0).x, vec2(0.0).y);
                                                                        }
                                                                        highp vec3 loc_54bf4 = vec3(0.0, loc_c3bce.y, loc_c3bce.z);
                                                                        loc_aefb0 = vec3(loc_54bf4.y, loc_54bf4.z, loc_54bf4.x);
                                                                    }
                                                                }
                                                            }
                                                            else
                                                            {
                                                                if (loc_aefb0.x <= loc_aefb0.z)
                                                                {
                                                                    highp vec3 loc_eb625 = loc_aefb0.yxz;
                                                                    if (loc_eb625.z > loc_eb625.x)
                                                                    {
                                                                        loc_eb625.y = ((loc_eb625.y - loc_eb625.x) * loc_6c058) / (loc_eb625.z - loc_eb625.x);
                                                                        loc_eb625.z = loc_6c058;
                                                                    }
                                                                    else
                                                                    {
                                                                        loc_eb625 = vec3(loc_eb625.x, vec2(0.0).x, vec2(0.0).y);
                                                                    }
                                                                    highp vec3 loc_38ac9 = vec3(0.0, loc_eb625.y, loc_eb625.z);
                                                                    loc_aefb0 = vec3(loc_38ac9.y, loc_38ac9.x, loc_38ac9.z);
                                                                }
                                                                else
                                                                {
                                                                    if (loc_aefb0.y <= loc_aefb0.z)
                                                                    {
                                                                        highp vec3 loc_4e1a0 = loc_aefb0.yzx;
                                                                        if (loc_4e1a0.z > loc_4e1a0.x)
                                                                        {
                                                                            loc_4e1a0.y = ((loc_4e1a0.y - loc_4e1a0.x) * loc_6c058) / (loc_4e1a0.z - loc_4e1a0.x);
                                                                            loc_4e1a0.z = loc_6c058;
                                                                        }
                                                                        else
                                                                        {
                                                                            loc_4e1a0 = vec3(loc_4e1a0.x, vec2(0.0).x, vec2(0.0).y);
                                                                        }
                                                                        highp vec3 loc_59f93 = vec3(0.0, loc_4e1a0.y, loc_4e1a0.z);
                                                                        loc_aefb0 = vec3(loc_59f93.z, loc_59f93.x, loc_59f93.y);
                                                                    }
                                                                    else
                                                                    {
                                                                        highp vec3 loc_bc1e5 = loc_aefb0.zyx;
                                                                        if (loc_bc1e5.z > loc_bc1e5.x)
                                                                        {
                                                                            loc_bc1e5.y = ((loc_bc1e5.y - loc_bc1e5.x) * loc_6c058) / (loc_bc1e5.z - loc_bc1e5.x);
                                                                            loc_bc1e5.z = loc_6c058;
                                                                        }
                                                                        else
                                                                        {
                                                                            loc_bc1e5 = vec3(loc_bc1e5.x, vec2(0.0).x, vec2(0.0).y);
                                                                        }
                                                                        highp vec3 loc_ad406 = vec3(0.0, loc_bc1e5.y, loc_bc1e5.z);
                                                                        loc_aefb0 = vec3(loc_ad406.z, loc_ad406.y, loc_ad406.x);
                                                                    }
                                                                }
                                                            }
                                                            highp vec3 loc_9a2c8 = arg_77b6c;
                                                            highp vec3 loc_0d479 = loc_aefb0;
                                                            highp vec3 loc_d1b95 = loc_aefb0 + vec3((((0.300000011920928955078125 * loc_9a2c8.x) + (0.589999973773956298828125 * loc_9a2c8.y)) + (0.10999999940395355224609375 * loc_9a2c8.z)) - (((0.300000011920928955078125 * loc_0d479.x) + (0.589999973773956298828125 * loc_0d479.y)) + (0.10999999940395355224609375 * loc_0d479.z)));
                                                            highp vec3 loc_ed1ee = loc_d1b95;
                                                            highp vec3 loc_5d996 = loc_d1b95;
                                                            highp float loc_cc391 = ((0.300000011920928955078125 * loc_5d996.x) + (0.589999973773956298828125 * loc_5d996.y)) + (0.10999999940395355224609375 * loc_5d996.z);
                                                            highp float loc_5f89e = min(min(loc_ed1ee.x, loc_ed1ee.y), loc_ed1ee.z);
                                                            highp float loc_e8448 = loc_ed1ee.x;
                                                            highp float loc_75595 = loc_ed1ee.y;
                                                            highp float loc_b1416 = loc_ed1ee.z;
                                                            highp float loc_74096 = max(max(loc_e8448, loc_75595), loc_b1416);
                                                            if (loc_5f89e < 0.0)
                                                            {
                                                                loc_ed1ee = vec3(loc_cc391) + (((loc_ed1ee - vec3(loc_cc391)) * loc_cc391) / vec3(loc_cc391 - loc_5f89e));
                                                            }
                                                            if (loc_74096 > 1.0)
                                                            {
                                                                loc_ed1ee = vec3(loc_cc391) + (((loc_ed1ee - vec3(loc_cc391)) * (1.0 - loc_cc391)) / vec3(loc_74096 - loc_cc391));
                                                            }
                                                            arg_296ba = loc_ed1ee;
                                                            return;
                                                        }
                                                        else
                                                        {
                                                            if (arg_3bfbb == 14)
                                                            {
                                                                highp vec3 loc_62860 = arg_77b6c;
                                                                highp vec3 loc_90a64 = arg_fff24;
                                                                highp vec3 loc_a70e5 = arg_fff24 + vec3((((0.300000011920928955078125 * loc_62860.x) + (0.589999973773956298828125 * loc_62860.y)) + (0.10999999940395355224609375 * loc_62860.z)) - (((0.300000011920928955078125 * loc_90a64.x) + (0.589999973773956298828125 * loc_90a64.y)) + (0.10999999940395355224609375 * loc_90a64.z)));
                                                                highp vec3 loc_fec90 = loc_a70e5;
                                                                highp vec3 loc_8c422 = loc_a70e5;
                                                                highp float loc_6e6c3 = ((0.300000011920928955078125 * loc_8c422.x) + (0.589999973773956298828125 * loc_8c422.y)) + (0.10999999940395355224609375 * loc_8c422.z);
                                                                highp float loc_4afa6 = min(min(loc_fec90.x, loc_fec90.y), loc_fec90.z);
                                                                highp float loc_8fd13 = loc_fec90.x;
                                                                highp float loc_2efc4 = loc_fec90.y;
                                                                highp float loc_55d53 = loc_fec90.z;
                                                                highp float loc_95096 = max(max(loc_8fd13, loc_2efc4), loc_55d53);
                                                                if (loc_4afa6 < 0.0)
                                                                {
                                                                    loc_fec90 = vec3(loc_6e6c3) + (((loc_fec90 - vec3(loc_6e6c3)) * loc_6e6c3) / vec3(loc_6e6c3 - loc_4afa6));
                                                                }
                                                                if (loc_95096 > 1.0)
                                                                {
                                                                    loc_fec90 = vec3(loc_6e6c3) + (((loc_fec90 - vec3(loc_6e6c3)) * (1.0 - loc_6e6c3)) / vec3(loc_95096 - loc_6e6c3));
                                                                }
                                                                arg_296ba = loc_fec90;
                                                                return;
                                                            }
                                                            else
                                                            {
                                                                if (arg_3bfbb == 15)
                                                                {
                                                                    highp vec3 loc_7e2fb = arg_fff24;
                                                                    highp vec3 loc_f6f36 = arg_77b6c;
                                                                    highp vec3 loc_25ad0 = arg_77b6c + vec3((((0.300000011920928955078125 * loc_7e2fb.x) + (0.589999973773956298828125 * loc_7e2fb.y)) + (0.10999999940395355224609375 * loc_7e2fb.z)) - (((0.300000011920928955078125 * loc_f6f36.x) + (0.589999973773956298828125 * loc_f6f36.y)) + (0.10999999940395355224609375 * loc_f6f36.z)));
                                                                    highp vec3 loc_73a3a = loc_25ad0;
                                                                    highp vec3 loc_9cd7b = loc_25ad0;
                                                                    highp float loc_e719c = ((0.300000011920928955078125 * loc_9cd7b.x) + (0.589999973773956298828125 * loc_9cd7b.y)) + (0.10999999940395355224609375 * loc_9cd7b.z);
                                                                    highp float loc_1b961 = min(min(loc_73a3a.x, loc_73a3a.y), loc_73a3a.z);
                                                                    highp float loc_7965d = loc_73a3a.x;
                                                                    highp float loc_f7a79 = loc_73a3a.y;
                                                                    highp float loc_fe65c = loc_73a3a.z;
                                                                    highp float loc_674dd = max(max(loc_7965d, loc_f7a79), loc_fe65c);
                                                                    if (loc_1b961 < 0.0)
                                                                    {
                                                                        loc_73a3a = vec3(loc_e719c) + (((loc_73a3a - vec3(loc_e719c)) * loc_e719c) / vec3(loc_e719c - loc_1b961));
                                                                    }
                                                                    if (loc_674dd > 1.0)
                                                                    {
                                                                        loc_73a3a = vec3(loc_e719c) + (((loc_73a3a - vec3(loc_e719c)) * (1.0 - loc_e719c)) / vec3(loc_674dd - loc_e719c));
                                                                    }
                                                                    arg_296ba = loc_73a3a;
                                                                    return;
                                                                }
                                                                else
                                                                {
                                                                    if (arg_3bfbb == 16)
                                                                    {
                                                                        arg_296ba = min(arg_fff24 + arg_77b6c, vec3(1.0));
                                                                        return;
                                                                    }
                                                                    else
                                                                    {
                                                                        arg_296ba = vec3(0.0);
                                                                        return;
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
void main() {
    highp vec4 var_c2563 = v_additional;
    highp vec4 var_ef0c7 = v_color;
    highp vec4 var_3774c = texture(s_Texture1, vec2(var_c2563.z, 1.0 - var_c2563.w));
    highp vec4 var_a5547 = var_3774c;
    highp vec4 var_1797c = texture(s_Texture0, vec2(var_c2563.x, 1.0 - var_c2563.y));
    highp vec4 var_51ac8 = var_1797c * var_ef0c7.w;
    highp vec4 var_9b012 = var_51ac8;
    highp vec3 var_d9181 = var_3774c.xyz / vec3(max(var_a5547.w, 9.9999997473787516355514526367188e-05));
    highp vec3 var_99eaf = var_51ac8.xyz / vec3(max(var_9b012.w, 9.9999997473787516355514526367188e-05));
    int var_107eb = int(PrimProps0.x);
    highp vec3 var_3d346;
    func_f2389(var_107eb, var_3d346, var_99eaf, var_d9181);
    bgfx_FragColor = ((var_51ac8 * (1.0 - var_a5547.w)) + (vec4(clamp(var_3d346, vec3(0.0), vec3(1.0)), 1.0) * (var_9b012.w * var_a5547.w))) + (var_3774c * (1.0 - var_9b012.w));
}
