#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_OPAQUE_PASS (not used)
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
* - uniform vec4 ColorGrading_OptimizeGammaCorrection;
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
#ifdef INSTANCING__OFF
    vec4 var_dc0f7 = u_model[0] * vec4(a_position, 1.0);
#endif
#ifdef INSTANCING__ON
    mat4 var_53a7d;
    var_53a7d[0] = vec4(i_data1.x, i_data2.x, i_data3.x, 0.0);
    var_53a7d[1] = vec4(i_data1.y, i_data2.y, i_data3.y, 0.0);
    var_53a7d[2] = vec4(i_data1.z, i_data2.z, i_data3.z, 0.0);
    var_53a7d[3] = vec4(i_data1.w, i_data2.w, i_data3.w, 1.0);
    vec4 var_dc0f7 = var_53a7d * vec4(a_position, 1.0);
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
    v_encodedPlane = a_color0.w;
    v_fog = vec4(FogColor.xyz, clamp(((length(var_888aa) / FogAndDistanceControl.z) - FogAndDistanceControl.x) / (FogAndDistanceControl.y - FogAndDistanceControl.x), 0.0, 1.0));
    v_parallaxUV = var_32549;
    gl_Position = u_viewProj * vec4(var_dc0f7.xyz, 1.0);
}
