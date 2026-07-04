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
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_txBuffer1;
uniform highp sampler2D s_txBuffer2;
uniform highp sampler2D s_txBuffer;
uniform highp vec4 Data_PS[128];
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
    highp vec4 var_2f40a = v_Additional;
    uvec4 var_4581e = uvec4(v_VaryingData);
    int var_c37fe = int((var_4581e.z << uint(4)) | ((var_4581e.y & 240u) >> uint(4)));
    int var_9fd69 = int(var_4581e.w);
    highp vec4 var_5f024 = Data_PS[var_c37fe];
    highp vec4 var_6e7e8 = Data_PS[var_c37fe + 1];
    highp float var_26c81;
    if (0.0 == float(var_9fd69))
    {
        var_26c81 = min(1.0, var_2f40a.z * var_2f40a.w);
    }
    else
    {
        highp float var_a4790;
        if (3.0 == float(var_9fd69))
        {
            var_5f024 = texture(s_txBuffer, vec2(var_2f40a.x, 1.0 - var_2f40a.y));
            var_a4790 = var_5f024.w;
        }
        else
        {
            highp float var_b5f11;
            if (17.0 == float(var_9fd69))
            {
                highp vec4 var_42aa6 = texture(s_txBuffer1, v_Additional.xy);
                highp vec3 var_63dba = v_Color_.xyz;
                highp float var_c5996 = ((0.2125999927520751953125 * var_63dba.x) + (0.715200006961822509765625 * var_63dba.y)) + (0.072200000286102294921875 * var_63dba.z);
                highp float var_54a4f;
                if ((int(var_6e7e8.y) & 1) != 0)
                {
                    highp float var_94c89;
                    func_011ac(var_c5996, var_94c89);
                    var_54a4f = var_94c89;
                }
                else
                {
                    var_54a4f = var_c5996;
                }
                var_5f024 = v_Color_ * pow(abs(var_42aa6.x), 1.4500000476837158203125 - var_54a4f);
                var_b5f11 = 1.0;
            }
            else
            {
                highp float var_78c7e;
                if (18.0 == float(var_9fd69))
                {
                    highp vec4 var_2fe82 = texture(s_txBuffer2, v_Additional.xy);
                    highp vec4 var_6b1bb = vec4(-1.0);
                    highp vec3 var_093d9 = v_Color_.xyz;
                    highp float var_b9e21 = ((0.2125999927520751953125 * var_093d9.x) + (0.715200006961822509765625 * var_093d9.y)) + (0.072200000286102294921875 * var_093d9.z);
                    highp float var_42e75;
                    if ((int(var_6e7e8.y) & 1) != 0)
                    {
                        highp float var_6fbe6;
                        func_011ac(var_b9e21, var_6fbe6);
                        var_42e75 = var_6fbe6;
                    }
                    else
                    {
                        var_42e75 = var_b9e21;
                    }
                    var_5f024 = v_Color_ * pow(abs(smoothstep((-0.501960813999176025390625) / var_6b1bb.x, 0.501960813999176025390625 / var_6b1bb.x, (var_2fe82.x * 7.96875) - 3.984375)), 1.4500000476837158203125 - var_42e75);
                    var_78c7e = 1.0;
                }
                else
                {
                    highp float var_4ae87;
                    if (31.0 == float(var_9fd69))
                    {
                        var_5f024 = texture(s_txBuffer, (var_5f024.zw * vec2(fract(v_Additional.xy).x, 1.0 - fract(v_Additional.xy).y)) + var_5f024.xy);
                        var_4ae87 = var_5f024.w;
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
