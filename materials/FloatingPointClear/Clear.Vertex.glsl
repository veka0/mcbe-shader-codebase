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
    vec4 var_ef43d = vec4(a_position, 1.0);
    vec2 var_ef197 = vec2(((var_ef43d.xy * 2.0) - vec2(1.0)).x, 1.0 - ((var_ef43d.xy * 2.0) - vec2(1.0)).y);
    gl_Position = vec4(var_ef197.x, var_ef197.y, var_ef43d.z, var_ef43d.w);
}
