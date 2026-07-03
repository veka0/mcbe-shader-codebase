#version 310 es

/*
* Available Macros:
*
* Passes:
* - OPAQUE_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Fancy:
* - FANCY__OFF
* - FANCY__ON
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

#ifdef FANCY__ON
uniform mat4 u_model[4];
#endif
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 FogAndDistanceControl;
uniform vec4 FogColor;
uniform vec4 OverlayColor;
uniform vec4 SubPixelOffset;
uniform vec4 TileLightColor;
uniform vec4 UVAnimation;
in vec4 a_color0;
#ifdef FANCY__ON
in vec4 a_normal;
#endif
in vec3 a_position;
in vec2 a_texcoord0;
out vec4 v_color;
out vec4 v_fog;
out vec4 v_light;
out vec2 v_texCoords;
void main() {
    mat4 var_96cfc = u_proj;
    var_96cfc[2].x += SubPixelOffset.x;
    var_96cfc[2].y -= SubPixelOffset.y;
    vec4 var_bc91e = var_96cfc * (u_view * vec4(a_position, 1.0));
    vec4 var_b4024 = var_bc91e;
#ifdef FANCY__ON
    vec3 var_f099e = normalize(u_model[0] * vec4(a_normal.xyz, 0.0)).xyz;
    var_f099e.y *= TileLightColor.w;
#endif
    v_color = a_color0;
    v_fog = vec4(FogColor.xyz, clamp(((var_b4024.z / FogAndDistanceControl.z) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0));
#ifdef FANCY__OFF
    v_light = vec4(TileLightColor.xyz * (1.0 + (OverlayColor.w * 0.3499999940395355224609375)), 1.0);
#endif
#ifdef FANCY__ON
    v_light = vec4(TileLightColor.xyz * ((((((1.0 + var_f099e.y) * 0.2750000059604644775390625) + ((var_f099e.x * var_f099e.x) * (-0.100000001490116119384765625))) + ((var_f099e.z * var_f099e.z) * 0.100000001490116119384765625)) + 0.449999988079071044921875) + (OverlayColor.w * 0.3499999940395355224609375)), 1.0);
#endif
    v_texCoords = UVAnimation.xy + (a_texcoord0 * UVAnimation.zw);
    gl_Position = var_bc91e;
}
