#version 310 es

/*
* Available Macros:
*
* Passes:
* - CLEAR_PASS (not used)
*
* Available Resources:
*
* Uniforms:
* - uniform vec4 ClearColor;
*/

in vec3 a_position;
void main() {
    vec4 var_567ef = vec4(a_position, 1.0);
    vec4 var_e1bc6 = var_567ef;
    var_e1bc6.x = ((var_567ef.xy * 2.0) - vec2(1.0)).x;
    var_e1bc6.y = 1.0 - ((var_567ef.xy * 2.0) - vec2(1.0)).y;
    gl_Position = var_e1bc6;
}
