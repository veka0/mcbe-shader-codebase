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
* - EMISSIVE__EMISSIVE (not used)
* - EMISSIVE__EMISSIVE_ONLY (not used)
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
* - MASKED_MULTITEXTURE__OFF
* - MASKED_MULTITEXTURE__ON
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
float var_33fae;
uniform highp mat4 u_invView;
uniform highp mat4 u_prevViewProj;
uniform highp mat4 u_view;
uniform highp mat4 u_viewProj;
uniform highp sampler2D s_MERSTexture;
#ifdef MASKED_MULTITEXTURE__ON
uniform highp sampler2D s_MatTexture1;
#endif
uniform highp sampler2D s_MatTexture;
uniform highp sampler2D s_NormalTexture;
#ifndef CHANGE_COLOR__OFF
uniform highp vec4 ChangeColor;
#endif
uniform highp vec4 ColorBased;
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
uniform highp vec4 DitheringEnabledToggle;
uniform highp vec4 EmissiveUniform;
uniform highp vec4 MatColor;
uniform highp vec4 MetalnessUniform;
#ifdef CHANGE_COLOR__MULTI
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
uniform highp vec4 PBRTextureFlags;
uniform highp vec4 RoughnessUniform;
uniform highp vec4 SubsurfaceUniform;
uniform highp vec4 TileLightIntensity;
uniform highp vec4 u_prevWorldPosOffset;
in highp vec3 v_bitangent;
in highp vec4 v_clipPosition;
in highp vec4 v_color0;
in highp vec3 v_normal;
in highp vec3 v_prevWorldPos;
in highp vec3 v_tangent;
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
#if defined(MASKED_MULTITEXTURE__OFF) && !defined(CHANGE_COLOR__OFF)
    highp vec4 var_98b25 = MatColor * texture(s_MatTexture, v_texcoord0);
#endif
#if defined(CHANGE_COLOR__OFF) && defined(MASKED_MULTITEXTURE__OFF)
    highp vec4 var_29d0e = MatColor * texture(s_MatTexture, v_texcoord0);
#endif
#ifdef MASKED_MULTITEXTURE__ON
    highp vec4 var_7fef3 = texture(s_MatTexture1, v_texcoord0);
    highp vec4 var_0b7d3 = var_7fef3;
#endif
#if defined(CHANGE_COLOR__ON) && defined(MASKED_MULTITEXTURE__OFF)
    highp vec4 var_29d0e = var_98b25;
#endif
#if defined(MASKED_MULTITEXTURE__ON) && !defined(CHANGE_COLOR__OFF)
    highp vec4 var_98b25 = mix(var_7fef3, MatColor * texture(s_MatTexture, v_texcoord0), vec4(float((((var_0b7d3.x + var_0b7d3.y) + var_0b7d3.z) * (1.0 - var_0b7d3.w)) > 0.0)));
#endif
#if defined(CHANGE_COLOR__OFF) && defined(MASKED_MULTITEXTURE__ON)
    highp vec4 var_29d0e = mix(var_7fef3, MatColor * texture(s_MatTexture, v_texcoord0), vec4(float((((var_0b7d3.x + var_0b7d3.y) + var_0b7d3.z) * (1.0 - var_0b7d3.w)) > 0.0)));
#endif
#ifdef CHANGE_COLOR__MULTI
    highp vec2 var_459de = var_98b25.xy;
    highp vec3 var_1099e = mix((var_98b25.xxx * ChangeColor.xyz).xyz, var_98b25.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_459de.y)));
    highp vec4 var_29d0e = vec4(var_1099e.x, var_1099e.y, var_1099e.z, var_98b25.w);
#endif
#if defined(CHANGE_COLOR__ON) && defined(MASKED_MULTITEXTURE__ON)
    highp vec4 var_29d0e = var_98b25;
#endif
#ifdef CHANGE_COLOR__ON
    highp vec4 var_8a135 = ChangeColor;
    highp vec3 var_fba6e = mix(var_98b25.xyz, var_98b25.xyz * ChangeColor.xyz, vec3(var_29d0e.w));
    var_29d0e = vec4(var_fba6e.x, var_fba6e.y, var_fba6e.z, var_98b25.w);
    var_29d0e.w *= var_8a135.w;
