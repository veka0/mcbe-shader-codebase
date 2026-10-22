#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_ALPHA_TEST_PASS (not used)
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
* - uniform vec4 GlintColor;
* - uniform vec4 HudOpacity;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MatColor;
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
* - uniform vec4 UVScale;
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
uniform highp sampler2D s_MatTexture1;
uniform highp sampler2D s_MatTexture;
uniform highp sampler2D s_NormalTexture;
#ifndef CHANGE_COLOR__OFF
uniform highp vec4 ActorFPEpsilon;
#endif
uniform highp vec4 BlockLightColor;
#ifndef CHANGE_COLOR__OFF
uniform highp vec4 ChangeColor;
#endif
uniform highp vec4 ColorBased;
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
uniform highp vec4 DitheringEnabledToggle;
uniform highp vec4 EmissiveUniform;
uniform highp vec4 GlintColor;
uniform highp vec4 MatColor;
uniform highp vec4 MetalnessUniform;
#ifdef CHANGE_COLOR__MULTI
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
uniform highp vec4 PBRTextureFlags;
uniform highp vec4 RoughnessUniform;
uniform highp vec4 SubsurfaceUniform;
uniform highp vec4 TileLightColor;
uniform highp vec4 TileLightIntensity;
uniform highp vec4 u_prevWorldPosOffset;
in highp vec3 v_bitangent;
in highp vec4 v_clipPosition;
in highp vec4 v_color0;
in highp vec4 v_layerUv;
in highp vec3 v_normal;
in highp vec3 v_prevWorldPos;
in highp vec3 v_tangent;
centroid in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out uvec4 bgfx_FragData0;
layout(location = 1) out highp vec4 bgfx_FragData1;
layout(location = 2) out highp vec4 bgfx_FragData2;
void func_ed4c1(inout highp vec3 arg_214af) {
    highp vec4 loc_df982 = textureLod(s_NormalTexture, v_texcoord0, 0.0);
    highp vec3 loc_168d1 = vec3(0.0, 0.0, 1.0);
    highp vec2 loc_17df5 = fract(v_texcoord0 * vec2(textureSize(s_NormalTexture, 0)));
    loc_168d1.x = (step(0.916666686534881591796875, loc_17df5.x) * ((loc_df982.y * 2.0) - 1.0)) + (step(loc_17df5.x, 0.083333335816860198974609375) * (1.0 - (loc_df982.w * 2.0)));
    loc_168d1.y = (step(0.916666686534881591796875, loc_17df5.y) * ((loc_df982.z * 2.0) - 1.0)) + (step(loc_17df5.y, 0.083333335816860198974609375) * (1.0 - (loc_df982.x * 2.0)));
    loc_168d1.x = step(0.004999999888241291046142578125, abs(loc_168d1.x)) * loc_168d1.x;
    loc_168d1.y = step(0.004999999888241291046142578125, abs(loc_168d1.y)) * loc_168d1.y;
    loc_168d1.z = 0.25;
    highp vec3 loc_80882 = loc_168d1;
    highp vec3 loc_a1058 = normalize(loc_80882);
    loc_168d1 = loc_a1058;
    highp vec2 loc_e1c94 = loc_a1058.xy * 1.0;
    loc_168d1.x = loc_e1c94.x;
    loc_168d1.y = loc_e1c94.y;
    arg_214af = loc_168d1;
}
void func_7fc4d(inout int arg_f1e9d, inout highp vec3 arg_ef24f) {
    if ((arg_f1e9d & 4) == 4)
    {
        arg_ef24f = (texture(s_NormalTexture, v_texcoord0).xyz * 2.0) - vec3(1.0);
        return;
    }
    else
    {
        if ((arg_f1e9d & 8) == 8)
        {
            highp vec2 loc_ac6af = v_texcoord0;
            highp vec3 loc_ab72b = vec3(0.0, 0.0, 1.0);
            highp vec2 loc_2b303 = loc_ac6af;
            highp vec2 loc_4dc97 = loc_2b303 * vec2(textureSize(s_NormalTexture, 0));
            highp vec2 loc_700bf = fract(loc_4dc97);
            if (abs(loc_700bf.x - 0.5) < 0.0625)
            {
                loc_ac6af.x += ((loc_700bf.x > 0.5) ? 3.814697265625e-06 : (-3.814697265625e-06));
            }
            if (abs(loc_700bf.y - 0.5) < 0.0625)
            {
                loc_ac6af.y += ((loc_700bf.y > 0.5) ? 3.814697265625e-06 : (-3.814697265625e-06));
            }
            highp vec4 loc_fbe6c = textureGather(s_NormalTexture, loc_ac6af);
            highp vec2 loc_72024 = fract(loc_4dc97 + vec2(0.5));
            highp vec2 loc_2054b;
            if (loc_72024.y > 0.5)
            {
                loc_2054b = loc_fbe6c.xy;
            }
            else
            {
                loc_2054b = loc_fbe6c.wz;
            }
            highp vec2 loc_9b72d = loc_2054b;
            ivec2 loc_bde1e = ivec2(clamp(vec2(loc_72024.x - 0.083333335816860198974609375, loc_72024.x + 0.083333335816860198974609375) * 2.0, vec2(0.0), vec2(1.0)));
            loc_ab72b.x = loc_9b72d[loc_bde1e.x] - loc_9b72d[loc_bde1e.y];
            highp vec2 loc_d2f6f;
            if (loc_72024.x > 0.5)
            {
                loc_d2f6f = loc_fbe6c.zy;
            }
            else
            {
                loc_d2f6f = loc_fbe6c.wx;
            }
            loc_9b72d = loc_d2f6f;
            loc_bde1e = ivec2(clamp(vec2(loc_72024.y - 0.083333335816860198974609375, loc_72024.y + 0.083333335816860198974609375) * 2.0, vec2(0.0), vec2(1.0)));
            loc_ab72b.y = loc_9b72d[loc_bde1e.x] - loc_9b72d[loc_bde1e.y];
            loc_ab72b.z = 0.25;
            highp vec3 loc_5f5fa = loc_ab72b;
            highp vec3 loc_f99c6 = normalize(loc_5f5fa);
            loc_ab72b = loc_f99c6;
            highp vec2 loc_25091 = loc_f99c6.xy * 1.0;
            loc_ab72b.x = loc_25091.x;
            loc_ab72b.y = loc_25091.y;
            arg_ef24f = loc_ab72b;
            return;
        }
        else
        {
            if ((arg_f1e9d & 16) == 16)
            {
                highp vec3 loc_f77cb;
                func_ed4c1(loc_f77cb);
                arg_ef24f = loc_f77cb;
                return;
            }
        }
    }
    arg_ef24f = vec3(0.0, 0.0, 1.0);
}
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
#ifdef MASKED_MULTITEXTURE__OFF
    highp vec4 var_0f7f2 = MatColor * texture(s_MatTexture, v_texcoord0);
