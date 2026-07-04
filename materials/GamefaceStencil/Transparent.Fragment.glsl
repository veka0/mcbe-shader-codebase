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
    highp vec4 var_b0825 = v_Additional;
    uvec4 var_eb4ac = uvec4(v_VaryingData);
    int var_8e4d8 = int((var_eb4ac.z << 4u) | ((var_eb4ac.y & 240u) >> 4u));
    int var_998b1 = int(var_eb4ac.w);
    highp vec4 var_45e84 = Data_PS[var_8e4d8];
    highp vec4 var_5349b = Data_PS[var_8e4d8 + 1];
    int var_fc151 = max(0, (int(var_45e84.x) + (-1)));
    highp float var_26c81;
    if (0 == var_998b1)
    {
        var_26c81 = min(1.0, var_b0825.z * var_b0825.w);
    }
    else
    {
        highp float var_a4790;
        if (3 == var_998b1)
        {
            var_5349b = texture(s_txBuffer, (vec2(var_b0825.x, 1.0 - var_b0825.y) * UVTransform[0].zw) + UVTransform[0].xy);
            var_a4790 = var_5349b.w;
        }
        else
        {
            highp float var_b5f11;
            if (17 == var_998b1)
            {
                highp vec4 var_734d6 = texture(s_txBuffer1, (v_Additional.xy * UVTransform[1].zw) + UVTransform[1].xy);
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
                var_5349b = v_Color_ * pow(abs(var_734d6.x), max(abs(1.4500000476837158203125 - var_15585), 9.9999997473787516355514526367188e-05));
                var_b5f11 = 1.0;
            }
            else
            {
                highp float var_78c7e;
                if (18 == var_998b1)
                {
                    highp vec4 var_5e399 = texture(s_txBuffer2, (v_Additional.xy * UVTransform[2].zw) + UVTransform[2].xy);
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
                    var_5349b = v_Color_ * pow(abs(smoothstep((-0.501960813999176025390625) / var_a7043.x, 0.501960813999176025390625 / var_a7043.x, (var_5e399.x * 7.96875) - 3.984375)), max(abs(1.4500000476837158203125 - var_a05c0), 9.9999997473787516355514526367188e-05));
                    var_78c7e = 1.0;
                }
                else
                {
                    highp float var_4ae87;
                    if (34 == var_998b1)
                    {
                        var_5349b = texture(s_txBuffer, (((var_5349b.zw * vec2(fract(v_Additional.xy).x, 1.0 - fract(v_Additional.xy).y)) + var_5349b.xy) * UVTransform[0].zw) + UVTransform[0].xy);
                        var_4ae87 = var_5349b.w;
                    }
                    else
                    {
                        var_4ae87 = 1.0;
                    }
                    var_78c7e = var_4ae87;
                }
                var_b5f11 = var_78c7e;
            }
            var_a4790 = var_b5f11;
        }
        var_26c81 = var_a4790;
    }
    if (var_26c81 < 0.00390625)
    {
        discard;
    }
    bgfx_FragColor = vec4(0.0);
}
