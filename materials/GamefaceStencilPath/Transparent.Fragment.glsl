#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* Available Resources:
*
* Uniforms:
* - uniform vec4 Data_PS[128];
* - uniform vec4 Data_VS[128];
*/

precision mediump float;
precision highp int;
in highp vec4 v_ExtraParams;
flat in highp vec4 v_VaryingData;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_55ddb = v_ExtraParams;
    uvec4 var_41943 = uvec4(v_VaryingData);
    int var_19c0d = int(var_41943.w);
    if (var_19c0d == 15)
    {
        highp vec2 var_58e40 = abs(v_ExtraParams.xy);
        highp vec2 var_ae38f = var_58e40;
        highp vec2 var_6402f = dFdx(var_58e40);
        highp vec2 var_dec69 = dFdy(var_58e40);
        highp float var_62be2 = ((2.0 * var_ae38f.x) * var_6402f.x) - var_6402f.y;
        highp float var_184a0 = ((2.0 * var_ae38f.x) * var_dec69.x) - var_dec69.y;
        if (clamp(-(((var_ae38f.x * var_ae38f.x) - var_ae38f.y) / sqrt((var_62be2 * var_62be2) + (var_184a0 * var_184a0))), 0.0, 1.0) < 0.00390625)
        {
            discard;
        }
    }
    else
    {
        if (var_19c0d == 16)
        {
        }
        else
        {
            if (var_55ddb.y < 0.00390625)
            {
                discard;
            }
        }
    }
    bgfx_FragColor = vec4(0.0);
}