#endif
    var_29d0e.w = max(0.0, var_29d0e.w);
    highp vec4 var_ca0de = var_29d0e;
    highp vec2 var_7c9c5 = DitherParams2[0].xy;
    bool var_3ab8d;
    if (DitheringEnabledToggle.x != 0.0)
    {
        highp mat4 var_4971e = u_view;
        highp vec4 var_d36cf = v_clipPosition;
        highp vec2 var_886c2 = floor(((((v_clipPosition.xyz / vec3(var_d36cf.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[0].z)) * DitherParams2[0].z;
        highp vec2 var_f4989 = floor(var_886c2 * 0.25);
        highp vec2 var_85686 = floor(var_886c2 * 0.5);
        highp vec2 var_09c49 = floor(var_886c2);
        var_3ab8d = smoothstep(var_7c9c5.x, var_7c9c5.y, dot(-normalize(vec4(var_4971e[0].z, var_4971e[1].z, var_4971e[2].z, var_33fae).xyz), v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)) <= (((((((fract((var_f4989.x * 0.5) + ((var_f4989.y * var_f4989.y) * 0.75)) * 0.25) + fract((var_85686.x * 0.5) + ((var_85686.y * var_85686.y) * 0.75))) * 0.25) + fract((var_09c49.x * 0.5) + ((var_09c49.y * var_09c49.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        var_3ab8d = false;
    }
    var_ca0de.w *= (var_3ab8d ? 0.0 : 1.0);
    highp vec3 var_f710c = mix((var_ca0de.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x))).xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    highp vec4 var_89833 = vec4(var_f710c.x, var_f710c.y, var_f710c.z, var_ca0de.w);
    int var_f71fc = int(PBRTextureFlags.x);
    highp float var_f7888;
    highp float var_7fbcf;
    highp float var_0d3c0;
    highp float var_da7e2;
    if ((var_f71fc & 1) == 1)
    {
        highp vec4 var_4035b = texture(s_MERSTexture, v_texcoord0);
        highp float var_ae1fa;
        if ((var_f71fc & 2) == 2)
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
    highp vec3 var_76f62;
    if ((var_f71fc & 4) == 4)
    {
        var_76f62 = normalize(mat3(normalize(v_tangent), normalize(v_bitangent), normalize(v_normal)) * ((texture(s_NormalTexture, v_texcoord0).xyz * 2.0) - vec3(1.0)));
    }
    else
    {
        highp vec3 var_0d7aa;
        if ((var_f71fc & 8) == 8)
        {
            highp vec2 var_ac6af = v_texcoord0;
            highp vec3 var_73501 = vec3(0.0, 0.0, 1.0);
            highp vec2 var_2b303 = var_ac6af;
            highp vec2 var_4dc97 = var_2b303 * vec2(textureSize(s_NormalTexture, 0));
            highp vec2 var_700bf = fract(var_4dc97);
            if (abs(var_700bf.x - 0.5) < 0.0625)
            {
                var_ac6af.x += ((var_700bf.x > 0.5) ? 3.814697265625e-06 : (-3.814697265625e-06));
            }
            if (abs(var_700bf.y - 0.5) < 0.0625)
            {
                var_ac6af.y += ((var_700bf.y > 0.5) ? 3.814697265625e-06 : (-3.814697265625e-06));
            }
            highp vec4 var_fbe6c = textureGather(s_NormalTexture, var_ac6af);
            highp vec2 var_6748a = fract(var_4dc97 + vec2(0.5));
            highp vec2 var_2054b;
            if (var_6748a.y > 0.5)
            {
                var_2054b = var_fbe6c.xy;
            }
            else
            {
                var_2054b = var_fbe6c.wz;
            }
            highp vec2 var_97412 = var_2054b;
            ivec2 var_85f5c = ivec2(clamp(vec2(var_6748a.x - 0.083333335816860198974609375, var_6748a.x + 0.083333335816860198974609375) * 2.0, vec2(0.0), vec2(1.0)));
            var_73501.x = var_97412[var_85f5c.x] - var_97412[var_85f5c.y];
            highp vec2 var_d2f6f;
            if (var_6748a.x > 0.5)
            {
                var_d2f6f = var_fbe6c.zy;
            }
            else
            {
                var_d2f6f = var_fbe6c.wx;
            }
            var_97412 = var_d2f6f;
            var_85f5c = ivec2(clamp(vec2(var_6748a.y - 0.083333335816860198974609375, var_6748a.y + 0.083333335816860198974609375) * 2.0, vec2(0.0), vec2(1.0)));
            var_73501.y = var_97412[var_85f5c.x] - var_97412[var_85f5c.y];
            var_73501.z = 0.25;
            highp vec3 var_822b4 = normalize(var_73501);
            highp vec2 var_2df8f = var_822b4.xy * 1.0;
            var_73501 = vec3(var_2df8f.x, var_2df8f.y, var_822b4.z);
            var_0d7aa = normalize(mat3(normalize(v_tangent), normalize(v_bitangent), normalize(v_normal)) * var_73501);
        }
        else
        {
            var_0d7aa = v_normal;
        }
        var_76f62 = var_0d7aa;
    }
    highp vec4 var_39c01 = vec4(var_f710c, var_89833.w);
    highp vec4 var_e74f1 = vec4(var_39c01.x, var_39c01.y, var_39c01.z, var_39c01.w);
    highp float var_7aa46;
    func_fb7ab(var_f7888, var_da7e2, var_7aa46);
    var_e74f1.w = var_7aa46;
    highp vec3 var_089df = normalize(var_76f62);
    highp vec3 var_cd914 = var_089df;
    highp vec2 var_645ff = var_089df.xy * (1.0 / ((abs(var_cd914.x) + abs(var_cd914.y)) + abs(var_cd914.z)));
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
