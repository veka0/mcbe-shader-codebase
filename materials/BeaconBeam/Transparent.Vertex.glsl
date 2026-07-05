#version 310 es

/*
* Available Macros:
*
* Passes:
* - OPAQUE_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Fancy:
* - FANCY__OFF (not used)
* - FANCY__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_BeaconTexture;
*
* Uniforms:
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 OverlayColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 TileLightColor;
* - uniform vec4 UVAnimation;
*/

uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 SubPixelOffset;
in vec4 a_color0;
in vec3 a_position;
in vec2 a_texcoord0;
out vec4 v_color;
out vec4 v_fog;
out vec4 v_light;
out vec2 v_texCoords;
void main() {
    mat4 var_83c3f = u_proj;
    vec4 var_67767 = var_83c3f[2];
    var_67767.x += SubPixelOffset.x;
    var_67767.y -= SubPixelOffset.y;
    mat4 var_7913a = u_proj;
    var_7913a[2] = var_67767;
    v_color = a_color0;
    v_fog = vec4(0.0);
    v_light = vec4(0.0);
    v_texCoords = a_texcoord0;
    gl_Position = var_7913a * (u_view * vec4(a_position, 1.0));
}
