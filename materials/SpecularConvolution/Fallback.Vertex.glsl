#version 310 es

/*
* Available Macros:
*
* Passes:
* - CONVOLVE_PASS (not used)
* - FALLBACK_PASS (not used)
* - GENERATE_BRDF_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp samplerCube s_CubeMap;
*
* Uniforms:
* - uniform vec4 ConvolutionParameters;
* - uniform vec4 ConvolutionType;
* - uniform vec4 CurrentFace;
*/

void main() {
    gl_Position = vec4(0.0);
}
