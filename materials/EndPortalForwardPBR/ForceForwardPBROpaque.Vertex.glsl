#version 310 es

/*
* Available Macros:
*
* Passes:
* - FORCE_FORWARD_PBR_OPAQUE_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF
* - INSTANCING__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_ColorTexture;
* - uniform lowp sampler2D s_ParallaxTexture;
*
* Uniforms:
* - uniform vec4 EndPortalEmissiveMultiplierAndDesaturation;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 ViewPositionAndTime;
*/

#ifdef INSTANCING__OFF
uniform mat4 u_model[4];
#endif
uniform mat4 u_viewProj;
uniform vec4 FogAndDistanceControl;
uniform vec4 FogColor;
uniform vec4 ViewPositionAndTime;
in vec4 a_color0;
in vec3 a_position;
in vec2 a_texcoord0;
#ifdef INSTANCING__ON
in vec4 i_data1;
in vec4 i_data2;
in vec4 i_data3;
#endif
centroid out vec2 v_colorUV;
out float v_encodedPlane;
out vec4 v_fog;
centroid out vec2 v_parallaxUV;
void main() {
    vec4 var_716e5 = a_color0;
#ifdef INSTANCING__OFF
    vec4 var_dc0f7 = u_model[0] * vec4(a_position, 1.0);
#endif
#ifdef INSTANCING__ON
    vec4 var_78b44 = i_data1;
    vec4 var_e67a8 = i_data2;
    vec4 var_1b7f0 = i_data3;
    mat4 var_e43a8;
    var_e43a8[0] = vec4(var_78b44.x, var_e67a8.x, var_1b7f0.x, 0.0);
    var_e43a8[1] = vec4(var_78b44.y, var_e67a8.y, var_1b7f0.y, 0.0);
    var_e43a8[2] = vec4(var_78b44.z, var_e67a8.z, var_1b7f0.z, 0.0);
    var_e43a8[3] = vec4(var_78b44.w, var_e67a8.w, var_1b7f0.w, 1.0);
    vec4 var_dc0f7 = var_e43a8 * vec4(a_position, 1.0);
#endif
    vec3 var_888aa = var_dc0f7.xyz;
    vec4 var_12271 = (a_color0 - vec4(0.5, 0.5, 0.5, 0.0)) * vec4(2.0, 2.0, 2.0, 32.0);
    vec4 var_5d371 = var_12271;
    vec3 var_0e707 = var_12271.xyz;
    vec3 var_331fa = (var_888aa * (dot(var_888aa - (var_0e707 * var_5d371.w), var_0e707) / dot(var_888aa, var_0e707))) + ViewPositionAndTime.xyz;
    vec3 var_1606b = abs(var_0e707);
    float var_4cd05 = sin(var_5d371.w * 2.24399471282958984375);
    float var_8749b = cos(var_5d371.w * 2.24399471282958984375);
    vec2 var_9b4db = (mat2(vec2(var_8749b, var_4cd05), vec2(-var_4cd05, var_8749b)) * ((((var_331fa.yz * var_1606b.x) + (var_331fa.xz * var_1606b.y)) + (var_331fa.xy * var_1606b.z)) * vec2(0.0625))) + (vec2(var_8749b, var_4cd05) * var_5d371.w);
    var_9b4db.y += (ViewPositionAndTime.w * 0.00390625);
    vec2 var_4d0bf = var_9b4db;
    vec2 var_c711b = vec2(64.0);
    vec2 var_32549 = vec2(var_4d0bf.x - (var_c711b.x * trunc(var_4d0bf.x / var_c711b.x)), var_4d0bf.y - (var_c711b.y * trunc(var_4d0bf.y / var_c711b.y)));
    var_9b4db = var_32549;
    v_colorUV = a_texcoord0;
    v_encodedPlane = var_716e5.w;
    v_fog = vec4(FogColor.xyz, clamp(((length(var_888aa) / FogAndDistanceControl.z) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0));
    v_parallaxUV = var_32549;
    gl_Position = u_viewProj * vec4(var_dc0f7.xyz, 1.0);
}
