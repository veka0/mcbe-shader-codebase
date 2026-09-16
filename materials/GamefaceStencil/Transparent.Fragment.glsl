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
in highp vec4 v_Color_;
flat in highp vec4 v_VaryingData;
layout(location = 0) out highp vec4 bgfx_FragData0;
void func_011ac(inout highp float arg_6b2b2, inout highp float arg_ca2fb) {
    if (arg_6b2b2 <= 0.003130800090730190277099609375)
    {
        arg_ca2fb = arg_6b2b2 * 12.9200000762939453125;
        return;
    }
    arg_ca2fb = (1.05499994754791259765625 * pow(arg_6b2b2, 0.4166666567325592041015625)) - 0.054999999701976776123046875;
}
void main() {
    highp vec4 var_d1b66 = v_Additional;
    uvec4 var_eb4ac = uvec4(v_VaryingData);
    int var_8e4d8 = int((var_eb4ac.z << 4u) | ((var_eb4ac.y & 240u) >> 4u));
    int var_5cdc1 = int(var_eb4ac.w);
    highp vec4 var_45e84 = Data_PS[var_8e4d8];
    highp vec4 var_c2873 = Data_PS[var_8e4d8 + 1];
    int var_fc151 = max(0, (int(var_45e84.x) + (-1)));
    highp float var_f7889;
    if (0 == var_5cdc1)
    {
        var_f7889 = min(1.0, var_d1b66.z * var_d1b66.w);
    }
    else
    {
        highp float var_a4790;
        if (3 == var_5cdc1)
        {
            highp vec2 var_3ebfa = vec2(var_d1b66.x, 1.0 - var_d1b66.y);
            highp float var_74cec = var_3ebfa.x;
            highp float var_83bc9 = var_3ebfa.y;
            highp vec2 var_7fea2 = vec2(var_74cec, 1.0 - var_83bc9);
            var_3ebfa = var_7fea2;
            var_c2873 = texture(s_txBuffer, vec2(((var_7fea2 * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_7fea2 * UVTransform[0].zw) + UVTransform[0].xy).y));
            var_a4790 = var_c2873.w;
        }
        else
        {
            highp float var_b5f11;
            if (17 == var_5cdc1)
            {
                highp vec2 var_a1a3d = v_Additional.xy;
                highp float var_92159 = var_a1a3d.x;
                highp float var_7e2a6 = var_a1a3d.y;
                highp vec2 var_87caf = vec2(var_92159, 1.0 - var_7e2a6);
                var_a1a3d = var_87caf;
                highp vec4 var_aecf6 = texture(s_txBuffer1, vec2(((var_87caf * UVTransform[1].zw) + UVTransform[1].xy).x, 1.0 - ((var_87caf * UVTransform[1].zw) + UVTransform[1].xy).y));
                highp vec3 var_63dba = v_Color_.xyz;
                highp float var_c5996 = ((0.2125999927520751953125 * var_63dba.x) + (0.715200006961822509765625 * var_63dba.y)) + (0.072200000286102294921875 * var_63dba.z);
                highp float var_15585;
                if ((int(Data_PS[var_fc151].y) & 1) != 0)
                {
                    highp float var_94c89;
                    func_011ac(var_c5996, var_94c89);
                    var_15585 = var_94c89;
                }
                else
                {
                    var_15585 = var_c5996;
                }
                var_c2873 = v_Color_ * pow(abs(var_aecf6.x), max(abs(1.4500000476837158203125 - var_15585), 9.9999997473787516355514526367188e-05));
                var_b5f11 = 1.0;
            }
            else
            {
                highp float var_78c7e;
                if (18 == var_5cdc1)
                {
                    highp vec2 var_b985e = v_Additional.xy;
                    highp float var_1ce3f = var_b985e.x;
                    highp float var_eb157 = var_b985e.y;
                    highp vec2 var_81f03 = vec2(var_1ce3f, 1.0 - var_eb157);
                    var_b985e = var_81f03;
                    highp vec4 var_65539 = texture(s_txBuffer2, vec2(((var_81f03 * UVTransform[2].zw) + UVTransform[2].xy).x, 1.0 - ((var_81f03 * UVTransform[2].zw) + UVTransform[2].xy).y));
                    highp vec4 var_a7043 = vec4(-1.0);
                    highp vec3 var_093d9 = v_Color_.xyz;
                    highp float var_b9e21 = ((0.2125999927520751953125 * var_093d9.x) + (0.715200006961822509765625 * var_093d9.y)) + (0.072200000286102294921875 * var_093d9.z);
                    highp float var_a05c0;
                    if ((int(Data_PS[var_fc151].y) & 1) != 0)
                    {
                        highp float var_6fbe6;
                        func_011ac(var_b9e21, var_6fbe6);
                        var_a05c0 = var_6fbe6;
                    }
                    else
                    {
                        var_a05c0 = var_b9e21;
                    }
                    var_c2873 = v_Color_ * pow(abs(smoothstep((-0.501960813999176025390625) / var_a7043.x, 0.501960813999176025390625 / var_a7043.x, (var_65539.x * 7.96875) - 3.984375)), max(abs(1.4500000476837158203125 - var_a05c0), 9.9999997473787516355514526367188e-05));
                    var_78c7e = 1.0;
                }
                else
                {
                    highp float var_ddde2;
                    if (34 == var_5cdc1)
                    {
                        highp vec2 var_fed34 = (var_c2873.zw * vec2(fract(v_Additional.xy).x, 1.0 - fract(v_Additional.xy).y)) + var_c2873.xy;
                        highp float var_0587e = var_fed34.x;
                        highp float var_347fa = var_fed34.y;
                        highp vec2 var_a9207 = vec2(var_0587e, 1.0 - var_347fa);
                        var_fed34 = var_a9207;
                        var_c2873 = texture(s_txBuffer, vec2(((var_a9207 * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_a9207 * UVTransform[0].zw) + UVTransform[0].xy).y));
                        var_ddde2 = var_c2873.w;
                    }
                    else
                    {
                        highp float var_b837f;
                        if (36 == var_5cdc1)
                        {
                            highp vec2 var_d7024 = v_Additional.xy;
                            highp float var_7c2cb = var_d7024.x;
                            highp float var_76ed8 = var_d7024.y;
                            highp vec2 var_30618 = vec2(var_7c2cb, 1.0 - var_76ed8);
                            var_d7024 = var_30618;
                            var_b837f = texture(s_txBuffer, vec2(((var_30618 * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_30618 * UVTransform[0].zw) + UVTransform[0].xy).y)).x;
                        }
                        else
                        {
                            var_b837f = 1.0;
                        }
                        var_ddde2 = var_b837f;
                    }
                    var_78c7e = var_ddde2;
                }
                var_b5f11 = var_78c7e;
            }
            var_a4790 = var_b5f11;
        }
        var_f7889 = var_a4790;
    }
    if (var_f7889 < 0.0039215688593685626983642578125)
    {
        discard;
    }
    bgfx_FragData0 = vec4(0.0);
}
