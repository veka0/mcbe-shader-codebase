#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_PASS (not used)
* - DEPTH_ONLY_OPAQUE_PASS (not used)
* - GEOMETRY_PREPASS_PASS (not used)
* - GEOMETRY_PREPASS_ALPHA_TEST_PASS (not used)
*
* Change_Color:
* - CHANGE_COLOR__MULTI
* - CHANGE_COLOR__OFF
* - CHANGE_COLOR__ON
*
* Emissive:
* - EMISSIVE__OFF (not used)
*
* Fancy:
* - FANCY__OFF (not used)
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* MaskedMultitexture:
* - MASKED_MULTITEXTURE__OFF
* - MASKED_MULTITEXTURE__ON
*
* MultiColorTint:
* - MULTI_COLOR_TINT__OFF (not used)
* - MULTI_COLOR_TINT__ON (not used)
*
* Tinting:
* - TINTING__DISABLED (not used)
* - TINTING__ENABLED (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MERSTexture;
* - uniform lowp sampler2D s_MatTexture;
* - uniform lowp sampler2D s_MatTexture1;
* - uniform lowp sampler2D s_MatTexture2;
* - uniform lowp sampler2D s_NormalTexture;
*
* Uniforms:
* - uniform vec4 ActorFPEpsilon;
* - uniform mat4 Bones[8];
* - uniform vec4 ChangeColor;
* - uniform vec4 ColorBased;
* - uniform vec4 EmissiveUniform;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 GlintColor;
* - uniform vec4 HudOpacity;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MatColor;
* - uniform vec4 MaterialID;
* - uniform vec4 MetalnessUniform;
* - uniform vec4 MultiplicativeTintColor;
* - uniform vec4 OverlayColor;
* - uniform vec4 PBRTextureFlags;
* - uniform vec4 PatternColors[7];
* - uniform vec4 PatternCount;
* - uniform vec4 PatternUVOffsetsAndScales[7];
* - uniform mat4 PrevBones[8];
* - uniform mat4 PrevWorld;
* - uniform vec4 RoughnessUniform;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 SubsurfaceUniform;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
* - uniform vec4 TintedAlphaTestEnabled;
* - uniform vec4 UVAnimation;
* - uniform vec4 UVScale;
* - uniform vec4 UseAlphaRewrite;
* - uniform vec4 ViewPositionAndTime;
*/

precision mediump float;
precision highp int;
uniform highp mat4 u_prevViewProj;
uniform highp mat4 u_viewProj;
uniform highp sampler2D s_MatTexture1;
uniform highp sampler2D s_MatTexture2;
uniform highp sampler2D s_MatTexture;
#ifndef CHANGE_COLOR__OFF
uniform highp vec4 ActorFPEpsilon;
uniform highp vec4 ChangeColor;
#endif
uniform highp vec4 ColorBased;
uniform highp vec4 GlintColor;
uniform highp vec4 MatColor;
#ifdef CHANGE_COLOR__MULTI
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
uniform highp vec4 PatternColors[7];
uniform highp vec4 PatternCount;
uniform highp vec4 PatternUVOffsetsAndScales[7];
uniform highp vec4 TileLightColor;
uniform highp vec4 TileLightIntensity;
uniform highp vec4 u_prevWorldPosOffset;
in highp vec4 v_color0;
in highp vec4 v_layerUv;
in highp vec3 v_normal;
in highp vec3 v_prevWorldPos;
centroid in highp vec2 v_texcoord0;
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
#ifdef MASKED_MULTITEXTURE__OFF
    highp vec4 var_f7872 = MatColor * texture(s_MatTexture, v_texcoord0);
#endif
#ifdef MASKED_MULTITEXTURE__ON
    highp vec4 var_ade26 = texture(s_MatTexture1, v_texcoord0);
    highp vec4 var_76534 = var_ade26;
    highp vec4 var_f7872 = mix(var_ade26, MatColor * texture(s_MatTexture, v_texcoord0), vec4(float((((var_76534.x + var_76534.y) + var_76534.z) * (1.0 - var_76534.w)) > 0.0)));
#endif
#ifndef CHANGE_COLOR__OFF
    if (var_f7872.w < ActorFPEpsilon.x)
#endif
#ifdef CHANGE_COLOR__OFF
    if (var_f7872.w < 0.5)
#endif
    {
        discard;
    }
#ifdef CHANGE_COLOR__MULTI
    highp vec2 var_459de = var_f7872.xy;
    highp vec3 var_1099e = mix((var_f7872.xxx * ChangeColor.xyz).xyz, var_f7872.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_459de.y)));
    highp vec4 var_dd488 = vec4(var_1099e.x, var_1099e.y, var_1099e.z, var_f7872.w);
#endif
#ifndef CHANGE_COLOR__MULTI
    highp vec4 var_dd488 = var_f7872;
#endif
#ifdef CHANGE_COLOR__ON
    highp vec4 var_8a135 = ChangeColor;
    highp vec3 var_fba6e = mix(var_f7872.xyz, var_f7872.xyz * ChangeColor.xyz, vec3(var_dd488.w));
    var_dd488 = vec4(var_fba6e.x, var_fba6e.y, var_fba6e.z, var_f7872.w);
    var_dd488.w *= var_8a135.w;
#endif
    var_dd488.w = max(0.0, var_dd488.w);
    var_f7872 = var_dd488;
    highp vec4 var_24765 = var_dd488;
    for (int var_f2336 = 0; var_f2336 < int(PatternCount.x); var_f2336++)
    {
        highp vec4 var_96930 = texture(s_MatTexture2, (PatternUVOffsetsAndScales[var_f2336].zw * v_texcoord0) + PatternUVOffsetsAndScales[var_f2336].xy) * PatternColors[var_f2336];
        highp vec4 var_df244 = var_96930;
        var_24765 = mix(var_24765, var_96930, vec4(var_df244.w));
    }
    var_24765.w = 1.0;
    highp vec4 var_2b5c5 = (GlintColor * (texture(s_MatTexture1, fract(v_layerUv.xy)).xyzx + texture(s_MatTexture1, fract(v_layerUv.zw)).xyzx)) * TileLightColor;
    highp vec4 var_51875 = vec4(var_2b5c5.xyz * var_2b5c5.xyz, abs(var_2b5c5.w)) + vec4(mix((var_24765.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x))).xyz, OverlayColor.xyz, vec3(OverlayColor.w)), 0.0);
    var_51875.w = var_24765.w;
    highp vec4 var_1d587 = var_51875;
    highp vec4 var_08b04 = vec4(var_51875.xyz, var_1d587.w);
    highp vec4 var_6de71 = vec4(var_08b04.x, var_08b04.y, var_08b04.z, var_08b04.w);
    highp float var_1d2b2;
    func_9b13f(var_1d2b2);
    var_6de71.w = var_1d2b2;
    highp vec3 var_8c816 = normalize(v_normal);
    highp vec3 var_cd914 = var_8c816;
    highp vec2 var_645ff = var_8c816.xy * (1.0 / ((abs(var_cd914.x) + abs(var_cd914.y)) + abs(var_cd914.z)));
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
    bgfx_FragData[2] = vec4(0.0, TileLightIntensity.x, TileLightIntensity.y, 0.5);
}
