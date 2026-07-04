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
* - uniform vec4 GradientEndColor;
* - uniform vec4 GradientMidColor;
* - uniform vec4 GradientStartColor;
* - uniform vec4 GradientYCoord;
* - uniform vec4 MaskScaleAndOffset;
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
in highp vec4 v_VaryingParam0;
in highp vec4 v_VaryingParam1;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_1eeaa = v_Additional;
    highp vec4 var_55b3f = v_VaryingParam0;
    uvec4 var_c4012 = uvec4(v_VaryingData);
    int var_2e59a = int((var_c4012.z << uint(4)) | ((var_c4012.y & 240u) >> uint(4)));
    int var_ce8e3 = int(Data_PS[var_2e59a].x);
    highp vec4 var_0962a = Data_PS[var_2e59a + 1];
    int var_c46b9 = int(var_0962a.w);
    highp float var_ac5a3;
    if ((var_ce8e3 & 2) != 0)
    {
        var_ac5a3 = var_55b3f.x;
    }
    else
    {
        highp float var_dcb77;
        if ((var_ce8e3 & 4) != 0)
        {
            var_dcb77 = length(v_VaryingParam0.xy);
        }
        else
        {
            highp float var_d6a52;
            if ((var_ce8e3 & 8) != 0)
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
    if ((var_ce8e3 & 256) != 0)
    {
        var_bb57e = fract(var_ac5a3);
    }
    else
    {
        highp float var_669fd;
        if ((var_ce8e3 & 512) != 0)
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
    highp vec4 var_106db;
    if ((var_ce8e3 & 16) != 0)
    {
        var_106db = mix(Data_PS[var_c46b9], Data_PS[var_c46b9 + 1], vec4(clamp(var_bb57e, 0.0, 1.0)));
    }
    else
    {
        highp vec4 var_3ed45;
        if ((var_ce8e3 & 32) != 0)
        {
            highp float var_6a899 = 2.0 * var_bb57e;
            highp float var_bee6c = 1.0 - var_6a899;
            var_3ed45 = ((Data_PS[var_c46b9] * clamp(var_bee6c, 0.0, 1.0)) + (Data_PS[var_c46b9 + 1] * (1.0 - min(abs(var_bee6c), 1.0)))) + (Data_PS[var_c46b9 + 2] * clamp(var_6a899 - 1.0, 0.0, 1.0));
        }
        else
        {
            highp vec4 var_45884;
            if ((var_ce8e3 & 64) != 0)
            {
                var_45884 = texture(s_txBuffer2, (vec2(var_bb57e, Data_PS[var_c46b9].x) * UVTransform[2].zw) + UVTransform[2].xy);
            }
            else
            {
                highp vec4 var_9b732;
                if ((var_ce8e3 & 1) != 0)
                {
                    var_9b732 = texture(s_txBuffer, (vec2(var_1eeaa.x, 1.0 - var_1eeaa.y) * UVTransform[0].zw) + UVTransform[0].xy);
                }
                else
                {
                    var_9b732 = vec4(0.0);
                }
                var_45884 = var_9b732;
            }
            var_3ed45 = var_45884;
        }
        var_106db = var_3ed45;
    }
    highp vec4 var_b2149;
    if ((var_ce8e3 & 128) != 0)
    {
        var_b2149 = var_106db * texture(s_txBuffer1, (v_VaryingParam1.xy * UVTransform[1].zw) + UVTransform[1].xy).w;
    }
    else
    {
        var_b2149 = var_106db;
    }
    bgfx_FragColor = var_b2149 * clamp(var_1eeaa.z, 0.0, 1.0);
}
