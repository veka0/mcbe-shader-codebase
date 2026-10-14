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
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    uvec4 var_45880 = floatBitsToUint(v_VaryingData);
    int var_9e7e1 = int((var_45880.z << 4u) | ((var_45880.y & 240u) >> 4u));
    int var_244eb = int(var_45880.w);
    int var_80d58 = var_9e7e1 + 1;
    highp vec4 var_5f983 = Data_PS[var_9e7e1];
    int var_07763 = int(var_5f983.x);
    highp vec4 var_2a631;
    if (14 == var_244eb)
    {
        highp vec2 var_663e5 = dFdx(v_ExtraParams.xy);
        highp vec2 var_292f4 = dFdy(v_ExtraParams.xy);
        highp float var_ca18b = ((2.0 * v_ExtraParams.x) * var_663e5.x) - var_663e5.y;
        highp float var_73461 = ((2.0 * v_ExtraParams.x) * var_292f4.x) - var_292f4.y;
        highp float var_1f860 = (v_ExtraParams.x * v_ExtraParams.x) - v_ExtraParams.y;
        var_2a631 = (Data_PS[var_80d58] * Data_PS[var_07763].x) * clamp(1.0 - sqrt((var_1f860 * var_1f860) / ((var_ca18b * var_ca18b) + (var_73461 * var_73461))), 0.0, 1.0);
    }
    else
    {
        highp vec4 var_9c590;
        if (11 == var_244eb)
        {
            var_9c590 = Data_PS[var_80d58] * min(1.0, (1.0 - abs((v_ExtraParams.y * Data_PS[var_07763].y) - Data_PS[var_07763].z)) * Data_PS[var_07763].x);
        }
        else
        {
            var_9c590 = Data_PS[var_80d58] * v_ExtraParams.y;
        }
        var_2a631 = var_9c590;
    }
    bgfx_FragData0 = var_2a631;
}
