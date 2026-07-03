#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_PASS (not used)
* - DEPTH_ONLY_OPAQUE_PASS (not used)
* - OPAQUE_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* Change_Color:
* - CHANGE_COLOR__MULTI (not used)
* - CHANGE_COLOR__OFF (not used)
*
* Emissive:
* - EMISSIVE__OFF (not used)
*
* Fancy:
* - FANCY__OFF
* - FANCY__ON
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*
* MaskedMultitexture:
* - MASKED_MULTITEXTURE__OFF (not used)
* - MASKED_MULTITEXTURE__ON (not used)
*
* Tinting:
* - TINTING__DISABLED (not used)
* - TINTING__ENABLED (not used)
*
* UIEntity:
* - UI_ENTITY__DISABLED (not used)
* - UI_ENTITY__ENABLED (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
* - uniform lowp sampler2D s_MatTexture1;
* - uniform lowp sampler2D s_MatTexture2;
*
* Uniforms:
* - uniform vec4 ActorFPEpsilon;
* - uniform mat4 Bones[8];
* - uniform vec4 ChangeColor;
* - uniform vec4 ColorBased;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 HudOpacity;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MatColor;
* - uniform vec4 MaterialID;
* - uniform vec4 MultiplicativeTintColor;
* - uniform vec4 OverlayColor;
* - uniform vec4 PatternColors[7];
* - uniform vec4 PatternCount;
* - uniform vec4 PatternUVOffsetsAndScales[7];
* - uniform vec4 SubPixelOffset;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 TintedAlphaTestEnabled;
* - uniform vec4 UVAnimation;
* - uniform vec4 UseAlphaRewrite;
*/

#if defined(FANCY__ON) || defined(INSTANCING__OFF)
uniform mat4 Bones[8];
uniform mat4 u_model[4];
#endif
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 FogColor;
uniform vec4 FogControl;
uniform vec4 OverlayColor;
uniform vec4 SubPixelOffset;
uniform vec4 TileLightColor;
#if defined(FANCY__ON) || defined(INSTANCING__OFF)
in float a_indices;
#endif
#ifdef FANCY__ON
in vec4 a_normal;
#endif
in vec3 a_position;
#ifdef INSTANCING__ON
in vec4 i_data1;
in vec4 i_data2;
in vec4 i_data3;
#endif
out vec4 v_color0;
out vec4 v_fog;
out vec4 v_light;
centroid out vec2 v_texcoord0;
centroid out vec4 v_texcoords;
out vec3 v_worldPos;
void main() {
#if defined(FANCY__OFF) && defined(INSTANCING__OFF)
    vec4 var_04231 = (u_model[0] * Bones[int(a_indices)]) * vec4(a_position, 1.0);
#endif
#if defined(FANCY__ON) && defined(INSTANCING__ON)
    vec3 var_dc61b = normalize((u_model[0] * Bones[int(a_indices)]) * vec4(a_normal.xyz, 0.0)).xyz;
    var_dc61b.y *= TileLightColor.w;
#endif
#ifdef INSTANCING__ON
    vec4 var_78b44 = i_data1;
    vec4 var_e67a8 = i_data2;
    vec4 var_1b7f0 = i_data3;
    mat4 var_89150;
    var_89150[0] = vec4(var_78b44.x, var_e67a8.x, var_1b7f0.x, 0.0);
    var_89150[1] = vec4(var_78b44.y, var_e67a8.y, var_1b7f0.y, 0.0);
    var_89150[2] = vec4(var_78b44.z, var_e67a8.z, var_1b7f0.z, 0.0);
    var_89150[3] = vec4(var_78b44.w, var_e67a8.w, var_1b7f0.w, 1.0);
#endif
#if defined(FANCY__ON) && defined(INSTANCING__OFF)
    mat4 var_89150 = u_model[0] * Bones[int(a_indices)];
    vec3 var_dc61b = normalize(var_89150 * vec4(a_normal.xyz, 0.0)).xyz;
    var_dc61b.y *= TileLightColor.w;
#endif
#if defined(FANCY__ON) || defined(INSTANCING__ON)
    vec4 var_04231 = var_89150 * vec4(a_position, 1.0);
#endif
    mat4 var_bab0b = u_proj;
    var_bab0b[2].x += SubPixelOffset.x;
    var_bab0b[2].y -= SubPixelOffset.y;
    vec4 var_cd7d8 = var_bab0b * (u_view * vec4(var_04231.xyz, 1.0));
    vec4 var_27f6b = var_cd7d8;
    v_color0 = vec4(0.0);
    v_fog = vec4(FogColor.xyz, clamp(((var_27f6b.z / FogControl.z) - FogControl.x) / (FogControl.y - FogControl.x), 0.0, 1.0));
#ifdef FANCY__OFF
    v_light = vec4(TileLightColor.xyz * (1.0 + (OverlayColor.w * 0.3499999940395355224609375)), 1.0);
#endif
#ifdef FANCY__ON
    v_light = vec4(TileLightColor.xyz * ((((((1.0 + var_dc61b.y) * 0.2750000059604644775390625) + ((var_dc61b.x * var_dc61b.x) * (-0.100000001490116119384765625))) + ((var_dc61b.z * var_dc61b.z) * 0.100000001490116119384765625)) + 0.449999988079071044921875) + (OverlayColor.w * 0.3499999940395355224609375)), 1.0);
#endif
    v_texcoord0 = vec2(0.0);
    v_texcoords = vec4(0.0);
    v_worldPos = var_04231.xyz;
    gl_Position = var_cd7d8;
}
