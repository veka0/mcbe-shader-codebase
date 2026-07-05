#version 310 es

/*
* Available Macros:
*
* Passes:
* - FORCE_FORWARD_PBR_OPAQUE_PASS (not used)
* - OPAQUE_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp samplerCube s_MatTexture;
* - uniform lowp sampler2D s_PreviousFrameAverageLuminance;
*
* Uniforms:
* - uniform vec4 ColorGrading_OptimizeGammaCorrection;
* - uniform mat4 CubemapRotation;
* - uniform vec4 PreExposureEnabled;
* - uniform vec4 SubPixelOffset;
*/

uniform mat4 CubemapRotation;
uniform mat4 u_model[4];
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 SubPixelOffset;
in vec3 a_position;
out vec3 v_texcoord0;
void main() {
    vec4 var_1572a = u_model[0] * vec4(a_position, 1.0);
    mat4 var_83c3f = u_proj;
    vec4 var_67767 = var_83c3f[2];
    var_67767.x += SubPixelOffset.x;
    var_67767.y -= SubPixelOffset.y;
    mat4 var_8e1af = u_proj;
    var_8e1af[2] = var_67767;
    v_texcoord0 = (CubemapRotation * vec4(var_1572a.xyz, 0.0)).xyz;
    gl_Position = var_8e1af * (u_view * vec4(var_1572a.xyz, 1.0));
}
