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
uniform highp vec4 Data_PS[128];
in highp vec4 v_ExtraParams;
flat in highp vec4 v_VaryingData;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_4debe = v_ExtraParams;
    uvec4 var_2f9cf = floatBitsToUint(v_VaryingData);
    int var_9c430 = int((var_2f9cf.z << uint(4)) | ((var_2f9cf.y & 240u) >> uint(4)));
    int var_bf50c = int(var_2f9cf.w);
    highp vec4 var_0962a = Data_PS[var_9c430 + 1];
    int var_a9c74 = int(var_0962a.w);
    highp vec4 var_bc541;
    if (14.0 == float(var_bf50c))
    {
        highp vec2 var_b71ef = dFdx(v_ExtraParams.xy);
        highp vec2 var_45c5c = dFdy(v_ExtraParams.xy);
        highp float var_7084f = ((2.0 * var_4debe.x) * var_b71ef.x) - var_b71ef.y;
        highp float var_f5098 = ((2.0 * var_4debe.x) * var_45c5c.x) - var_45c5c.y;
        highp float var_a056d = (var_4debe.x * var_4debe.x) - var_4debe.y;
        var_bc541 = (Data_PS[var_9c430] * Data_PS[var_a9c74].x) * clamp(1.0 - sqrt((var_a056d * var_a056d) / ((var_7084f * var_7084f) + (var_f5098 * var_f5098))), 0.0, 1.0);
    }
    else
    {
        highp vec4 var_ff285;
        if (11.0 == float(var_bf50c))
        {
            var_ff285 = Data_PS[var_9c430] * min(1.0, (1.0 - abs((var_4debe.y * Data_PS[var_a9c74].y) - Data_PS[var_a9c74].z)) * Data_PS[var_a9c74].x);
        }
        else
        {
            var_ff285 = Data_PS[var_9c430] * var_4debe.y;
        }
        var_bc541 = var_ff285;
    }
    bgfx_FragColor = var_bc541;
}
