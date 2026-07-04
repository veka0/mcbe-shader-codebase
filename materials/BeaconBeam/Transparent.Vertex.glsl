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
    mat4 var_69af0 = u_proj;
    var_69af0[2].x += SubPixelOffset.x;
    var_69af0[2].y -= SubPixelOffset.y;
    v_color = a_color0;
    v_fog = vec4(0.0);
    v_light = vec4(0.0);
    v_texCoords = a_texcoord0;
    gl_Position = var_69af0 * (u_view * vec4(a_position, 1.0));
}
