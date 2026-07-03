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
uniform highp vec4 ShaderType;
in highp vec2 v_extraParams;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec2 var_6ab19 = v_extraParams;
    if (int(ShaderType.x) == 15)
    {
        highp vec2 var_af5a7 = abs(v_extraParams);
        highp vec2 var_8f934 = var_af5a7;
        highp vec2 var_6402f = dFdx(var_af5a7);
        highp vec2 var_dec69 = dFdy(var_af5a7);
        highp float var_d13de = ((2.0 * var_8f934.x) * var_6402f.x) - var_6402f.y;
        highp float var_6c847 = ((2.0 * var_8f934.x) * var_dec69.x) - var_dec69.y;
        highp float var_30810 = (var_8f934.x * var_8f934.x) - var_8f934.y;
        if (clamp(-sqrt((var_30810 * var_30810) / ((var_d13de * var_d13de) + (var_6c847 * var_6c847))), 0.0, 1.0) < 0.00390625)
        {
            discard;
        }
    }
    else
    {
        if (int(ShaderType.x) == 16)
        {
        }
        else
        {
            if (var_6ab19.y < 0.00390625)
            {
                discard;
            }
        }
    }
    bgfx_FragColor = vec4(1.0);
}
