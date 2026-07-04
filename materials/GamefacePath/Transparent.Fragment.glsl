#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* Available Resources:
*
* Uniforms:
* - uniform vec4 PrimProps0;
* - uniform vec4 PrimProps1;
* - uniform vec4 ShaderType;
* - uniform mat4 Transform;
*/

precision mediump float;
precision highp int;
uniform highp vec4 PrimProps0;
uniform highp vec4 PrimProps1;
uniform highp vec4 ShaderType;
in highp vec2 v_extraParams;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec2 var_b50ee = v_extraParams;
    highp vec4 var_4fed6;
    if (int(ShaderType.x) == 14)
    {
        highp vec2 var_d2dc6 = dFdx(v_extraParams);
        highp vec2 var_88eb9 = dFdy(v_extraParams);
        highp float var_ad6bf = ((2.0 * var_b50ee.x) * var_d2dc6.x) - var_d2dc6.y;
        highp float var_38532 = ((2.0 * var_b50ee.x) * var_88eb9.x) - var_88eb9.y;
        highp float var_fb7d1 = (var_b50ee.x * var_b50ee.x) - var_b50ee.y;
        var_4fed6 = (PrimProps0 * PrimProps1.x) * (1.0 - sqrt((var_fb7d1 * var_fb7d1) / ((var_ad6bf * var_ad6bf) + (var_38532 * var_38532))));
    }
    else
    {
        highp vec4 var_3556e;
        if (int(ShaderType.x) == 11)
        {
            var_3556e = PrimProps0 * min(1.0, (1.0 - abs((var_b50ee.y * PrimProps1.y) - PrimProps1.z)) * PrimProps1.x);
        }
        else
        {
            var_3556e = PrimProps0 * var_b50ee.y;
        }
        var_4fed6 = var_3556e;
    }
    bgfx_FragColor = var_4fed6;
}
