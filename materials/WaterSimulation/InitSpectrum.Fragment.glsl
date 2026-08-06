#version 310 es

/*
* Available Macros:
*
* Passes:
* - HORIZONTAL_FFT_PASS (not used)
* - INIT_SPECTRUM_PASS (not used)
* - UPDATE_SPECTRUM_PASS (not used)
* - VERTICAL_FFT_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_SimTexture;
*
* Uniforms:
* - uniform vec4 G;
* - uniform vec4 StockhamFftSubTransformSize;
* - uniform vec4 WaterPatchSize;
* - uniform vec4 WaterResolution;
* - uniform vec4 WaterSimTime;
* - uniform vec4 WaterWaveDampening;
* - uniform vec4 WaterWindAlignment;
* - uniform vec4 WaterWindVelocity;
*/

precision mediump float;
precision highp int;
uniform highp vec4 G;
uniform highp vec4 WaterPatchSize;
uniform highp vec4 WaterResolution;
uniform highp vec4 WaterWaveDampening;
uniform highp vec4 WaterWindAlignment;
uniform highp vec4 WaterWindVelocity;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void func_2259f(inout highp vec2 arg_ebe33, inout highp float arg_47586) {
    highp float loc_24cb8 = length(arg_ebe33);
    if (loc_24cb8 == 0.0)
    {
        arg_47586 = 0.0;
        return;
    }
    highp float loc_69a17 = loc_24cb8 * loc_24cb8;
    highp float loc_018a0 = length(WaterWindVelocity.xy);
    if (loc_018a0 == 0.0)
    {
        arg_47586 = 0.0;
        return;
    }
    highp float loc_17a67 = (loc_018a0 * loc_018a0) / G.x;
    highp float loc_505cb = dot(WaterWindVelocity.xy / vec2(loc_018a0), arg_ebe33 / vec2(loc_24cb8));
    arg_47586 = ((((9.9999997473787516355514526367188e-06 * exp((-1.0) / (loc_69a17 * (loc_17a67 * loc_17a67)))) / (loc_69a17 * loc_69a17)) * (loc_505cb * loc_505cb)) * exp((-loc_69a17) * WaterWaveDampening.x)) * ((loc_505cb < 0.0) ? WaterWindAlignment.x : 1.0);
}
void main() {
    highp vec2 var_08a74 = (((v_texcoord0 - vec2(0.5)) * 6.283185482025146484375) * WaterResolution.x) / vec2(WaterPatchSize.x);
    highp float var_4b350;
    func_2259f(var_08a74, var_4b350);
    highp float var_f9476 = sqrt(var_4b350 * 0.5);
    highp vec2 var_4b41a = -var_08a74;
    highp float var_0ca02;
    func_2259f(var_4b41a, var_0ca02);
    highp float var_a51d7 = sqrt(var_0ca02 * 0.5);
    bgfx_FragData0 = vec4(var_f9476, var_f9476, var_a51d7, -var_a51d7);
}
