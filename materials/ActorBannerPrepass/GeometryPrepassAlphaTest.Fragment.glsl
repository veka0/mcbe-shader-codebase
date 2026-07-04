#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_PASS (not used)
* - DEPTH_ONLY_OPAQUE_PASS (not used)
* - GEOMETRY_PREPASS_PASS (not used)
* - GEOMETRY_PREPASS_ALPHA_TEST_PASS (not used)
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
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* MaskedMultitexture:
* - MASKED_MULTITEXTURE__OFF (not used)
* - MASKED_MULTITEXTURE__ON (not used)
*
* Tinting:
* - TINTING__DISABLED
* - TINTING__ENABLED
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MERSTexture;
* - uniform lowp sampler2D s_MatTexture;
* - uniform lowp sampler2D s_MatTexture1;
* - uniform lowp sampler2D s_NormalTexture;
*
* Uniforms:
* - uniform vec4 ActorFPEpsilon;
* - uniform vec4 BannerBasePBRTextureData[4];
* - uniform vec4 BannerColors[7];
* - uniform vec4 BannerUVOffsetsAndScales[7];
* - uniform mat4 Bones[8];
* - uniform vec4 ChangeColor;
* - uniform vec4 ColorBased;
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
* - uniform vec4 DitheringEnabledToggle;
* - uniform vec4 EmissiveUniform;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 HudOpacity;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MatColor;
* - uniform vec4 MaterialID;
* - uniform vec4 MetalnessUniform;
* - uniform vec4 MultiplicativeTintColor;
* - uniform vec4 OverlayColor;
* - uniform vec4 PBRTextureFlags;
* - uniform mat4 PrevBones[8];
* - uniform mat4 PrevWorld;
* - uniform vec4 RoughnessUniform;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 SubsurfaceUniform;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 TintedAlphaTestEnabled;
* - uniform vec4 UVAnimation;
* - uniform vec4 UseAlphaRewrite;
* - uniform vec4 ViewPositionAndTime;
*/

precision mediump float;
precision highp int;
uniform highp mat4 u_prevViewProj;
uniform highp mat4 u_viewProj;
uniform highp sampler2D s_MatTexture;
uniform highp vec4 HudOpacity;
uniform highp vec4 TileLightIntensity;
uniform highp vec4 u_prevWorldPosOffset;
#ifdef TINTING__ENABLED
in highp vec4 v_color0;
#endif
in highp vec3 v_prevWorldPos;
centroid in highp vec4 v_texcoords;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData[gl_MaxDrawBuffers];
void func_9b13f(inout highp float arg_6097c) {
    if (false)
    {
        arg_6097c = 0.501960813999176025390625;
        return;
    }
    else
    {
        arg_6097c = 0.4980392158031463623046875;
        return;
    }
}
void main() {
#ifdef TINTING__ENABLED
    highp vec4 var_a3564 = v_color0;
    highp vec4 var_13038 = vec4(v_color0.xyz, var_a3564.w);
    highp vec4 var_1b1d9 = var_13038;
#endif
#ifdef TINTING__DISABLED
    highp vec4 var_1e2a8 = texture(s_MatTexture, v_texcoords.zw);
#endif
#ifdef TINTING__ENABLED
    highp vec4 var_773de = texture(s_MatTexture, v_texcoords.zw);
    highp vec4 var_0ad11 = texture(s_MatTexture, v_texcoords.xy);
    var_773de.w = mix(var_0ad11.x * var_0ad11.w, var_0ad11.w, var_1b1d9.w);
    highp vec4 var_1e2a8 = var_773de;
    highp vec3 var_e9521 = var_1e2a8.xyz * var_13038.xyz;
    var_773de = vec4(var_e9521.x, var_e9521.y, var_e9521.z, var_1e2a8.w);
    highp vec3 var_53e42 = var_e9521.xyz;
#endif
#ifdef TINTING__DISABLED
    highp vec3 var_53e42 = var_1e2a8.xyz;
#endif
    highp vec3 var_0fefe = var_53e42;
    highp vec3 var_83526 = var_53e42 * vec3(0.077399380505084991455078125);
    highp vec3 var_138ce = pow((var_53e42 + vec3(0.054999999701976776123046875)) * vec3(0.947867333889007568359375), vec3(2.400000095367431640625));
    highp float var_8f9f2;
    if (var_0fefe.x <= 0.040449999272823333740234375)
    {
        var_8f9f2 = var_83526.x;
    }
    else
    {
        var_8f9f2 = var_138ce.x;
    }
    var_0fefe.x = var_8f9f2;
    highp float var_96ac3;
    if (var_0fefe.y <= 0.040449999272823333740234375)
    {
        var_96ac3 = var_83526.y;
    }
    else
    {
        var_96ac3 = var_138ce.y;
    }
    var_0fefe.y = var_96ac3;
    highp float var_8ff8b;
    if (var_0fefe.z <= 0.040449999272823333740234375)
    {
        var_8ff8b = var_83526.z;
    }
    else
    {
        var_8ff8b = var_138ce.z;
    }
    var_0fefe.z = var_8ff8b;
    highp vec4 var_edaf7 = vec4(var_0fefe.x, var_0fefe.y, var_0fefe.z, var_1e2a8.w);
    var_edaf7.w *= HudOpacity.x;
    highp vec4 var_1d587 = var_edaf7;
    highp vec4 var_08b04 = vec4(var_edaf7.xyz, var_1d587.w);
    highp vec4 var_6de71 = vec4(var_08b04.x, var_08b04.y, var_08b04.z, var_08b04.w);
    highp float var_1d2b2;
    func_9b13f(var_1d2b2);
    var_6de71.w = var_1d2b2;
    highp vec3 var_4842b = normalize(vec3(0.0, 1.0, 0.0));
    highp vec3 var_cd914 = var_4842b;
    highp vec2 var_645ff = var_4842b.xy * (1.0 / ((abs(var_cd914.x) + abs(var_cd914.y)) + abs(var_cd914.z)));
    highp vec2 var_5a694;
    if (var_cd914.z < 0.0)
    {
        var_5a694 = (vec2(1.0) - abs(var_645ff.yx)) * ((step(vec2(0.0), var_645ff) * 2.0) - vec2(1.0));
    }
    else
    {
        var_5a694 = var_645ff;
    }
    highp vec4 var_5dd1c = u_viewProj * vec4(v_worldPos, 1.0);
    highp vec4 var_46c40 = var_5dd1c;
    highp float var_bc97b = var_46c40.w;
    highp vec4 var_7ed87 = ((var_5dd1c / vec4(var_bc97b)) * 0.5) + vec4(0.5);
    var_46c40 = var_7ed87;
    highp vec4 var_21b68 = u_prevViewProj * vec4(v_prevWorldPos - u_prevWorldPosOffset.xyz, 1.0);
    highp vec4 var_96bda = var_21b68;
    highp float var_9ef48 = var_96bda.w;
    highp vec4 var_82203 = ((var_21b68 / vec4(var_9ef48)) * 0.5) + vec4(0.5);
    var_96bda = var_82203;
    highp vec2 var_ec5a5 = var_7ed87.xy - var_82203.xy;
    bgfx_FragData[0] = var_6de71;
    bgfx_FragData[1] = vec4(var_5a694.x, var_5a694.y, var_ec5a5.x, var_ec5a5.y);
    bgfx_FragData[2] = vec4(0.0, TileLightIntensity.x, TileLightIntensity.y, 1.0);
}
