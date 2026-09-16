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

in vec3 a_position;
in vec2 a_texcoord0;
out vec2 v_texcoord0;
void main() {
    vec4 var_ef43d = vec4(a_position, 1.0);
    vec2 var_ef197 = vec2(((var_ef43d.xy * 2.0) - vec2(1.0)).x, 1.0 - ((var_ef43d.xy * 2.0) - vec2(1.0)).y);
    v_texcoord0 = a_texcoord0;
    gl_Position = vec4(var_ef197.x, var_ef197.y, var_ef43d.z, var_ef43d.w);
}
