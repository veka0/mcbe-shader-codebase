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
void main() {
    highp vec4 var_2f40a = v_Additional;
    uvec4 var_0e06f = uvec4(v_VaryingData);
    int var_262e9 = int(var_0e06f.w);
    highp vec4 var_38a7e = Data_PS[int((var_0e06f.z << uint(4)) | ((var_0e06f.y & 240u) >> uint(4)))];
    highp float var_26c81;
    if (0.0 == float(var_262e9))
    {
        var_26c81 = min(1.0, var_2f40a.z * var_2f40a.w);
    }
    else
    {
        highp float var_d604b;
        if (3.0 == float(var_262e9))
        {
            var_38a7e = texture(s_txBuffer, vec2(var_2f40a.x, 1.0 - var_2f40a.y));
            var_d604b = var_38a7e.w;
        }
        else
        {
            if (17.0 == float(var_262e9))
            {
                var_38a7e = v_Color_ * pow(abs(texture(s_txBuffer1, v_Additional.xy).x), 1.4500000476837158203125 - (((0.2125999927520751953125 * v_Color_.x) + (0.715200006961822509765625 * v_Color_.y)) + (0.072200000286102294921875 * v_Color_.z)));
            }
            else
            {
                if (18.0 == float(var_262e9))
                {
                    highp vec4 var_f8ad3 = vec4(-1.0);
                    var_38a7e = v_Color_ * pow(abs(smoothstep((-0.501960813999176025390625) / var_f8ad3.x, 0.501960813999176025390625 / var_f8ad3.x, (texture(s_txBuffer2, v_Additional.xy).x * 7.96875) - 3.984375)), 1.4500000476837158203125 - (((0.2125999927520751953125 * v_Color_.x) + (0.715200006961822509765625 * v_Color_.y)) + (0.072200000286102294921875 * v_Color_.z)));
                }
            }
            var_d604b = 1.0;
        }
        var_26c81 = var_d604b;
    }
    if (var_26c81 < 0.00390625)
    {
        discard;
    }
    bgfx_FragColor = vec4(0.0);
}
