#version 310 es

/*
* Available Macros:
*
* Passes:
* - FSR1_COMPUTE_PASS (not used)
* - FSR1_FRAG_PASS (not used)
* - FALLBACK_PASS (not used)
*
* FFXPrecision:
* - FFX_PRECISION__FULL (not used)
* - FFX_PRECISION__HALF (not used)
*
* FSRFilterMode:
* - FSR_FILTER_MODE__BILINEAR (not used)
* - FSR_FILTER_MODE__EASU (not used)
* - FSR_FILTER_MODE__RCAS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_InputTex;
* - uniform lowp sampler2D s_OutputTex;
*
* Uniforms:
* - uniform vec4 FSRConst0;
* - uniform vec4 FSRConst1;
* - uniform vec4 FSRConst2;
* - uniform vec4 FSRConst3;
* - uniform vec4 InputAndOutputResolution;
*/

in vec4 a_position;
in vec2 a_texcoord0;
out vec2 v_texcoord0;
void main() {
    vec2 var_8e808 = a_texcoord0;
    v_texcoord0 = vec2(var_8e808.x, var_8e808.y);
    gl_Position = vec4((a_position.xy * 2.0) - vec2(1.0), 0.0, 1.0);
}
