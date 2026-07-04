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
* - uniform vec4 TextureSize1;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_txBuffer1;
uniform highp sampler2D s_txBuffer2;
uniform highp sampler2D s_txBuffer;
uniform highp vec4 Data_PS[128];
in highp vec4 v_Additional;
flat in highp vec4 v_VaryingData;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_c8ac5 = v_Additional;
    uvec4 var_4581e = uvec4(v_VaryingData);
    int var_824d1 = int((var_4581e.z << uint(4)) | ((var_4581e.y & 240u) >> uint(4)));
    int var_c73bc = int(var_4581e.w);
    highp vec4 var_e5700 = Data_PS[var_824d1];
    highp vec4 var_4d1c7 = Data_PS[var_824d1 + 1];
    highp vec4 var_80255 = Data_PS[var_824d1];
    highp float var_1710e;
    if (0.0 == float(var_c73bc))
    {
        var_1710e = min(1.0, var_c8ac5.z * var_c8ac5.w);
    }
    else
    {
        highp float var_f4dd1;
        if (3.0 == float(var_c73bc))
        {
            highp vec2 var_a37ad = v_Additional.xy;
            highp vec4 var_49a69 = Data_PS[int(var_4d1c7.w)];
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
                var_a37ad.x = clamp(var_c8ac5.x, var_49a69.x, var_49a69.x + var_49a69.z);
                var_a37ad.y = clamp(var_c8ac5.y, var_49a69.y, var_49a69.y + var_49a69.w);
            }
            var_80255 = texture(s_txBuffer, vec2(var_a37ad.x, 1.0 - var_a37ad.y));
            var_80255.w = mix(1.0 - var_80255.w, var_80255.w, var_e5700.x);
            var_80255.w = mix(((0.2125999927520751953125 * var_80255.x) + (0.715200006961822509765625 * var_80255.y)) + (0.072200000286102294921875 * var_80255.z), var_80255.w, var_e5700.z);
            var_f4dd1 = var_e5700.w * clamp(var_c8ac5.z, 0.0, 1.0);
        }
        else
        {
            if (17.0 == float(var_c73bc))
            {
                var_80255 = Data_PS[var_824d1] * pow(abs(texture(s_txBuffer1, v_Additional.xy).x), 1.4500000476837158203125 - (((0.2125999927520751953125 * Data_PS[var_824d1].x) + (0.715200006961822509765625 * Data_PS[var_824d1].y)) + (0.072200000286102294921875 * Data_PS[var_824d1].z)));
            }
            else
            {
                if (18.0 == float(var_c73bc))
                {
                    var_80255 = Data_PS[var_824d1] * pow(abs(smoothstep((-0.501960813999176025390625) / var_c8ac5.z, 0.501960813999176025390625 / var_c8ac5.z, (texture(s_txBuffer2, v_Additional.xy).x * 7.96875) - 3.984375)), 1.4500000476837158203125 - (((0.2125999927520751953125 * Data_PS[var_824d1].x) + (0.715200006961822509765625 * Data_PS[var_824d1].y)) + (0.072200000286102294921875 * Data_PS[var_824d1].z)));
                }
                else
                {
                    if (22.0 == float(var_c73bc))
                    {
                        var_80255 = Data_PS[var_824d1] * pow(abs(smoothstep(0.5 - var_c8ac5.z, 0.5 + var_c8ac5.z, texture(s_txBuffer2, v_Additional.xy).x)), 1.4500000476837158203125 - (((0.2125999927520751953125 * Data_PS[var_824d1].x) + (0.715200006961822509765625 * Data_PS[var_824d1].y)) + (0.072200000286102294921875 * Data_PS[var_824d1].z)));
                    }
                }
            }
            var_f4dd1 = 1.0;
        }
        var_1710e = var_f4dd1;
    }
    bgfx_FragColor = var_80255 * var_1710e;
}