#endif
#ifdef MASKED_MULTITEXTURE__ON
    highp vec4 var_ade26 = texture(s_MatTexture1, v_texcoord0);
    highp vec4 var_76534 = var_ade26;
    highp vec4 var_0f7f2 = mix(var_ade26, MatColor * texture(s_MatTexture, v_texcoord0), vec4(float((((var_76534.x + var_76534.y) + var_76534.z) * (1.0 - var_76534.w)) > 0.0)));
#endif
    highp vec2 var_7c9c5 = DitherParams2[0].xy;
    bool var_fd5a0;
    if (DitheringEnabledToggle.x != 0.0)
    {
        highp mat4 var_4971e = u_view;
        highp vec2 var_2c6b3 = floor(((((v_clipPosition.xyz / vec3(v_clipPosition.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[0].z)) * DitherParams2[0].z;
        highp vec2 var_f4989 = floor(var_2c6b3 * 0.25);
        highp vec2 var_85686 = floor(var_2c6b3 * 0.5);
        highp vec2 var_09c49 = floor(var_2c6b3);
        var_fd5a0 = smoothstep(var_7c9c5.x, var_7c9c5.y, dot(-normalize(vec4(var_4971e[0].z, var_4971e[1].z, var_4971e[2].z, var_33fae).xyz), v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)) <= (((((((fract((var_f4989.x * 0.5) + ((var_f4989.y * var_f4989.y) * 0.75)) * 0.25) + fract((var_85686.x * 0.5) + ((var_85686.y * var_85686.y) * 0.75))) * 0.25) + fract((var_09c49.x * 0.5) + ((var_09c49.y * var_09c49.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        var_fd5a0 = false;
    }
#ifndef CHANGE_COLOR__OFF
    if (var_fd5a0 || (var_0f7f2.w < ActorFPEpsilon.x))
#endif
#ifdef CHANGE_COLOR__OFF
    if (var_fd5a0 || (var_0f7f2.w < 0.5))
#endif
    {
        discard;
    }
#ifndef CHANGE_COLOR__MULTI
    highp vec4 var_27243 = var_0f7f2;
#endif
#ifdef CHANGE_COLOR__MULTI
    highp vec4 var_a6909 = var_0f7f2;
    highp vec2 var_e1236 = var_0f7f2.xy;
    highp vec3 var_728f2 = var_0f7f2.xxx * ChangeColor.xyz;
#endif
#ifdef CHANGE_COLOR__ON
    highp vec4 var_8a135 = ChangeColor;
    highp float var_e3254 = var_27243.w;
    highp vec3 var_618b0 = mix(var_0f7f2.xyz, var_0f7f2.xyz * ChangeColor.xyz, vec3(var_e3254));
#endif
#ifdef CHANGE_COLOR__MULTI
    var_a6909.x = var_728f2.x;
#endif
#ifdef CHANGE_COLOR__ON
    var_27243.x = var_618b0.x;
#endif
#ifdef CHANGE_COLOR__MULTI
    var_a6909.y = var_728f2.y;
#endif
#ifdef CHANGE_COLOR__ON
    var_27243.y = var_618b0.y;
    var_27243.z = var_618b0.z;
#endif
#ifdef CHANGE_COLOR__MULTI
    var_a6909.z = var_728f2.z;
    highp vec4 var_60355 = var_a6909;
    highp vec3 var_ef570 = mix(var_60355.xyz, var_0f7f2.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_e1236.y)));
    var_a6909.x = var_ef570.x;
    var_a6909.y = var_ef570.y;
    var_a6909.z = var_ef570.z;
    highp vec4 var_27243 = var_a6909;
#endif
#ifdef CHANGE_COLOR__ON
    var_27243.w *= var_8a135.w;
#endif
    var_27243.w = max(0.0, var_27243.w);
    var_0f7f2 = var_27243;
    highp vec4 var_bf684 = var_27243;
    highp vec3 var_6f9dd = var_27243.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
    var_bf684.x = var_6f9dd.x;
    var_bf684.y = var_6f9dd.y;
    var_bf684.z = var_6f9dd.z;
    highp vec4 var_60f01 = var_bf684;
    highp vec3 var_2a9cf = mix(var_bf684.xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    var_60f01.x = var_2a9cf.x;
    var_60f01.y = var_2a9cf.y;
    var_60f01.z = var_2a9cf.z;
    var_bf684 = var_60f01;
    highp vec4 var_a2360 = (GlintColor * (texture(s_MatTexture1, fract(v_layerUv.xy)).xyzx + texture(s_MatTexture1, fract(v_layerUv.zw)).xyzx)) * TileLightColor;
    highp vec4 var_b78a0 = vec4(var_a2360.xyz * var_a2360.xyz, abs(var_a2360.w)) + vec4(var_60f01.xyz, 0.0);
    var_b78a0.w = var_60f01.w;
    int var_cd3a0 = int(PBRTextureFlags.x);
    highp vec4 var_1d587 = var_b78a0;
    highp float var_f7888;
    highp float var_c77d1;
    highp float var_5ad51;
    highp float var_da7e2;
    if ((var_cd3a0 & 1) == 1)
    {
        highp vec4 var_4035b = texture(s_MERSTexture, v_texcoord0);
        highp float var_ae1fa;
        if ((var_cd3a0 & 2) == 2)
        {
            var_ae1fa = var_4035b.w;
        }
        else
        {
            var_ae1fa = SubsurfaceUniform.x;
        }
        var_da7e2 = var_ae1fa;
        var_5ad51 = var_4035b.z;
        var_c77d1 = var_4035b.y;
        var_f7888 = var_4035b.x;
    }
    else
    {
        var_da7e2 = SubsurfaceUniform.x;
        var_5ad51 = RoughnessUniform.x;
        var_c77d1 = EmissiveUniform.x;
        var_f7888 = MetalnessUniform.x;
    }
    bool var_dcea4 = (var_cd3a0 & 4) == 4;
    bool var_8642c;
    if (!var_dcea4)
    {
        var_8642c = (var_cd3a0 & 8) == 8;
    }
    else
    {
        var_8642c = var_dcea4;
    }
    bool var_088a3;
    if (!var_8642c)
    {
        var_088a3 = (var_cd3a0 & 16) == 16;
    }
    else
    {
        var_088a3 = var_8642c;
    }
    highp vec3 var_e89aa;
    if (var_088a3)
    {
        highp vec3 var_66208;
        func_7fc4d(var_cd3a0, var_66208);
        var_e89aa = normalize(mat3(normalize(v_tangent), normalize(v_bitangent), normalize(v_normal)) * var_66208);
    }
    else
    {
        var_e89aa = v_normal;
    }
    highp vec4 var_a9d56 = BlockLightColor;
    highp vec4 var_d93e5 = vec4(var_b78a0.xyz, var_1d587.w);
    highp vec4 var_33385 = vec4(0.0);
    var_d93e5.x = var_b78a0.x;
    var_d93e5.y = var_b78a0.y;
    var_d93e5.z = var_b78a0.z;
    highp float var_7aa46;
    func_fb7ab(var_f7888, var_da7e2, var_7aa46);
    var_d93e5.w = var_7aa46;
    highp vec3 var_089df = normalize(var_e89aa);
    highp vec3 var_cd914 = var_089df;
    highp vec2 var_645ff = var_089df.xy * (1.0 / ((abs(var_cd914.x) + abs(var_cd914.y)) + abs(var_cd914.z)));
    highp vec2 var_8860a;
    if (var_cd914.z < 0.0)
    {
        var_8860a = (vec2(1.0) - abs(var_645ff.yx)) * ((step(vec2(0.0), var_645ff) * 2.0) - vec2(1.0));
    }
    else
    {
        var_8860a = var_645ff;
    }
    var_33385.x = var_8860a.x;
    var_33385.y = var_8860a.y;
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
    highp vec2 var_fd2cd = var_7ed87.xy - var_82203.xy;
    var_33385.z = var_fd2cd.x;
    var_33385.w = var_fd2cd.y;
    highp vec3 var_f88c4 = BlockLightColor.xyz;
    highp vec3 var_e61b8;
    if ((((var_f88c4.x + var_f88c4.y) + var_f88c4.z) < 9.9999997473787516355514526367188e-05) && (TileLightIntensity.x > 9.9999997473787516355514526367188e-05))
    {
        highp float var_c1e8f = TileLightIntensity.x * TileLightIntensity.x;
        var_e61b8 = clamp(vec3(var_c1e8f, var_c1e8f * ((((var_c1e8f * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625), var_c1e8f * (((var_c1e8f * var_c1e8f) * 0.60000002384185791015625) + 0.4000000059604644775390625)), vec3(0.0), vec3(1.0));
    }
    else
    {
        var_e61b8 = BlockLightColor.xyz;
    }
    highp vec3 var_8f0e5 = var_e61b8 * vec3(0.16666667163372039794921875);
    highp vec4 var_f46ce = vec4(var_8f0e5, 0.0039215688593685626983642578125);
    highp vec2 var_8a7dd = max(var_f46ce.xy, var_f46ce.zw);
    highp float var_a7109 = ceil(clamp(max(var_8a7dd.x, var_8a7dd.y), 0.0, 1.0) * 255.0) * 0.0039215688593685626983642578125;
    uvec4 var_63c1c = uvec4(clamp(vec4(var_8f0e5 / vec3(var_a7109), var_a7109), vec4(0.0), vec4(1.0)) * 255.0);
    uvec2 var_768db = var_63c1c.xy;
    uvec2 var_f7a74 = uvec2(var_768db.x & 255u, var_768db.y & 255u);
    uvec2 var_cc1c7 = var_63c1c.zw;
    uvec2 var_8bc3e = uvec2(var_cc1c7.x & 255u, var_cc1c7.y & 255u);
    uvec2 var_a74c0 = uvec2((var_f7a74.x << 8u) | var_f7a74.y, (var_8bc3e.x << 8u) | var_8bc3e.y);
    highp vec3 var_0b329 = normalize(v_normal);
    bvec3 var_50211 = greaterThanEqual(abs(var_0b329), vec3(0.9900000095367431640625));
    ivec3 var_f1fb7 = ivec3(any(lessThan(var_0b329, vec3(-0.5))) ? (-1) : 1) * ivec3(int(var_50211.x), int(var_50211.y), int(var_50211.z));
    ivec3 var_6364f = abs(var_f1fb7);
    uvec2 var_5909e = uvec2(uint(clamp(var_5ad51, 0.0, 1.0) * 255.0) & 255u, uint(clamp(var_c77d1, 0.0, 1.0) * 255.0) & 255u);
    bgfx_FragData0 = uvec4((var_5909e.x << 8u) | var_5909e.y, var_a74c0.x, var_a74c0.y, (uint(clamp(TileLightIntensity.y, 0.0, 1.0) * 255.0) | uint(((uint(floor(var_a9d56.w * 255.0)) & 1u) != 0u) ? 256 : 0)) | ((((uint(var_6364f.x + var_6364f.z) | uint((var_6364f.y + var_6364f.z) << 1)) | uint(int(any(equal(vec3(var_f1fb7), vec3(-1.0)))) << 2)) & 7u) << uint(9)));
    bgfx_FragData1 = var_d93e5;
    bgfx_FragData2 = var_33385;
}
