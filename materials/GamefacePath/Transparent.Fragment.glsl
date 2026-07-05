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
* - uniform vec4 UVTransform[5];
*/

precision mediump float;
precision highp int;
uniform highp vec4 Data_PS[128];
in highp vec4 v_ExtraParams;
flat in highp vec4 v_VaryingData;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_4debe = v_ExtraParams;
    uvec4 var_45880 = floatBitsToUint(v_VaryingData);
    int var_9e7e1 = int((var_45880.z << 4u) | ((var_45880.y & 240u) >> 4u));
    int var_244eb = int(var_45880.w);
    int var_c4c19 = var_9e7e1 + 1;
    highp vec4 var_5f983 = Data_PS[var_9e7e1];
    int var_8fc81 = int(var_5f983.x);
    highp vec4 var_bc541;
    if (14 == var_244eb)
    {
        highp vec2 var_b71ef = dFdx(v_ExtraParams.xy);
        highp vec2 var_45c5c = dFdy(v_ExtraParams.xy);
        highp float var_7084f = ((2.0 * var_4debe.x) * var_b71ef.x) - var_b71ef.y;
        highp float var_f5098 = ((2.0 * var_4debe.x) * var_45c5c.x) - var_45c5c.y;
        highp float var_a056d = (var_4debe.x * var_4debe.x) - var_4debe.y;
        var_bc541 = (Data_PS[var_c4c19] * Data_PS[var_8fc81].x) * clamp(1.0 - sqrt((var_a056d * var_a056d) / ((var_7084f * var_7084f) + (var_f5098 * var_f5098))), 0.0, 1.0);
    }
    else
    {
        highp vec4 var_ff285;
        if (11 == var_244eb)
        {
            var_ff285 = Data_PS[var_c4c19] * min(1.0, (1.0 - abs((var_4debe.y * Data_PS[var_8fc81].y) - Data_PS[var_8fc81].z)) * Data_PS[var_8fc81].x);
        }
        else
        {
            var_ff285 = Data_PS[var_c4c19] * var_4debe.y;
        }
        var_bc541 = var_ff285;
    }
    bgfx_FragColor = var_bc541;
}
