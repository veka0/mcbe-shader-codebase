#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* Available Resources:
*
* Uniforms:
* - uniform vec4 PrimProps0;
* - uniform vec4 PrimProps1;
* - uniform vec4 ShaderType;
* - uniform mat4 Transform;
*/

uniform mat4 Transform;
in vec4 a_position;
out vec2 v_extraParams;
void main() {
    vec4 var_41dac = vec4(a_position.xy, 0.0, 1.0) * Transform;
    float var_70560 = var_41dac.w;
    var_41dac.x = (var_41dac.x * 2.0) - var_70560;
    var_41dac.y = ((var_70560 - var_41dac.y) * 2.0) - var_70560;
    v_extraParams = a_position.zw;
    gl_Position = var_41dac;
}
