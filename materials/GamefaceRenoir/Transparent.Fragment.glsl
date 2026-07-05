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
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_txBuffer1;
uniform highp sampler2D s_txBuffer2;
uniform highp sampler2D s_txBuffer;
uniform highp vec4 Data_PS[128];
in highp vec4 v_Additional;
flat in highp vec4 v_VaryingData;
in highp vec4 v_VaryingParam0;
in highp vec4 v_VaryingParam1;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_46800 = v_Additional;
    highp vec4 var_55b3f = v_VaryingParam0;
    uvec4 var_c4012 = uvec4(v_VaryingData);
    int var_2e59a = int((var_c4012.z << uint(4)) | ((var_c4012.y & 240u) >> uint(4)));
    int var_ce8e3 = int(Data_PS[var_2e59a].x);
    highp vec4 var_0962a = Data_PS[var_2e59a + 1];
    int var_7e92c = int(var_0962a.w);
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
    highp float var_f9d53;
    if ((var_ce8e3 & 256) != 0)
    {
        var_f9d53 = fract(var_ac5a3);
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
        var_f9d53 = var_669fd;
    }
    highp vec4 var_5db22;
    if ((var_ce8e3 & 16) != 0)
    {
        var_5db22 = mix(Data_PS[var_7e92c], Data_PS[var_7e92c + 1], vec4(clamp(var_f9d53, 0.0, 1.0)));
    }
    else
    {
        highp vec4 var_3ed45;
        if ((var_ce8e3 & 32) != 0)
        {
            highp float var_6a899 = 2.0 * var_f9d53;
            highp float var_bee6c = 1.0 - var_6a899;
            var_3ed45 = ((Data_PS[var_7e92c] * clamp(var_bee6c, 0.0, 1.0)) + (Data_PS[var_7e92c + 1] * (1.0 - min(abs(var_bee6c), 1.0)))) + (Data_PS[var_7e92c + 2] * clamp(var_6a899 - 1.0, 0.0, 1.0));
        }
        else
        {
            highp vec4 var_e7fa9;
            if ((var_ce8e3 & 64) != 0)
            {
                var_e7fa9 = texture(s_txBuffer2, vec2(var_f9d53, Data_PS[var_7e92c].x));
            }
            else
            {
                highp vec4 var_95660;
                if ((var_ce8e3 & 1) != 0)
                {
                    var_95660 = texture(s_txBuffer, vec2(var_46800.x, 1.0 - var_46800.y));
                }
                else
                {
                    var_95660 = vec4(0.0);
                }
                var_e7fa9 = var_95660;
            }
            var_3ed45 = var_e7fa9;
        }
        var_5db22 = var_3ed45;
    }
    highp vec4 var_f6a9d;
    if ((var_ce8e3 & 128) != 0)
    {
        var_f6a9d = var_5db22 * texture(s_txBuffer1, v_VaryingParam1.xy).w;
    }
    else
    {
        var_f6a9d = var_5db22;
    }
    bgfx_FragColor = var_f6a9d * clamp(var_46800.z, 0.0, 1.0);
}
