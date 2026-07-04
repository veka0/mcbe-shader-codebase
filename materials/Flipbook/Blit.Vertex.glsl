#version 310 es

/*
* Available Macros:
*
* Passes:
* - BLIT_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BlitTexture;
*
* Uniforms:
* - uniform vec4 VBlendControl;
*/

uniform mat4 u_modelViewProj;
uniform vec4 VBlendControl;
in vec3 a_position;
in vec2 a_texcoord0;
out vec2 v_texcoord0;
out vec2 v_texcoord1;
void main() {
    vec2 var_9aab4 = a_texcoord0;
    var_9aab4.y += VBlendControl.x;
    vec2 var_64f25 = a_texcoord0;
    var_64f25.y += VBlendControl.y;
    v_texcoord0 = var_9aab4;
    v_texcoord1 = var_64f25;
    gl_Position = u_modelViewProj * vec4(a_position, 1.0);
}
