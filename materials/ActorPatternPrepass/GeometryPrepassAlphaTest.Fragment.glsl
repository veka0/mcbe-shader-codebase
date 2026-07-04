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
* - CHANGE_COLOR__MULTI (not used)
* - CHANGE_COLOR__OFF (not used)
* - CHANGE_COLOR__ON (not used)
*
* Emissive:
* - EMISSIVE__EMISSIVE (not used)
* - EMISSIVE__EMISSIVE_ONLY (not used)
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
* - MASKED_MULTITEXTURE__OFF (not used)
* - MASKED_MULTITEXTURE__ON (not used)
*
* MultiColorTint:
* - MULTI_COLOR_TINT__OFF (not used)
* - MULTI_COLOR_TINT__ON (not used)
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
* - uniform lowp sampler2D s_MatTexture2;
* - uniform lowp sampler2D s_NormalTexture;
*
* Uniforms:
* - uniform vec4 ActorFPEpsilon;
* - uniform vec4 BlockLightColor;
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
* - uniform vec4 UseAlphaRewrite;
* - uniform vec4 ViewPositionAndTime;
*/

precision mediump float;
precision highp int;
float var_238cd;
uniform highp mat4 u_invView;
uniform highp mat4 u_prevViewProj;
uniform highp mat4 u_view;
uniform highp mat4 u_viewProj;
uniform highp sampler2D s_MERSTexture;
#ifdef TINTING__ENABLED
uniform highp sampler2D s_MatTexture2;
#endif
uniform highp sampler2D s_MatTexture;
uniform highp vec4 ActorFPEpsilon;
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
uniform highp vec4 DitheringEnabledToggle;
uniform highp vec4 EmissiveUniform;
uniform highp vec4 HudOpacity;
uniform highp vec4 MetalnessUniform;
uniform highp vec4 PBRTextureFlags;
#ifdef TINTING__ENABLED
uniform highp vec4 PatternColors[7];
uniform highp vec4 PatternCount;
uniform highp vec4 PatternUVOffsetsAndScales[7];
#endif
uniform highp vec4 RoughnessUniform;
uniform highp vec4 SubsurfaceUniform;
uniform highp vec4 TileLightIntensity;
uniform highp vec4 u_prevWorldPosOffset;
in highp vec4 v_clipPosition;
in highp vec3 v_normal;
in highp vec3 v_prevWorldPos;
centroid in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData0;
layout(location = 1) out highp vec4 bgfx_FragData1;
layout(location = 2) out highp vec4 bgfx_FragData2;
void func_fb7ab(inout highp float arg_0840d, inout highp float arg_f7959, inout highp float arg_95241) {
    if (arg_0840d > arg_f7959)
    {
        arg_95241 = 0.501960813999176025390625 + (0.4980392158031463623046875 * arg_0840d);
        return;
    }
    else
    {
        arg_95241 = 0.4980392158031463623046875 - (0.4980392158031463623046875 * arg_f7959);
        return;
    }
}
void main() {
#ifdef TINTING__DISABLED
    highp vec4 var_a9236 = texture(s_MatTexture, v_texcoord0);
#endif
#ifdef TINTING__ENABLED
    highp vec4 var_90407 = texture(s_MatTexture, v_texcoord0);
    highp vec4 var_a9236 = var_90407;
    highp vec4 var_a6640 = var_90407;
    for (int var_f2336 = 0; var_f2336 < int(PatternCount.x); var_f2336++)
    {
        highp vec4 var_96930 = texture(s_MatTexture2, (PatternUVOffsetsAndScales[var_f2336].zw * v_texcoord0) + PatternUVOffsetsAndScales[var_f2336].xy) * PatternColors[var_f2336];
        highp vec4 var_df244 = var_96930;
        var_a6640 = mix(var_a6640, var_96930, vec4(var_df244.w));
    }
    var_a6640.w = 1.0;
    var_a9236 = var_a6640;
#endif
    bool var_711f5 = var_a9236.w < ActorFPEpsilon.x;
    bool var_7df86;
    if (!var_711f5)
    {
        highp vec2 var_4be3d = DitherParams2[0].xy;
        bool var_63892;
        if (DitheringEnabledToggle.x != 0.0)
        {
            highp mat4 var_24edd = u_view;
            highp vec4 var_3267d = v_clipPosition;
            highp vec2 var_f4f10 = floor(((((v_clipPosition.xyz / vec3(var_3267d.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[0].z)) * DitherParams2[0].z;
            highp vec2 var_c55b8 = floor(var_f4f10 * 0.25);
            highp vec2 var_63b62 = floor(var_f4f10 * 0.5);
            highp vec2 var_5fe78 = floor(var_f4f10);
            var_63892 = smoothstep(var_4be3d.x, var_4be3d.y, dot(-normalize(vec4(var_24edd[0].z, var_24edd[1].z, var_24edd[2].z, var_238cd).xyz), v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)) <= (((((((fract((var_c55b8.x * 0.5) + ((var_c55b8.y * var_c55b8.y) * 0.75)) * 0.25) + fract((var_63b62.x * 0.5) + ((var_63b62.y * var_63b62.y) * 0.75))) * 0.25) + fract((var_5fe78.x * 0.5) + ((var_5fe78.y * var_5fe78.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
        }
        else
        {
            var_63892 = false;
        }
        var_7df86 = var_63892;
    }
    else
    {
        var_7df86 = var_711f5;
    }
    if (var_7df86)
    {
        discard;
    }
    highp vec4 var_0d8a1 = var_a9236;
    var_0d8a1.w *= HudOpacity.x;
    var_a9236 = var_0d8a1;
    highp vec4 var_1d587 = var_0d8a1;
    int var_7ba9c = int(PBRTextureFlags.x);
    highp float var_f7888;
    highp float var_7fbcf;
    highp float var_0d3c0;
    highp float var_da7e2;
    if ((var_7ba9c & 1) == 1)
    {
        highp vec4 var_4035b = texture(s_MERSTexture, v_texcoord0);
        highp float var_ae1fa;
        if ((var_7ba9c & 2) == 2)
        {
            var_ae1fa = var_4035b.w;
        }
        else
        {
            var_ae1fa = SubsurfaceUniform.x;
        }
        var_da7e2 = var_ae1fa;
        var_0d3c0 = var_4035b.z;
        var_7fbcf = var_4035b.y;
        var_f7888 = var_4035b.x;
    }
    else
    {
        var_da7e2 = SubsurfaceUniform.x;
        var_0d3c0 = RoughnessUniform.x;
        var_7fbcf = EmissiveUniform.x;
        var_f7888 = MetalnessUniform.x;
    }
    highp vec4 var_08b04 = vec4(var_0d8a1.xyz, var_1d587.w);
    highp vec4 var_e74f1 = vec4(var_08b04.x, var_08b04.y, var_08b04.z, var_08b04.w);
    highp float var_7aa46;
    func_fb7ab(var_f7888, var_da7e2, var_7aa46);
    var_e74f1.w = var_7aa46;
    highp vec3 var_8c816 = normalize(v_normal);
    highp vec3 var_cd914 = var_8c816;
    highp vec2 var_645ff = var_8c816.xy * (1.0 / ((abs(var_cd914.x) + abs(var_cd914.y)) + abs(var_cd914.z)));
    highp vec2 var_72494;
    if (var_cd914.z < 0.0)
    {
        var_72494 = (vec2(1.0) - abs(var_645ff.yx)) * ((step(vec2(0.0), var_645ff) * 2.0) - vec2(1.0));
    }
    else
    {
        var_72494 = var_645ff;
    }
    highp vec4 var_5dd1c = u_viewProj * vec4(v_worldPos, 1.0);
    highp vec4 var_46c40 = var_5dd1c;
    highp float var_bc97b = var_46c40.w;
    highp vec4 var_efb33 = ((var_5dd1c / vec4(var_bc97b)) * 0.5) + vec4(0.5);
    var_46c40 = var_efb33;
    highp vec4 var_21b68 = u_prevViewProj * vec4(v_prevWorldPos - u_prevWorldPosOffset.xyz, 1.0);
    highp vec4 var_96bda = var_21b68;
    highp float var_9ef48 = var_96bda.w;
    highp vec4 var_c94a9 = ((var_21b68 / vec4(var_9ef48)) * 0.5) + vec4(0.5);
    var_96bda = var_c94a9;
    bgfx_FragData0 = var_e74f1;
    bgfx_FragData1 = vec4(var_72494, var_efb33.xy - var_c94a9.xy);
    bgfx_FragData2 = vec4(var_7fbcf, TileLightIntensity.x, TileLightIntensity.y, var_0d3c0);
}
