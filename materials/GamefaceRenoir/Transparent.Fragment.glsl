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
    highp vec4 var_c4329 = v_Additional;
    highp vec4 var_55b3f = v_VaryingParam0;
    uvec4 var_05e85 = uvec4(v_VaryingData);
    int var_9e7e1 = int((var_05e85.z << 4u) | ((var_05e85.y & 240u) >> 4u));
    int var_4251f = var_9e7e1 + 1;
    highp vec4 var_05977 = Data_PS[var_9e7e1];
    int var_447d9 = int(var_05977.y);
    int var_654e4 = int(var_05977.x);
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
    highp float var_a74d9;
    if ((var_447d9 & 256) != 0)
    {
        var_a74d9 = fract(var_ac5a3);
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
        var_a74d9 = var_669fd;
    }
    highp vec4 var_2e011;
    if ((var_447d9 & 16) != 0)
    {
        var_2e011 = mix(Data_PS[var_654e4], Data_PS[var_654e4 + 1], vec4(clamp(var_a74d9, 0.0, 1.0)));
    }
    else
    {
        highp vec4 var_3ed45;
        if ((var_447d9 & 32) != 0)
        {
            highp float var_6a899 = 2.0 * var_a74d9;
            highp float var_bee6c = 1.0 - var_6a899;
            var_3ed45 = ((Data_PS[var_654e4] * clamp(var_bee6c, 0.0, 1.0)) + (Data_PS[var_654e4 + 1] * (1.0 - min(abs(var_bee6c), 1.0)))) + (Data_PS[var_654e4 + 2] * clamp(var_6a899 - 1.0, 0.0, 1.0));
        }
        else
        {
            highp vec4 var_2e174;
            if ((var_447d9 & 64) != 0)
            {
                highp vec2 var_73333 = vec2(var_a74d9, Data_PS[var_654e4].x);
                highp float var_92159 = var_73333.x;
                highp float var_7e2a6 = var_73333.y;
                highp vec2 var_9296b = vec2(var_92159, 1.0 - var_7e2a6);
                var_73333 = var_9296b;
                var_2e174 = texture(s_txBuffer2, vec2(((var_9296b * UVTransform[2].zw) + UVTransform[2].xy).x, 1.0 - ((var_9296b * UVTransform[2].zw) + UVTransform[2].xy).y));
            }
            else
            {
                highp vec4 var_d8137;
                if ((var_447d9 & 1) != 0)
                {
                    highp vec2 var_75960 = vec2(var_c4329.x, 1.0 - var_c4329.y);
                    highp float var_1ce3f = var_75960.x;
                    highp float var_eb157 = var_75960.y;
                    highp vec2 var_b9345 = vec2(var_1ce3f, 1.0 - var_eb157);
                    var_75960 = var_b9345;
                    var_d8137 = texture(s_txBuffer, vec2(((var_b9345 * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_b9345 * UVTransform[0].zw) + UVTransform[0].xy).y));
                }
                else
                {
                    var_d8137 = vec4(0.0);
                }
                var_2e174 = var_d8137;
            }
            var_3ed45 = var_2e174;
        }
        var_2e011 = var_3ed45;
    }
    highp vec4 var_8048d;
    if ((var_447d9 & 128) != 0)
    {
        highp vec2 var_8d7d1 = (v_ScreenNormalPosition.xy * Data_PS[var_4251f].xy) + Data_PS[var_4251f].zw;
        highp float var_236dd = var_8d7d1.x;
        highp float var_44bd7 = var_8d7d1.y;
        highp vec2 var_76c64 = vec2(var_236dd, 1.0 - var_44bd7);
        var_8d7d1 = var_76c64;
        var_8048d = var_2e011 * texture(s_txBuffer1, vec2(((var_76c64 * UVTransform[1].zw) + UVTransform[1].xy).x, 1.0 - ((var_76c64 * UVTransform[1].zw) + UVTransform[1].xy).y)).w;
    }
    else
    {
        var_8048d = var_2e011;
    }
    bgfx_FragColor = (var_8048d * var_05977.w) * clamp(var_c4329.z, 0.0, 1.0);
}
