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
uniform highp sampler2D s_txBuffer3;
uniform highp sampler2D s_txBuffer;
uniform highp vec4 Data_PS[128];
uniform highp vec4 UVTransform[5];
in highp vec4 v_Additional;
in highp vec3 v_ScreenNormalPosition;
flat in highp vec4 v_VaryingData;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_333b6 = v_Additional;
    uvec4 var_4581e = uvec4(v_VaryingData);
    int var_1821c = int((var_4581e.z << uint(4)) | ((var_4581e.y & 240u) >> uint(4)));
    int var_c9987 = int(var_4581e.w);
    highp vec4 var_a33c5 = Data_PS[var_1821c];
    int var_f6e03 = var_1821c + 1;
    highp vec4 var_f2374 = Data_PS[var_f6e03];
    int var_8998a = int(var_f2374.w);
    highp vec4 var_9aa42 = Data_PS[var_1821c];
    highp float var_98b39;
    if (1.0 == float(var_c9987))
    {
        var_98b39 = clamp(0.5 - (length(v_ScreenNormalPosition.xy - v_Additional.xy) - var_333b6.z), 0.0, 1.0);
    }
    else
    {
        highp float var_736b5;
        if (2.0 == float(var_c9987))
        {
            highp float var_f2c71 = length(v_ScreenNormalPosition.xy - v_Additional.xy);
            var_736b5 = clamp(0.5 - (var_f2c71 - var_333b6.z), 0.0, 1.0) * (1.0 - clamp(0.5 - (var_f2c71 - (var_333b6.z - var_333b6.w)), 0.0, 1.0));
        }
        else
        {
            highp float var_6c060;
            if (4.0 == float(var_c9987))
            {
                highp vec2 var_b0b6c = (v_ScreenNormalPosition.xy - v_Additional.xy) * (vec2(1.0) / v_Additional.zw);
                highp vec2 var_54443 = var_b0b6c;
                highp vec2 var_deda4 = dFdx(var_b0b6c);
                highp vec2 var_bf046 = dFdy(var_b0b6c);
                highp vec2 var_c8c88 = vec2(((2.0 * var_54443.x) * var_deda4.x) + ((2.0 * var_54443.y) * var_deda4.y), ((2.0 * var_54443.x) * var_bf046.x) + ((2.0 * var_54443.y) * var_bf046.y));
                var_6c060 = clamp(0.5 - ((dot(var_b0b6c, var_b0b6c) - 1.0) * inversesqrt(max(dot(var_c8c88, var_c8c88), 9.9999997473787516355514526367188e-05))), 0.0, 1.0);
            }
            else
            {
                highp float var_694ba;
                if (5.0 == float(var_c9987))
                {
                    highp vec3 var_43bc0 = Data_PS[var_f6e03].xyz;
                    highp vec2 var_b91c8 = (v_ScreenNormalPosition.xy - v_Additional.xy) * (vec2(1.0) / (v_Additional.zw + vec2(var_43bc0.x * 0.5)));
                    highp vec2 var_87286 = var_b91c8;
                    highp vec2 var_615cc = dFdx(var_b91c8);
                    highp vec2 var_3fe1e = dFdy(var_b91c8);
                    highp float var_682c6 = var_87286.x;
                    highp float var_6efe0 = var_615cc.x;
                    highp float var_4db26 = var_87286.y;
                    highp float var_fbdd3 = var_615cc.y;
                    highp float var_2d9d7 = var_87286.x;
                    highp float var_feb15 = var_3fe1e.x;
                    highp float var_0c52d = var_87286.y;
                    highp float var_0fdea = var_3fe1e.y;
                    highp vec2 var_04c69 = vec2(((2.0 * var_682c6) * var_6efe0) + ((2.0 * var_4db26) * var_fbdd3), ((2.0 * var_2d9d7) * var_feb15) + ((2.0 * var_0c52d) * var_0fdea));
                    highp vec2 var_98dc0 = (v_ScreenNormalPosition.xy - v_Additional.xy) * (vec2(1.0) / (v_Additional.zw - vec2(var_43bc0.x * 0.5)));
                    var_87286 = var_98dc0;
                    var_615cc = dFdx(var_98dc0);
                    var_3fe1e = dFdy(var_98dc0);
                    highp vec2 var_c2fe3 = vec2(((2.0 * var_87286.x) * var_615cc.x) + ((2.0 * var_87286.y) * var_615cc.y), ((2.0 * var_87286.x) * var_3fe1e.x) + ((2.0 * var_87286.y) * var_3fe1e.y));
                    var_694ba = clamp(0.5 - ((dot(var_b91c8, var_b91c8) - 1.0) * inversesqrt(max(dot(var_04c69, var_04c69), 9.9999997473787516355514526367188e-05))), 0.0, 1.0) * clamp(0.5 + ((dot(var_98dc0, var_98dc0) - 1.0) * inversesqrt(max(dot(var_c2fe3, var_c2fe3), 9.9999997473787516355514526367188e-05))), 0.0, 1.0);
                }
                else
                {
                    highp float var_ddde2;
                    if (6.0 == float(var_c9987))
                    {
                        var_9aa42 = vec4(0.0);
                        highp vec4 var_ace95 = Data_PS[var_8998a];
                        highp vec4 var_7e301 = Data_PS[var_8998a + 1];
                        highp vec2 var_3a334;
                        for (int var_6696c = 0; float(var_6696c) < var_7e301.x; var_6696c++)
                        {
                            var_3a334.x = Data_PS[(var_8998a + 6) + ((var_6696c * 2) / 4)][(var_6696c * 2) % 4];
                            var_3a334.y = Data_PS[(var_8998a + 6) + (((var_6696c * 2) + 1) / 4)][((var_6696c * 2) + 1) % 4];
                            highp vec4 var_09c82 = vec4(v_Additional.xy + var_3a334, 0.0, 0.0);
                            highp vec4 var_67347 = vec4(v_Additional.xy - var_3a334, 0.0, 0.0);
                            bool var_050eb = var_ace95.z != (-1.0);
                            bool var_f434b;
                            if (!var_050eb)
                            {
                                var_f434b = var_ace95.w != (-1.0);
                            }
                            else
                            {
                                var_f434b = var_050eb;
                            }
                            if (var_f434b)
                            {
                                var_09c82.x = clamp(var_333b6.x + var_3a334.x, var_ace95.x, var_ace95.x + var_ace95.z);
                                var_09c82.y = clamp(var_333b6.y + var_3a334.y, var_ace95.y, var_ace95.y + var_ace95.w);
                                var_67347.x = clamp(var_333b6.x - var_3a334.x, var_ace95.x, var_ace95.x + var_ace95.z);
                                var_67347.y = clamp(var_333b6.y - var_3a334.y, var_ace95.y, var_ace95.y + var_ace95.w);
                            }
                            var_9aa42 += ((texture(s_txBuffer, (vec2(var_09c82.x, 1.0 - var_09c82.y) * UVTransform[0].zw) + UVTransform[0].xy) + texture(s_txBuffer, (vec2(var_67347.x, 1.0 - var_67347.y) * UVTransform[0].zw) + UVTransform[0].xy)) * Data_PS[(var_8998a + 3) + (var_6696c / 4)][var_6696c % 4]);
                        }
                        var_ddde2 = var_a33c5.w;
                    }
                    else
                    {
                        highp float var_df5f8;
                        if (7.0 == float(var_c9987))
                        {
                            highp vec2 var_d2bfb = v_Additional.xy;
                            highp vec4 var_c1770 = Data_PS[var_8998a];
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
                                var_d2bfb.x = clamp(var_d2bfb.x, var_c1770.x, var_c1770.x + var_c1770.z);
                                var_d2bfb.y = clamp(var_d2bfb.y, var_c1770.y, var_c1770.y + var_c1770.w);
                            }
                            highp vec4 var_11edb = texture(s_txBuffer, (vec2(var_d2bfb.x, 1.0 - var_d2bfb.y) * UVTransform[0].zw) + UVTransform[0].xy);
                            highp vec4 var_e7cba = var_11edb;
                            highp float var_6215c = var_e7cba.w;
                            highp float var_598f3 = max(var_6215c, 9.9999997473787516355514526367188e-06);
                            highp vec4 var_729fe = vec4(var_11edb.xyz / vec3(var_598f3), var_598f3);
                            var_e7cba = var_729fe;
                            var_9aa42.x = dot(var_729fe, Data_PS[var_8998a + 1]);
                            var_9aa42.y = dot(var_729fe, Data_PS[var_8998a + 2]);
                            var_9aa42.z = dot(var_729fe, Data_PS[var_8998a + 3]);
                            var_9aa42.w = dot(var_729fe, Data_PS[var_8998a + 4]);
                            highp vec4 var_ea70f = var_9aa42;
                            highp vec4 var_288d5 = var_ea70f + Data_PS[var_8998a + 5];
                            var_9aa42 = var_288d5;
                            highp vec3 var_635fc = var_288d5.xyz;
                            var_9aa42.w = mix(((0.2125999927520751953125 * var_635fc.x) + (0.715200006961822509765625 * var_635fc.y)) + (0.072200000286102294921875 * var_635fc.z), var_9aa42.w, var_a33c5.z);
                            highp float var_9f710 = var_9aa42.w;
                            var_9aa42.w = 1.0;
                            var_df5f8 = (var_9f710 * var_a33c5.w) * clamp(var_333b6.z, 0.0, 1.0);
                        }
                        else
                        {
                            bool var_53887 = 9.0 == float(var_c9987);
                            bool var_213e3;
                            if (!var_53887)
                            {
                                var_213e3 = 12.0 == float(var_c9987);
                            }
                            else
                            {
                                var_213e3 = var_53887;
                            }
                            highp float var_97871;
                            if (var_213e3)
                            {
                                highp vec3 var_4acc6;
                                var_4acc6.x = texture(s_txBuffer, (v_Additional.xy * UVTransform[0].zw) + UVTransform[0].xy).x;
                                var_4acc6.y = texture(s_txBuffer1, (v_Additional.xy * UVTransform[1].zw) + UVTransform[1].xy).x;
                                var_4acc6.z = texture(s_txBuffer2, (v_Additional.xy * UVTransform[2].zw) + UVTransform[2].xy).x;
                                highp vec3 var_0a617 = var_4acc6;
                                highp vec3 var_2ed72 = var_0a617 - vec3(0.0625, 0.5, 0.5);
                                var_4acc6 = var_2ed72;
                                highp float var_a1a5e = var_a33c5.w * clamp(var_333b6.z, 0.0, 1.0);
                                var_9aa42 = vec4(transpose(mat3(vec3(1.164000034332275390625, 0.0, 1.5959999561309814453125), vec3(1.164000034332275390625, -0.3910000026226043701171875, -0.813000023365020751953125), vec3(1.164000034332275390625, 2.0179998874664306640625, 0.0))) * var_2ed72, 1.0);
                                highp float var_87c33;
                                if (12.0 == float(var_c9987))
                                {
                                    var_87c33 = var_a1a5e * texture(s_txBuffer3, (v_Additional.xy * UVTransform[3].zw) + UVTransform[3].xy).x;
                                }
                                else
                                {
                                    var_87c33 = var_a1a5e;
                                }
                                var_97871 = var_87c33;
                            }
                            else
                            {
                                highp float var_fc133;
                                if (11.0 == float(var_c9987))
                                {
                                    var_fc133 = clamp((1.0 - clamp(abs(dot(v_Additional.xyz, vec3(v_ScreenNormalPosition.xy, 1.0))), 0.0, 1.0)) * var_333b6.w, 0.0, 1.0);
                                }
                                else
                                {
                                    if (19.0 == float(var_c9987))
                                    {
                                        highp vec4 var_85a00 = Data_PS[var_8998a];
                                        highp float var_9831a = sqrt(var_85a00.y * 0.5);
                                        highp float var_31273 = (0.5 * var_9831a) - 0.89999997615814208984375;
                                        highp float var_07a02 = ((var_85a00.z / var_85a00.y) * 0.5) * var_9831a;
                                        highp float var_3e548 = texture(s_txBuffer, (v_Additional.xy * UVTransform[0].zw) + UVTransform[0].xy).x * var_9831a;
                                        var_9aa42 = mix(Data_PS[var_8998a + 1], Data_PS[var_1821c], vec4(clamp(var_3e548 - (var_31273 + var_07a02), 0.0, 1.0))) * clamp(var_3e548 - max(0.0, var_31273 - var_07a02), 0.0, 1.0);
                                    }
                                    else
                                    {
                                        if (var_c9987 == 23)
                                        {
                                            highp vec4 var_06982 = texture(s_txBuffer, (v_Additional.xy * UVTransform[0].zw) + UVTransform[0].xy);
                                            highp float var_b46de = var_06982.x;
                                            highp vec4 var_d8e86 = Data_PS[var_8998a];
                                            highp float var_18ef0 = var_d8e86.z * var_d8e86.x;
                                            highp float var_8fc5c = 0.5 + (0.5 * var_18ef0);
                                            highp float var_07fc6 = var_8fc5c - var_18ef0;
                                            highp float var_a2aa7 = smoothstep(var_07fc6 - var_d8e86.x, var_07fc6 + var_d8e86.x, var_b46de);
                                            if (var_a2aa7 <= 0.0)
                                            {
                                                discard;
                                            }
                                            var_9aa42 = mix(Data_PS[var_8998a + 1], Data_PS[var_1821c], vec4(smoothstep(var_8fc5c - var_d8e86.x, var_8fc5c + var_d8e86.x, var_b46de))) * var_a2aa7;
                                        }
                                        else
                                        {
                                            if (var_c9987 == 24)
                                            {
                                                highp vec3 var_af28d = texture(s_txBuffer3, (v_Additional.xy * UVTransform[3].zw) + UVTransform[3].xy).xyz;
                                                var_9aa42 = Data_PS[var_1821c] * smoothstep(0.5 - var_333b6.z, 0.5 + var_333b6.z, max(min(var_af28d.x, var_af28d.y), min(max(var_af28d.x, var_af28d.y), var_af28d.z)));
                                            }
                                            else
                                            {
                                                if (var_c9987 == 25)
                                                {
                                                    highp vec3 var_ce8df = texture(s_txBuffer, (v_Additional.xy * UVTransform[0].zw) + UVTransform[0].xy).xyz;
                                                    highp vec4 var_5743b = Data_PS[var_8998a];
                                                    highp float var_6a413 = var_5743b.z * var_5743b.x;
                                                    highp float var_23cd3 = 0.5 + (0.5 * var_6a413);
                                                    highp float var_5ef07 = var_23cd3 - var_6a413;
                                                    highp float var_10811 = max(min(var_ce8df.x, var_ce8df.y), min(max(var_ce8df.x, var_ce8df.y), var_ce8df.z));
                                                    highp float var_fd049 = smoothstep(var_5ef07 - var_5743b.x, var_5ef07 + var_5743b.x, var_10811);
                                                    if (var_fd049 <= 0.0)
                                                    {
                                                        discard;
                                                    }
                                                    var_9aa42 = mix(Data_PS[var_8998a + 1], Data_PS[var_1821c], vec4(smoothstep(var_23cd3 - var_5743b.x, var_23cd3 + var_5743b.x, var_10811))) * var_fd049;
                                                }
                                            }
                                        }
                                    }
                                    var_fc133 = 1.0;
                                }
                                var_97871 = var_fc133;
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
        var_98b39 = var_736b5;
    }
    bgfx_FragColor = var_9aa42 * var_98b39;
}
