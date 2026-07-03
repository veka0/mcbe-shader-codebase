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

in vec4 a_position;
in vec2 a_texcoord0;
out vec2 v_texCoord;
void main() {
    vec2 var_4f57f = a_texcoord0;
    var_4f57f.x = 1.0 - var_4f57f.x;
    v_texCoord = var_4f57f;
    gl_Position = vec4((a_position.xy * 2.0) - vec2(1.0), 0.0, 1.0);
}
