#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* showDF:
* - SHOW_DF__OFF
* - SHOW_DF__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_Texture0;
* - uniform lowp sampler2D s_Texture1;
* - uniform lowp sampler2D s_Texture2;
* - uniform lowp sampler2D s_Texture3;
*
* Uniforms:
* - uniform vec4 Coefficients[3];
* - uniform vec4 PixelOffsets[6];
* - uniform vec4 PrimProps0;
* - uniform vec4 PrimProps1;
* - uniform vec4 ShaderType;
* - uniform mat4 Transform;
* - uniform vec4 Viewport;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_Texture0;
uniform highp sampler2D s_Texture1;
uniform highp sampler2D s_Texture2;
uniform highp sampler2D s_Texture3;
uniform highp vec4 Coefficients[3];
uniform highp vec4 PixelOffsets[6];
uniform highp vec4 PrimProps0;
uniform highp vec4 PrimProps1;
uniform highp vec4 ShaderType;
in highp vec4 v_additional;
in highp vec4 v_color;
in highp vec4 v_screenPosition;
layout(location = 0) out highp vec4 bgfx_FragColor;
#ifdef SHOW_DF__ON
void func_1bca4(inout highp vec4 arg_c876f, inout highp vec4 arg_b5a2a, inout highp vec4 arg_a2118, inout highp float arg_f1cba) {
    highp float loc_ffd70;
    if (1.0 == ShaderType.x)
    {
        loc_ffd70 = clamp(0.5 - (length(v_screenPosition.xy - v_additional.xy) - arg_c876f.z), 0.0, 1.0);
    }
    else
    {
        highp float loc_736b5;
        if (2.0 == ShaderType.x)
        {
            highp float loc_c0e29 = length(v_screenPosition.xy - v_additional.xy);
            loc_736b5 = clamp(0.5 - (loc_c0e29 - arg_c876f.z), 0.0, 1.0) * (1.0 - clamp(0.5 - (loc_c0e29 - (arg_c876f.z - arg_c876f.w)), 0.0, 1.0));
        }
        else
        {
            highp float loc_6c060;
            if (4.0 == ShaderType.x)
            {
                highp vec2 loc_55c60 = (v_screenPosition.xy - v_additional.xy) / v_additional.zw;
                highp vec2 loc_bb51a = loc_55c60;
                highp vec2 loc_1e994 = dFdx(loc_55c60);
                highp vec2 loc_f8765 = dFdy(loc_55c60);
                highp vec2 loc_7d352 = vec2(((2.0 * loc_bb51a.x) * loc_1e994.x) + ((2.0 * loc_bb51a.y) * loc_1e994.y), ((2.0 * loc_bb51a.x) * loc_f8765.x) + ((2.0 * loc_bb51a.y) * loc_f8765.y));
                loc_6c060 = clamp(0.5 - ((dot(loc_55c60, loc_55c60) - 1.0) * inversesqrt(max(dot(loc_7d352, loc_7d352), 9.9999997473787516355514526367188e-05))), 0.0, 1.0);
            }
            else
            {
                highp float loc_694ba;
                if (5.0 == ShaderType.x)
                {
                    highp vec2 loc_6e3a1 = (v_screenPosition.xy - v_additional.xy) / (v_additional.zw + vec2(PrimProps0.x * 0.5));
                    highp vec2 loc_b8d04 = loc_6e3a1;
                    highp vec2 loc_ce39b = dFdx(loc_6e3a1);
                    highp vec2 loc_030b5 = dFdy(loc_6e3a1);
                    highp vec2 loc_f7630 = vec2(((2.0 * loc_b8d04.x) * loc_ce39b.x) + ((2.0 * loc_b8d04.y) * loc_ce39b.y), ((2.0 * loc_b8d04.x) * loc_030b5.x) + ((2.0 * loc_b8d04.y) * loc_030b5.y));
                    highp vec2 loc_f01f1 = (v_screenPosition.xy - v_additional.xy) / (v_additional.zw - vec2(PrimProps0.x * 0.5));
                    highp vec2 loc_723b3 = loc_f01f1;
                    highp vec2 loc_77778 = dFdx(loc_f01f1);
                    highp vec2 loc_b59f9 = dFdy(loc_f01f1);
                    highp vec2 loc_0eb47 = vec2(((2.0 * loc_723b3.x) * loc_77778.x) + ((2.0 * loc_723b3.y) * loc_77778.y), ((2.0 * loc_723b3.x) * loc_b59f9.x) + ((2.0 * loc_723b3.y) * loc_b59f9.y));
                    loc_694ba = clamp(0.5 - ((dot(loc_6e3a1, loc_6e3a1) - 1.0) * inversesqrt(max(dot(loc_f7630, loc_f7630), 9.9999997473787516355514526367188e-05))), 0.0, 1.0) * clamp(0.5 + ((dot(loc_f01f1, loc_f01f1) - 1.0) * inversesqrt(max(dot(loc_0eb47, loc_0eb47), 9.9999997473787516355514526367188e-05))), 0.0, 1.0);
                }
                else
                {
                    highp float loc_ddde2;
                    if (6.0 == ShaderType.x)
                    {
                        arg_b5a2a = vec4(0.0);
                        int loc_1bbba = int(PrimProps0.x);
                        highp vec2 loc_c0980;
                        for (int loc_3e01b = 0; loc_3e01b < loc_1bbba; loc_3e01b++)
                        {
                            loc_c0980.x = PixelOffsets[(loc_3e01b * 2) / 4][int(mod(float(loc_3e01b * 2), 4.0))];
                            loc_c0980.y = PixelOffsets[((loc_3e01b * 2) + 1) / 4][int(mod(float((loc_3e01b * 2) + 1), 4.0))];
                            highp vec2 loc_8ff4f = v_additional.xy + loc_c0980;
                            highp vec2 loc_8ad06 = v_additional.xy - loc_c0980;
                            bool loc_24eb6 = PrimProps1.z != (-1.0);
                            bool loc_c1570;
                            if (!loc_24eb6)
                            {
                                loc_c1570 = PrimProps1.w != (-1.0);
                            }
                            else
                            {
                                loc_c1570 = loc_24eb6;
                            }
                            if (loc_c1570)
                            {
                                loc_8ff4f = clamp(loc_8ff4f, PrimProps1.xy, PrimProps1.xy + PrimProps1.zw);
                                loc_8ad06 = clamp(loc_8ad06, PrimProps1.xy, PrimProps1.xy + PrimProps1.zw);
                            }
                            highp float loc_7c2cb = loc_8ff4f.x;
                            highp float loc_76ed8 = loc_8ff4f.y;
                            highp vec2 loc_4d689 = vec2(loc_7c2cb, 1.0 - loc_76ed8);
                            loc_8ff4f = loc_4d689;
                            highp float loc_a90b9 = loc_8ad06.x;
                            highp float loc_497e4 = loc_8ad06.y;
                            highp vec2 loc_31b4d = vec2(loc_a90b9, 1.0 - loc_497e4);
                            loc_8ad06 = loc_31b4d;
                            arg_b5a2a += ((texture(s_Texture0, loc_4d689) + texture(s_Texture0, loc_31b4d)) * Coefficients[loc_3e01b / 4][int(mod(float(loc_3e01b), 4.0))]);
                        }
                        loc_ddde2 = arg_a2118.w;
                    }
                    else
                    {
                        highp float loc_df5f8;
                        if (7.0 == ShaderType.x)
                        {
                            highp vec2 loc_f48a5 = v_additional.xy;
                            bool loc_2d125 = PrimProps1.z != (-1.0);
                            bool loc_f9cc5;
                            if (!loc_2d125)
                            {
                                loc_f9cc5 = PrimProps1.w != (-1.0);
                            }
                            else
                            {
                                loc_f9cc5 = loc_2d125;
                            }
                            if (loc_f9cc5)
                            {
                                loc_f48a5.x = clamp(loc_f48a5.x, PrimProps1.x, PrimProps1.x + PrimProps1.z);
                                loc_f48a5.y = clamp(loc_f48a5.y, PrimProps1.y, PrimProps1.y + PrimProps1.w);
                            }
                            highp float loc_ca6f5 = loc_f48a5.x;
                            highp float loc_e424a = loc_f48a5.y;
                            highp vec2 loc_19120 = vec2(loc_ca6f5, 1.0 - loc_e424a);
                            loc_f48a5 = loc_19120;
                            highp vec4 loc_63ee4 = texture(s_Texture0, loc_19120);
                            highp vec4 loc_e7cba = loc_63ee4;
                            highp float loc_6215c = loc_e7cba.w;
                            highp float loc_b8072 = max(loc_6215c, 9.9999997473787516355514526367188e-06);
                            highp vec4 loc_b17d8 = vec4(loc_63ee4.xyz / vec3(loc_b8072), loc_b8072);
                            loc_e7cba = loc_b17d8;
                            arg_b5a2a.x = dot(loc_b17d8, Coefficients[0]);
                            arg_b5a2a.y = dot(loc_b17d8, Coefficients[1]);
                            arg_b5a2a.z = dot(loc_b17d8, Coefficients[2]);
                            arg_b5a2a.w = dot(loc_b17d8, PixelOffsets[0]);
                            highp vec4 loc_bcdac = arg_b5a2a;
                            highp vec4 loc_cd2fe = loc_bcdac + PixelOffsets[1];
                            arg_b5a2a = loc_cd2fe;
                            arg_b5a2a.w = mix(((0.2125999927520751953125 * loc_cd2fe.x) + (0.715200006961822509765625 * loc_cd2fe.y)) + (0.072200000286102294921875 * loc_cd2fe.z), arg_b5a2a.w, arg_a2118.z);
                            highp float loc_9f710 = arg_b5a2a.w;
                            arg_b5a2a.w = 1.0;
                            loc_df5f8 = (loc_9f710 * arg_a2118.w) * clamp(arg_c876f.z, 0.0, 1.0);
                        }
                        else
                        {
                            bool loc_074c2 = 9.0 == ShaderType.x;
                            bool loc_45479;
                            if (!loc_074c2)
                            {
                                loc_45479 = 12.0 == ShaderType.x;
                            }
                            else
                            {
                                loc_45479 = loc_074c2;
                            }
                            highp float loc_97871;
                            if (loc_45479)
                            {
                                highp vec3 loc_dada2;
                                loc_dada2.x = texture(s_Texture0, v_additional.xy).x;
                                loc_dada2.y = texture(s_Texture1, v_additional.xy).x;
                                loc_dada2.z = texture(s_Texture2, v_additional.xy).x;
                                highp vec3 loc_0a617 = loc_dada2;
                                highp vec3 loc_2ed72 = loc_0a617 - vec3(0.0625, 0.5, 0.5);
                                loc_dada2 = loc_2ed72;
                                highp float loc_15848 = arg_a2118.w * clamp(arg_c876f.z, 0.0, 1.0);
                                arg_b5a2a = vec4(transpose(mat3(vec3(1.164000034332275390625, 0.0, 1.5959999561309814453125), vec3(1.164000034332275390625, -0.3910000026226043701171875, -0.813000023365020751953125), vec3(1.164000034332275390625, 2.0179998874664306640625, 0.0))) * loc_2ed72, 1.0);
                                highp float loc_304d4;
                                if (12.0 == ShaderType.x)
                                {
                                    loc_304d4 = loc_15848 * texture(s_Texture3, v_additional.xy).x;
                                }
                                else
                                {
                                    loc_304d4 = loc_15848;
                                }
                                loc_97871 = loc_304d4;
                            }
                            else
                            {
                                highp float loc_66d5d;
                                if (11.0 == ShaderType.x)
                                {
                                    loc_66d5d = clamp((1.0 - clamp(abs(dot(v_additional.xyz, vec3(v_screenPosition.xy, 1.0))), 0.0, 1.0)) * arg_c876f.w, 0.0, 1.0);
                                }
                                else
                                {
                                    if (19.0 == ShaderType.x)
                                    {
                                        arg_b5a2a = vec4(texture(s_Texture0, v_additional.xy).xxx, 1.0);
                                        arg_f1cba = 1.0;
                                        return;
                                    }
                                    loc_66d5d = 1.0;
                                }
                                loc_97871 = loc_66d5d;
                            }
                            loc_df5f8 = loc_97871;
                        }
                        loc_ddde2 = loc_df5f8;
                    }
                    loc_694ba = loc_ddde2;
                }
                loc_6c060 = loc_694ba;
            }
            loc_736b5 = loc_6c060;
        }
        loc_ffd70 = loc_736b5;
    }
    arg_f1cba = loc_ffd70;
}
#endif
void main() {
    highp vec4 var_beecc = v_additional;
    highp vec4 var_87ec0 = v_color;
    highp vec4 var_ee415 = v_color;
    highp float var_7c498;
#ifdef SHOW_DF__OFF
    if (1.0 == ShaderType.x)
    {
        var_7c498 = clamp(0.5 - (length(v_screenPosition.xy - v_additional.xy) - var_beecc.z), 0.0, 1.0);
    }
    else
    {
        highp float var_736b5;
        if (2.0 == ShaderType.x)
        {
            highp float var_5d3f0 = length(v_screenPosition.xy - v_additional.xy);
            var_736b5 = clamp(0.5 - (var_5d3f0 - var_beecc.z), 0.0, 1.0) * (1.0 - clamp(0.5 - (var_5d3f0 - (var_beecc.z - var_beecc.w)), 0.0, 1.0));
        }
        else
        {
            highp float var_6c060;
            if (4.0 == ShaderType.x)
            {
                highp vec2 var_1ef6d = (v_screenPosition.xy - v_additional.xy) / v_additional.zw;
                highp vec2 var_54443 = var_1ef6d;
                highp vec2 var_deda4 = dFdx(var_1ef6d);
                highp vec2 var_bf046 = dFdy(var_1ef6d);
                highp vec2 var_c8c88 = vec2(((2.0 * var_54443.x) * var_deda4.x) + ((2.0 * var_54443.y) * var_deda4.y), ((2.0 * var_54443.x) * var_bf046.x) + ((2.0 * var_54443.y) * var_bf046.y));
                var_6c060 = clamp(0.5 - ((dot(var_1ef6d, var_1ef6d) - 1.0) * inversesqrt(max(dot(var_c8c88, var_c8c88), 9.9999997473787516355514526367188e-05))), 0.0, 1.0);
            }
            else
            {
                highp float var_694ba;
                if (5.0 == ShaderType.x)
                {
                    highp vec2 var_25f7e = (v_screenPosition.xy - v_additional.xy) / (v_additional.zw + vec2(PrimProps0.x * 0.5));
                    highp vec2 var_63ffa = var_25f7e;
                    highp vec2 var_99e23 = dFdx(var_25f7e);
                    highp vec2 var_ee45b = dFdy(var_25f7e);
                    highp vec2 var_5cc16 = vec2(((2.0 * var_63ffa.x) * var_99e23.x) + ((2.0 * var_63ffa.y) * var_99e23.y), ((2.0 * var_63ffa.x) * var_ee45b.x) + ((2.0 * var_63ffa.y) * var_ee45b.y));
                    highp vec2 var_1bae6 = (v_screenPosition.xy - v_additional.xy) / (v_additional.zw - vec2(PrimProps0.x * 0.5));
                    highp vec2 var_80f0e = var_1bae6;
                    highp vec2 var_676ed = dFdx(var_1bae6);
                    highp vec2 var_2c3da = dFdy(var_1bae6);
                    highp vec2 var_c2fe3 = vec2(((2.0 * var_80f0e.x) * var_676ed.x) + ((2.0 * var_80f0e.y) * var_676ed.y), ((2.0 * var_80f0e.x) * var_2c3da.x) + ((2.0 * var_80f0e.y) * var_2c3da.y));
                    var_694ba = clamp(0.5 - ((dot(var_25f7e, var_25f7e) - 1.0) * inversesqrt(max(dot(var_5cc16, var_5cc16), 9.9999997473787516355514526367188e-05))), 0.0, 1.0) * clamp(0.5 + ((dot(var_1bae6, var_1bae6) - 1.0) * inversesqrt(max(dot(var_c2fe3, var_c2fe3), 9.9999997473787516355514526367188e-05))), 0.0, 1.0);
                }
                else
                {
                    highp float var_ddde2;
                    if (6.0 == ShaderType.x)
                    {
                        var_ee415 = vec4(0.0);
                        int var_1bbba = int(PrimProps0.x);
                        highp vec2 var_c0980;
                        for (int var_f19e6 = 0; var_f19e6 < var_1bbba; var_f19e6++)
                        {
                            var_c0980.x = PixelOffsets[(var_f19e6 * 2) / 4][int(mod(float(var_f19e6 * 2), 4.0))];
                            var_c0980.y = PixelOffsets[((var_f19e6 * 2) + 1) / 4][int(mod(float((var_f19e6 * 2) + 1), 4.0))];
                            highp vec2 var_d876b = v_additional.xy + var_c0980;
                            highp vec2 var_f2fcd = v_additional.xy - var_c0980;
                            bool var_24eb6 = PrimProps1.z != (-1.0);
                            bool var_c1570;
                            if (!var_24eb6)
                            {
                                var_c1570 = PrimProps1.w != (-1.0);
                            }
                            else
                            {
                                var_c1570 = var_24eb6;
                            }
                            if (var_c1570)
                            {
                                var_d876b = clamp(var_d876b, PrimProps1.xy, PrimProps1.xy + PrimProps1.zw);
                                var_f2fcd = clamp(var_f2fcd, PrimProps1.xy, PrimProps1.xy + PrimProps1.zw);
                            }
                            highp float var_7c2cb = var_d876b.x;
                            highp float var_76ed8 = var_d876b.y;
                            highp vec2 var_4d689 = vec2(var_7c2cb, 1.0 - var_76ed8);
                            var_d876b = var_4d689;
                            highp float var_a90b9 = var_f2fcd.x;
                            highp float var_497e4 = var_f2fcd.y;
                            highp vec2 var_31b4d = vec2(var_a90b9, 1.0 - var_497e4);
                            var_f2fcd = var_31b4d;
                            var_ee415 += ((texture(s_Texture0, var_4d689) + texture(s_Texture0, var_31b4d)) * Coefficients[var_f19e6 / 4][int(mod(float(var_f19e6), 4.0))]);
                        }
                        var_ddde2 = var_87ec0.w;
                    }
                    else
                    {
                        highp float var_df5f8;
                        if (7.0 == ShaderType.x)
                        {
                            highp vec2 var_c61c1 = v_additional.xy;
                            bool var_2d125 = PrimProps1.z != (-1.0);
                            bool var_f9cc5;
                            if (!var_2d125)
                            {
                                var_f9cc5 = PrimProps1.w != (-1.0);
                            }
                            else
                            {
                                var_f9cc5 = var_2d125;
                            }
                            if (var_f9cc5)
                            {
                                var_c61c1.x = clamp(var_c61c1.x, PrimProps1.x, PrimProps1.x + PrimProps1.z);
                                var_c61c1.y = clamp(var_c61c1.y, PrimProps1.y, PrimProps1.y + PrimProps1.w);
                            }
                            highp float var_ca6f5 = var_c61c1.x;
                            highp float var_e424a = var_c61c1.y;
                            highp vec2 var_19120 = vec2(var_ca6f5, 1.0 - var_e424a);
                            var_c61c1 = var_19120;
                            highp vec4 var_63ee4 = texture(s_Texture0, var_19120);
                            highp vec4 var_e7cba = var_63ee4;
                            highp float var_6215c = var_e7cba.w;
                            highp float var_598f3 = max(var_6215c, 9.9999997473787516355514526367188e-06);
                            highp vec4 var_b17d8 = vec4(var_63ee4.xyz / vec3(var_598f3), var_598f3);
                            var_e7cba = var_b17d8;
                            var_ee415.x = dot(var_b17d8, Coefficients[0]);
                            var_ee415.y = dot(var_b17d8, Coefficients[1]);
                            var_ee415.z = dot(var_b17d8, Coefficients[2]);
                            var_ee415.w = dot(var_b17d8, PixelOffsets[0]);
                            highp vec4 var_bcdac = var_ee415;
                            highp vec4 var_5b147 = var_bcdac + PixelOffsets[1];
                            var_ee415 = var_5b147;
                            var_ee415.w = mix(((0.2125999927520751953125 * var_5b147.x) + (0.715200006961822509765625 * var_5b147.y)) + (0.072200000286102294921875 * var_5b147.z), var_ee415.w, var_87ec0.z);
                            highp float var_9f710 = var_ee415.w;
                            var_ee415.w = 1.0;
                            var_df5f8 = (var_9f710 * var_87ec0.w) * clamp(var_beecc.z, 0.0, 1.0);
                        }
                        else
                        {
                            bool var_074c2 = 9.0 == ShaderType.x;
                            bool var_45479;
                            if (!var_074c2)
                            {
                                var_45479 = 12.0 == ShaderType.x;
                            }
                            else
                            {
                                var_45479 = var_074c2;
                            }
                            highp float var_97871;
                            if (var_45479)
                            {
                                highp vec3 var_dada2;
                                var_dada2.x = texture(s_Texture0, v_additional.xy).x;
                                var_dada2.y = texture(s_Texture1, v_additional.xy).x;
                                var_dada2.z = texture(s_Texture2, v_additional.xy).x;
                                highp vec3 var_0a617 = var_dada2;
                                highp vec3 var_2ed72 = var_0a617 - vec3(0.0625, 0.5, 0.5);
                                var_dada2 = var_2ed72;
                                highp float var_15848 = var_87ec0.w * clamp(var_beecc.z, 0.0, 1.0);
                                var_ee415 = vec4(transpose(mat3(vec3(1.164000034332275390625, 0.0, 1.5959999561309814453125), vec3(1.164000034332275390625, -0.3910000026226043701171875, -0.813000023365020751953125), vec3(1.164000034332275390625, 2.0179998874664306640625, 0.0))) * var_2ed72, 1.0);
                                highp float var_304d4;
                                if (12.0 == ShaderType.x)
                                {
                                    var_304d4 = var_15848 * texture(s_Texture3, v_additional.xy).x;
                                }
                                else
                                {
                                    var_304d4 = var_15848;
                                }
                                var_97871 = var_304d4;
                            }
                            else
                            {
                                highp float var_66d5d;
                                if (11.0 == ShaderType.x)
                                {
                                    var_66d5d = clamp((1.0 - clamp(abs(dot(v_additional.xyz, vec3(v_screenPosition.xy, 1.0))), 0.0, 1.0)) * var_beecc.w, 0.0, 1.0);
                                }
                                else
                                {
                                    if (19.0 == ShaderType.x)
                                    {
                                        highp float var_74503 = sqrt(PrimProps0.y * 0.5);
                                        highp float var_75ea4 = (0.5 * var_74503) - 0.89999997615814208984375;
                                        highp float var_3311a = ((PrimProps0.z / PrimProps0.y) * 0.5) * var_74503;
                                        highp float var_74c46 = texture(s_Texture0, v_additional.xy).x * var_74503;
                                        var_ee415 = mix(PrimProps1, v_color, vec4(clamp(var_74c46 - (var_75ea4 + var_3311a), 0.0, 1.0))) * clamp(var_74c46 - max(0.0, var_75ea4 - var_3311a), 0.0, 1.0);
                                    }
                                    var_66d5d = 1.0;
                                }
                                var_97871 = var_66d5d;
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
        var_7c498 = var_736b5;
    }
#endif
#ifdef SHOW_DF__ON
    func_1bca4(var_beecc, var_ee415, var_87ec0, var_7c498);
#endif
    bgfx_FragColor = var_ee415 * var_7c498;
}
