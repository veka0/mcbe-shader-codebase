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
* - uniform lowp sampler2D s_Texture0;
* - uniform lowp sampler2D s_Texture1;
* - uniform lowp sampler2D s_Texture2;
*
* Uniforms:
* - uniform mat4 CoordTransformVS;
* - uniform vec4 GradientEndColor;
* - uniform vec4 GradientMidColor;
* - uniform vec4 GradientStartColor;
* - uniform vec4 GradientYCoord;
* - uniform vec4 MaskScaleAndOffset;
* - uniform vec4 ShaderType;
* - uniform mat4 Transform;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_Texture0;
uniform highp sampler2D s_Texture1;
uniform highp sampler2D s_Texture2;
uniform highp vec4 GradientEndColor;
uniform highp vec4 GradientMidColor;
uniform highp vec4 GradientStartColor;
uniform highp vec4 GradientYCoord;
uniform highp vec4 ShaderType;
in highp vec4 v_additional;
in highp vec4 v_varyingParam0;
in highp vec4 v_varyingParam1;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_f5f14 = v_additional;
    highp vec4 var_52da2 = v_varyingParam0;
    highp float var_ac5a3;
    if (int(mod(float(int(ShaderType.x)), 4.0)) >= 2)
    {
        var_ac5a3 = var_52da2.x;
    }
    else
    {
        highp float var_385d0;
        if (int(mod(float(int(ShaderType.x)), 8.0)) >= 4)
        {
            var_385d0 = length(v_varyingParam0.xy);
        }
        else
        {
            highp float var_b832c;
            if (int(mod(float(int(ShaderType.x)), 16.0)) >= 8)
            {
                var_b832c = (3.1400001049041748046875 + atan(var_52da2.y, var_52da2.x)) * 0.159235656261444091796875;
            }
            else
            {
                var_b832c = 0.0;
            }
            var_385d0 = var_b832c;
        }
        var_ac5a3 = var_385d0;
    }
    highp float var_90552;
    if (int(mod(float(int(ShaderType.x)), 512.0)) >= 256)
    {
        var_90552 = fract(var_ac5a3);
    }
    else
    {
        highp float var_669fd;
        if (int(mod(float(int(ShaderType.x)), 1024.0)) >= 512)
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
        var_90552 = var_669fd;
    }
    highp vec4 var_01d41;
    if (int(mod(float(int(ShaderType.x)), 32.0)) >= 16)
    {
        var_01d41 = mix(GradientStartColor, GradientEndColor, vec4(clamp(var_90552, 0.0, 1.0)));
    }
    else
    {
        highp vec4 var_c56fa;
        if (int(mod(float(int(ShaderType.x)), 64.0)) >= 32)
        {
            highp float var_15763 = 2.0 * var_90552;
            highp float var_367df = 1.0 - var_15763;
            var_c56fa = ((GradientStartColor * clamp(var_367df, 0.0, 1.0)) + (GradientMidColor * (1.0 - min(abs(var_367df), 1.0)))) + (GradientEndColor * clamp(var_15763 - 1.0, 0.0, 1.0));
        }
        else
        {
            highp vec4 var_e510f;
            if (int(mod(float(int(ShaderType.x)), 128.0)) >= 64)
            {
                var_e510f = texture(s_Texture2, vec2(var_90552, GradientYCoord.x));
            }
            else
            {
                highp vec4 var_dd35c;
                if (int(mod(float(int(ShaderType.x)), 2.0)) >= 1)
                {
                    var_dd35c = texture(s_Texture0, vec2(v_additional.x, 1.0 - v_additional.y));
                }
                else
                {
                    var_dd35c = vec4(0.0);
                }
                var_e510f = var_dd35c;
            }
            var_c56fa = var_e510f;
        }
        var_01d41 = var_c56fa;
    }
    highp vec4 var_f6024;
    if (int(mod(float(int(ShaderType.x)), 256.0)) >= 128)
    {
        var_f6024 = var_01d41 * texture(s_Texture1, v_varyingParam1.xy).w;
    }
    else
    {
        var_f6024 = var_01d41;
    }
    bgfx_FragColor = var_f6024 * clamp(var_f5f14.z, 0.0, 1.0);
}
