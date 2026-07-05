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
in highp vec3 v_ScreenNormalPosition;
flat in highp vec4 v_VaryingData;
in highp vec4 v_VaryingParam0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_5a4fe = v_Additional;
    highp vec4 var_55b3f = v_VaryingParam0;
    uvec4 var_05e85 = uvec4(v_VaryingData);
    int var_9e7e1 = int((var_05e85.z << 4u) | ((var_05e85.y & 240u) >> 4u));
    int var_c17cd = var_9e7e1 + 1;
    highp vec4 var_05977 = Data_PS[var_9e7e1];
    int var_447d9 = int(var_05977.y);
    int var_7df13 = int(var_05977.x);
    highp float var_ac5a3;
    if ((var_447d9 & 2) != 0)
    {
        var_ac5a3 = var_55b3f.x;
    }
    else
    {
        highp float var_dcb77;
        if ((var_447d9 & 4) != 0)
        {
            var_dcb77 = length(v_VaryingParam0.xy);
        }
        else
        {
            highp float var_d6a52;
            if ((var_447d9 & 8) != 0)
            {
                var_d6a52 = (3.1415927410125732421875 + atan(var_55b3f.y, var_55b3f.x)) * 0.15915493667125701904296875;
            }
            else
            {
                var_d6a52 = 0.0;
            }
            var_dcb77 = var_d6a52;
        }
        var_ac5a3 = var_dcb77;
    }
    highp float var_bb57e;
    if ((var_447d9 & 256) != 0)
    {
        var_bb57e = fract(var_ac5a3);
    }
    else
    {
        highp float var_669fd;
        if ((var_447d9 & 512) != 0)
        {
            highp float var_f4252 = 2.0 * fract(var_ac5a3 * 0.5);
            highp float var_e18f1;
            if (var_f4252 < 1.0)
            {
                var_e18f1 = var_f4252;
            }
            else
            {
                var_e18f1 = 2.0 - var_f4252;
            }
            var_669fd = var_e18f1;
        }
        else
        {
            var_669fd = var_ac5a3;
        }
        var_bb57e = var_669fd;
    }
    highp vec4 var_eae89;
    if ((var_447d9 & 16) != 0)
    {
        var_eae89 = mix(Data_PS[var_7df13], Data_PS[var_7df13 + 1], vec4(clamp(var_bb57e, 0.0, 1.0)));
    }
    else
    {
        highp vec4 var_3ed45;
        if ((var_447d9 & 32) != 0)
        {
            highp float var_6a899 = 2.0 * var_bb57e;
            highp float var_bee6c = 1.0 - var_6a899;
            var_3ed45 = ((Data_PS[var_7df13] * clamp(var_bee6c, 0.0, 1.0)) + (Data_PS[var_7df13 + 1] * (1.0 - min(abs(var_bee6c), 1.0)))) + (Data_PS[var_7df13 + 2] * clamp(var_6a899 - 1.0, 0.0, 1.0));
        }
        else
        {
            highp vec4 var_45884;
            if ((var_447d9 & 64) != 0)
            {
                var_45884 = texture(s_txBuffer2, (vec2(var_bb57e, Data_PS[var_7df13].x) * UVTransform[2].zw) + UVTransform[2].xy);
            }
            else
            {
                highp vec4 var_9b732;
                if ((var_447d9 & 1) != 0)
                {
                    var_9b732 = texture(s_txBuffer, (vec2(var_5a4fe.x, 1.0 - var_5a4fe.y) * UVTransform[0].zw) + UVTransform[0].xy);
                }
                else
                {
                    var_9b732 = vec4(0.0);
                }
                var_45884 = var_9b732;
            }
            var_3ed45 = var_45884;
        }
        var_eae89 = var_3ed45;
    }
    highp vec4 var_86e7b;
    if ((var_447d9 & 128) != 0)
    {
        var_86e7b = var_eae89 * texture(s_txBuffer1, (((v_ScreenNormalPosition.xy * Data_PS[var_c17cd].xy) + Data_PS[var_c17cd].zw) * UVTransform[1].zw) + UVTransform[1].xy).w;
    }
    else
    {
        var_86e7b = var_eae89;
    }
    bgfx_FragColor = (var_86e7b * var_05977.w) * clamp(var_5a4fe.z, 0.0, 1.0);
}
