#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* AlphaTest:
* - ALPHA_TEST__OFF (not used)
* - ALPHA_TEST__ON_DISCARD_VALUE_BASED (not used)
*
* Lit:
* - LIT__OFF
* - LIT__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 DiscardValue;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 HudOpacity;
* - uniform vec4 OverlayColor;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 TileLightColor;
*/

uniform mat4 u_model[4];
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 FogColor;
uniform vec4 FogControl;
#ifdef LIT__ON
uniform vec4 OverlayColor;
#endif
uniform vec4 SubPixelOffset;
#ifdef LIT__ON
uniform vec4 TileLightColor;
#endif
in vec4 a_color0;
#ifdef LIT__ON
in vec4 a_normal;
#endif
in vec3 a_position;
in vec2 a_texcoord0;
out vec4 v_color;
out vec4 v_fog;
out vec4 v_light;
centroid out vec2 v_texCoords;
void main() {
    mat4 var_83c3f = u_proj;
    vec4 var_67767 = var_83c3f[2];
    var_67767.x += SubPixelOffset.x;
    var_67767.y -= SubPixelOffset.y;
    mat4 var_4d7fb = u_proj;
    var_4d7fb[2] = var_67767;
    vec4 var_a3f6c = var_4d7fb * (u_view * vec4((u_model[0] * vec4(a_position, 1.0)).xyz, 1.0));
    vec4 var_27f6b = var_a3f6c;
#ifdef LIT__ON
    vec3 var_54aa7 = normalize((u_model[0] * a_normal).xyz);
    var_54aa7.y *= TileLightColor.w;
#endif
    v_color = a_color0;
    v_fog = vec4(FogColor.xyz, clamp(((var_27f6b.z / FogControl.z) - FogControl.x) / (FogControl.y - FogControl.x), 0.0, 1.0));
#ifdef LIT__OFF
    v_light = vec4(0.0);
#endif
#ifdef LIT__ON
    v_light = vec4(vec3(((((1.0 + var_54aa7.y) * 0.2750000059604644775390625) + ((var_54aa7.x * var_54aa7.x) * (-0.100000001490116119384765625))) + ((var_54aa7.z * var_54aa7.z) * 0.100000001490116119384765625)) + 0.449999988079071044921875) * TileLightColor.xyz, 1.0) + vec4(OverlayColor.w * 0.3499999940395355224609375);
#endif
    v_texCoords = a_texcoord0;
    gl_Position = var_a3f6c;
}
