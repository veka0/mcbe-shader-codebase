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
layout(location = 0) out highp vec4 bgfx_FragColor;
void func_011ac(inout highp float arg_6b2b2, inout highp float arg_ca2fb) {
    if (arg_6b2b2 <= 0.003130800090730190277099609375)
    {
        arg_ca2fb = arg_6b2b2 * 12.9200000762939453125;
        return;
    }
    arg_ca2fb = (1.05499994754791259765625 * pow(arg_6b2b2, 0.4166666567325592041015625)) - 0.054999999701976776123046875;
}
void main() {
    highp vec4 var_20069 = v_Additional;
    uvec4 var_4581e = uvec4(v_VaryingData);
    int var_fe7e4 = int((var_4581e.z << uint(4)) | ((var_4581e.y & 240u) >> uint(4)));
    int var_95a4f = int(var_4581e.w);
    highp vec4 var_e5700 = Data_PS[var_fe7e4];
    highp vec4 var_1dc25 = Data_PS[var_fe7e4 + 1];
    highp vec4 var_1e2b1 = Data_PS[var_fe7e4];
    highp float var_1710e;
    if (0.0 == float(var_95a4f))
    {
        var_1710e = min(1.0, var_20069.z * var_20069.w);
    }
    else
    {
        highp float var_1387f;
        if (3.0 == float(var_95a4f))
        {
            highp vec2 var_8cc5a = v_Additional.xy;
            highp vec4 var_49a69 = Data_PS[int(var_1dc25.w)];
            bool var_3afc1 = var_49a69.z != (-1.0);
            bool var_30475;
            if (!var_3afc1)
            {
                var_30475 = var_49a69.w != (-1.0);
            }
            else
            {
                var_30475 = var_3afc1;
            }
            if (var_30475)
            {
                var_8cc5a.x = clamp(var_20069.x, var_49a69.x, var_49a69.x + var_49a69.z);
                var_8cc5a.y = clamp(var_20069.y, var_49a69.y, var_49a69.y + var_49a69.w);
            }
            var_1e2b1 = texture(s_txBuffer, (vec2(var_8cc5a.x, 1.0 - var_8cc5a.y) * UVTransform[0].zw) + UVTransform[0].xy);
            var_1e2b1.w = mix(1.0 - var_1e2b1.w, var_1e2b1.w, var_e5700.x);
            highp vec3 var_0beb9 = var_1e2b1.xyz;
            var_1e2b1.w = mix(((0.2125999927520751953125 * var_0beb9.x) + (0.715200006961822509765625 * var_0beb9.y)) + (0.072200000286102294921875 * var_0beb9.z), var_1e2b1.w, var_e5700.z);
            var_1387f = var_e5700.w * clamp(var_20069.z, 0.0, 1.0);
        }
        else
        {
            highp float var_b5f11;
            if (17.0 == float(var_95a4f))
            {
                highp vec4 var_116cc = texture(s_txBuffer1, (v_Additional.xy * UVTransform[1].zw) + UVTransform[1].xy);
                highp vec3 var_662e7 = Data_PS[var_fe7e4].xyz;
                highp float var_c5996 = ((0.2125999927520751953125 * var_662e7.x) + (0.715200006961822509765625 * var_662e7.y)) + (0.072200000286102294921875 * var_662e7.z);
                highp float var_8dbe5;
                if ((int(var_1dc25.y) & 1) != 0)
                {
                    highp float var_94c89;
                    func_011ac(var_c5996, var_94c89);
                    var_8dbe5 = var_94c89;
                }
                else
                {
                    var_8dbe5 = var_c5996;
                }
                var_1e2b1 = Data_PS[var_fe7e4] * pow(abs(var_116cc.x), 1.4500000476837158203125 - var_8dbe5);
                var_b5f11 = 1.0;
            }
            else
            {
                highp float var_78c7e;
                if (18.0 == float(var_95a4f))
                {
                    highp vec4 var_77a54 = texture(s_txBuffer2, (v_Additional.xy * UVTransform[2].zw) + UVTransform[2].xy);
                    highp vec3 var_62605 = Data_PS[var_fe7e4].xyz;
                    highp float var_b9e21 = ((0.2125999927520751953125 * var_62605.x) + (0.715200006961822509765625 * var_62605.y)) + (0.072200000286102294921875 * var_62605.z);
                    highp float var_21124;
                    if ((int(var_1dc25.y) & 1) != 0)
                    {
                        highp float var_6fbe6;
                        func_011ac(var_b9e21, var_6fbe6);
                        var_21124 = var_6fbe6;
                    }
                    else
                    {
                        var_21124 = var_b9e21;
                    }
                    var_1e2b1 = Data_PS[var_fe7e4] * pow(abs(smoothstep((-0.501960813999176025390625) / var_20069.z, 0.501960813999176025390625 / var_20069.z, (var_77a54.x * 7.96875) - 3.984375)), 1.4500000476837158203125 - var_21124);
                    var_78c7e = 1.0;
                }
                else
                {
                    highp float var_aef2c;
                    if (22.0 == float(var_95a4f))
                    {
                        highp vec4 var_c9626 = texture(s_txBuffer2, (v_Additional.xy * UVTransform[2].zw) + UVTransform[2].xy);
                        highp vec3 var_58206 = Data_PS[var_fe7e4].xyz;
                        highp float var_36ed2 = ((0.2125999927520751953125 * var_58206.x) + (0.715200006961822509765625 * var_58206.y)) + (0.072200000286102294921875 * var_58206.z);
                        highp float var_60cee;
                        if ((int(var_1dc25.y) & 1) != 0)
                        {
                            highp float var_742fc;
                            func_011ac(var_36ed2, var_742fc);
                            var_60cee = var_742fc;
                        }
                        else
                        {
                            var_60cee = var_36ed2;
                        }
                        var_1e2b1 = Data_PS[var_fe7e4] * pow(abs(smoothstep(0.5 - var_20069.z, 0.5 + var_20069.z, var_c9626.x)), 1.4500000476837158203125 - var_60cee);
                        var_aef2c = 1.0;
                    }
                    else
                    {
                        highp float var_b79c6;
                        if (30.0 == float(var_95a4f))
                        {
                            var_b79c6 = texture(s_txBuffer, (v_Additional.xy * UVTransform[0].zw) + UVTransform[0].xy).x;
                        }
                        else
                        {
                            highp float var_5b470;
                            if (31.0 == float(var_95a4f))
                            {
                                var_1e2b1 = texture(s_txBuffer, (((Data_PS[var_fe7e4].zw * vec2(fract(v_Additional.xy).x, 1.0 - fract(v_Additional.xy).y)) + Data_PS[var_fe7e4].xy) * UVTransform[0].zw) + UVTransform[0].xy);
                                highp float var_a6166;
                                if ((int(var_1dc25.x) & 1) != 0)
                                {
                                    var_a6166 = 1.0 - var_1e2b1.w;
                                }
                                else
                                {
                                    var_a6166 = var_1e2b1.w;
                                }
                                var_1e2b1.w = var_a6166;
                                highp float var_d5391;
                                if ((int(var_1dc25.x) & 4) != 0)
                                {
                                    highp vec3 var_48885 = var_1e2b1.xyz;
                                    var_d5391 = clamp(((0.2125999927520751953125 * var_48885.x) + (0.715200006961822509765625 * var_48885.y)) + (0.072200000286102294921875 * var_48885.z), 0.0, 1.0);
                                }
                                else
                                {
                                    var_d5391 = var_1e2b1.w;
                                }
                                var_1e2b1.w = var_d5391;
                                highp float var_a8c62;
                                if ((int(var_1dc25.x) & 2) != 0)
                                {
                                    var_a8c62 = 1.0;
                                }
                                else
                                {
                                    var_a8c62 = var_1e2b1.w;
                                }
                                var_1e2b1.w = var_a8c62;
                                var_5b470 = var_20069.w * clamp(var_20069.z, 0.0, 1.0);
                            }
                            else
                            {
                                var_5b470 = 1.0;
                            }
                            var_b79c6 = var_5b470;
                        }
                        var_aef2c = var_b79c6;
                    }
                    var_78c7e = var_aef2c;
                }
                var_b5f11 = var_78c7e;
            }
            var_1387f = var_b5f11;
        }
        var_1710e = var_1387f;
    }
    bgfx_FragColor = var_1e2b1 * var_1710e;
}
