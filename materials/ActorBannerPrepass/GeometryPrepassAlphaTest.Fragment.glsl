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
float var_238cd;
uniform highp mat4 u_invView;
uniform highp mat4 u_prevViewProj;
uniform highp mat4 u_view;
uniform highp mat4 u_viewProj;
uniform highp sampler2D s_MatTexture;
uniform highp vec4 ActorFPEpsilon;
uniform highp vec4 BannerBasePBRTextureData[4];
uniform highp vec4 BlockLightColor;
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
uniform highp vec4 DitheringEnabledToggle;
uniform highp vec4 HudOpacity;
uniform highp vec4 TileLightIntensity;
uniform highp vec4 u_prevWorldPosOffset;
in highp vec3 v_bitangent;
in highp vec4 v_clipPosition;
#ifdef TINTING__ENABLED
in highp vec4 v_color0;
#endif
in highp vec3 v_normal;
in highp vec3 v_prevWorldPos;
in highp vec3 v_tangent;
centroid in highp vec4 v_texcoords;
in highp vec3 v_worldPos;
layout(location = 0) out uvec4 bgfx_FragData0;
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
#ifdef TINTING__ENABLED
    highp vec4 var_a3564 = v_color0;
    highp vec4 var_13038 = vec4(v_color0.xyz, var_a3564.w);
    highp vec4 var_1b1d9 = var_13038;
#endif
#ifdef TINTING__DISABLED
    highp vec4 var_2a22e = texture(s_MatTexture, v_texcoords.zw);
#endif
#ifdef TINTING__ENABLED
    highp vec4 var_45919 = texture(s_MatTexture, v_texcoords.zw);
    highp vec4 var_0ad11 = texture(s_MatTexture, v_texcoords.xy);
    var_45919.w = mix(var_0ad11.x * var_0ad11.w, var_0ad11.w, var_1b1d9.w);
    highp vec4 var_5fdbc = var_45919;
    highp vec3 var_f30a7 = var_5fdbc.xyz * var_13038.xyz;
    highp vec4 var_b626b = vec4(var_f30a7.x, var_f30a7.y, var_f30a7.z, var_5fdbc.w);
    var_45919 = var_b626b;
    highp vec4 var_2a22e = var_b626b;
#endif
    bool var_711f5 = var_2a22e.w < ActorFPEpsilon.x;
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
    highp vec4 var_414c0 = var_2a22e;
    var_414c0.w *= HudOpacity.x;
    highp vec4 var_1d587 = var_414c0;
    int var_16e32 = int(BannerBasePBRTextureData[2].x);
    highp vec2 var_7e242 = vec2(BannerBasePBRTextureData[1].x, BannerBasePBRTextureData[1].y);
    highp vec2 var_969fb = vec2(BannerBasePBRTextureData[1].z, BannerBasePBRTextureData[1].w);
    highp vec3 var_7291d;
    if ((var_16e32 & 4) == 4)
    {
        var_7291d = (texture(s_MatTexture, (v_texcoords.zw * var_7e242) + var_969fb).xyz * 2.0) - vec3(1.0);
    }
    else
    {
        highp vec3 var_a4d0b;
        if ((var_16e32 & 8) == 8)
        {
            highp vec2 var_9491c = (v_texcoords.zw * var_7e242) + var_969fb;
            highp vec3 var_2ae5f = vec3(0.0, 0.0, 1.0);
            highp float var_92e4d = clamp((min(BannerBasePBRTextureData[3].w - BannerBasePBRTextureData[3].y, BannerBasePBRTextureData[3].w) * (-1.0)) + 2.0, 0.0, 1.0);
            if (var_92e4d > 0.0)
            {
                highp vec2 var_f388f = var_9491c;
                highp vec2 var_a836e = var_f388f * vec2(textureSize(s_MatTexture, 0));
                highp vec2 var_f7221 = fract(var_a836e);
                if (abs(var_f7221.x - 0.5) < 0.0625)
                {
                    var_9491c.x += ((var_f7221.x > 0.5) ? 3.814697265625e-06 : (-3.814697265625e-06));
                }
                if (abs(var_f7221.y - 0.5) < 0.0625)
                {
                    var_9491c.y += ((var_f7221.y > 0.5) ? 3.814697265625e-06 : (-3.814697265625e-06));
                }
                highp vec4 var_224f0 = textureGather(s_MatTexture, var_9491c);
                highp vec2 var_64604 = fract(var_a836e + vec2(0.5));
                highp vec2 var_ed03c;
                if (var_64604.y > 0.5)
                {
                    var_ed03c = var_224f0.xy;
                }
                else
                {
                    var_ed03c = var_224f0.wz;
                }
                highp vec2 var_8b660 = var_ed03c;
                ivec2 var_5da0a = ivec2(clamp(vec2(var_64604.x - 0.083333335816860198974609375, var_64604.x + 0.083333335816860198974609375) * 2.0, vec2(0.0), vec2(1.0)));
                var_2ae5f.x = var_8b660[var_5da0a.x] - var_8b660[var_5da0a.y];
                highp vec2 var_a6d82;
                if (var_64604.x > 0.5)
                {
                    var_a6d82 = var_224f0.zy;
                }
                else
                {
                    var_a6d82 = var_224f0.wx;
                }
                var_8b660 = var_a6d82;
                var_5da0a = ivec2(clamp(vec2(var_64604.y - 0.083333335816860198974609375, var_64604.y + 0.083333335816860198974609375) * 2.0, vec2(0.0), vec2(1.0)));
                var_2ae5f.y = var_8b660[var_5da0a.x] - var_8b660[var_5da0a.y];
                var_2ae5f.z = 0.25;
                highp vec3 var_1cc05 = normalize(var_2ae5f);
                highp vec2 var_cb68a = var_1cc05.xy * var_92e4d;
                var_2ae5f = vec3(var_cb68a.x, var_cb68a.y, var_1cc05.z);
            }
            var_a4d0b = var_2ae5f;
        }
        else
        {
            highp vec3 var_8d6b3;
            if ((var_16e32 & 16) == 16)
            {
                highp vec2 var_5fac9 = (v_texcoords.zw * var_7e242) + var_969fb;
                highp float var_14a36 = min(BannerBasePBRTextureData[3].w - BannerBasePBRTextureData[3].y, BannerBasePBRTextureData[3].w);
                highp vec4 var_946d4 = textureLod(s_MatTexture, var_5fac9, 0.0);
                highp vec4 var_8c259 = var_946d4;
                bool var_b06a0 = var_8c259.x == var_8c259.y;
                bool var_5d1d0;
                if (var_b06a0)
                {
                    var_5d1d0 = var_8c259.y == var_8c259.z;
                }
                else
                {
                    var_5d1d0 = var_b06a0;
                }
                highp vec3 var_049a7;
                if (var_5d1d0)
                {
                    highp vec2 var_eaa59 = var_5fac9;
                    highp vec3 var_8029f = vec3(0.0, 0.0, 1.0);
                    highp float var_0725d = clamp((var_14a36 * (-1.0)) + 2.0, 0.0, 1.0);
                    if (var_0725d > 0.0)
                    {
                        highp vec2 var_7e76e = var_eaa59;
                        highp vec2 var_65dec = var_7e76e * vec2(textureSize(s_MatTexture, 0));
                        highp vec2 var_3af9d = fract(var_65dec);
                        if (abs(var_3af9d.x - 0.5) < 0.0625)
                        {
                            var_eaa59.x += ((var_3af9d.x > 0.5) ? 3.814697265625e-06 : (-3.814697265625e-06));
                        }
                        if (abs(var_3af9d.y - 0.5) < 0.0625)
                        {
                            var_eaa59.y += ((var_3af9d.y > 0.5) ? 3.814697265625e-06 : (-3.814697265625e-06));
                        }
                        highp vec4 var_e61ed = textureGather(s_MatTexture, var_eaa59);
                        highp vec2 var_30342 = fract(var_65dec + vec2(0.5));
                        highp vec2 var_9413e;
                        if (var_30342.y > 0.5)
                        {
                            var_9413e = var_e61ed.xy;
                        }
                        else
                        {
                            var_9413e = var_e61ed.wz;
                        }
                        highp vec2 var_ef69e = var_9413e;
                        ivec2 var_abbdc = ivec2(clamp(vec2(var_30342.x - 0.083333335816860198974609375, var_30342.x + 0.083333335816860198974609375) * 2.0, vec2(0.0), vec2(1.0)));
                        var_8029f.x = var_ef69e[var_abbdc.x] - var_ef69e[var_abbdc.y];
                        highp vec2 var_11531;
                        if (var_30342.x > 0.5)
                        {
                            var_11531 = var_e61ed.zy;
                        }
                        else
                        {
                            var_11531 = var_e61ed.wx;
                        }
                        var_ef69e = var_11531;
                        var_abbdc = ivec2(clamp(vec2(var_30342.y - 0.083333335816860198974609375, var_30342.y + 0.083333335816860198974609375) * 2.0, vec2(0.0), vec2(1.0)));
                        var_8029f.y = var_ef69e[var_abbdc.x] - var_ef69e[var_abbdc.y];
                        var_8029f.z = 0.25;
                        highp vec3 var_37fe4 = normalize(var_8029f);
                        highp vec2 var_156d1 = var_37fe4.xy * var_0725d;
                        var_8029f = vec3(var_156d1.x, var_156d1.y, var_37fe4.z);
                    }
                    var_049a7 = var_8029f;
                }
                else
                {
                    highp vec4 var_e396a = var_946d4;
                    highp vec3 var_43f82 = vec3(0.0, 0.0, 1.0);
                    highp float var_3e159 = clamp((var_14a36 * (-1.0)) + 2.0, 0.0, 1.0);
                    if (var_3e159 > 0.0)
                    {
                        highp vec2 var_f7b8a = fract(var_5fac9 * vec2(textureSize(s_MatTexture, 0)));
                        var_43f82.x = (step(0.916666686534881591796875, var_f7b8a.x) * ((var_e396a.y * 2.0) - 1.0)) + (step(var_f7b8a.x, 0.083333335816860198974609375) * (1.0 - (var_e396a.w * 2.0)));
                        var_43f82.y = (step(0.916666686534881591796875, var_f7b8a.y) * ((var_e396a.z * 2.0) - 1.0)) + (step(var_f7b8a.y, 0.083333335816860198974609375) * (1.0 - (var_e396a.x * 2.0)));
                        var_43f82.x = step(0.004999999888241291046142578125, abs(var_43f82.x)) * var_43f82.x;
                        var_43f82.y = step(0.004999999888241291046142578125, abs(var_43f82.y)) * var_43f82.y;
                        var_43f82.z = 0.25;
                        highp vec3 var_8c503 = normalize(var_43f82);
                        highp vec2 var_4a93c = var_8c503.xy * var_3e159;
                        var_43f82 = vec3(var_4a93c.x, var_4a93c.y, var_8c503.z);
                    }
                    var_049a7 = var_43f82;
                }
                var_8d6b3 = var_049a7;
            }
            else
            {
                var_8d6b3 = vec3(0.0, 0.0, 1.0);
            }
            var_a4d0b = var_8d6b3;
        }
        var_7291d = var_a4d0b;
    }
    highp float var_be4a2;
    highp float var_e87f4;
    highp float var_755f6;
    highp float var_e9ad4;
    if ((var_16e32 & 1) == 1)
    {
        highp vec4 var_fb54f = texture(s_MatTexture, (v_texcoords.zw * vec2(BannerBasePBRTextureData[0].x, BannerBasePBRTextureData[0].y)) + vec2(BannerBasePBRTextureData[0].z, BannerBasePBRTextureData[0].w));
        highp float var_0c75b;
        if ((var_16e32 & 2) == 2)
        {
            var_0c75b = var_fb54f.w;
        }
        else
        {
            var_0c75b = BannerBasePBRTextureData[3].x;
        }
        var_e9ad4 = var_0c75b;
        var_755f6 = var_fb54f.y;
        var_e87f4 = var_fb54f.x;
        var_be4a2 = var_fb54f.z;
    }
    else
    {
        var_e9ad4 = BannerBasePBRTextureData[3].x;
        var_755f6 = BannerBasePBRTextureData[2].z;
        var_e87f4 = BannerBasePBRTextureData[2].w;
        var_be4a2 = BannerBasePBRTextureData[2].y;
    }
    highp vec3 var_276aa;
    if (int(gl_FrontFacing) != 0)
    {
        var_276aa = -v_normal;
    }
    else
    {
        var_276aa = v_normal;
    }
    highp vec4 var_08b04 = vec4(var_414c0.xyz, var_1d587.w);
    highp vec4 var_6bfdc = vec4(var_08b04.x, var_08b04.y, var_08b04.z, var_08b04.w);
    highp float var_7aa46;
    func_fb7ab(var_e87f4, var_e9ad4, var_7aa46);
    var_6bfdc.w = var_7aa46;
    highp vec3 var_9c9d2 = normalize(transpose(transpose(mat3(normalize(v_tangent), normalize(v_bitangent), normalize(var_276aa)))) * var_7291d);
    highp vec3 var_cd914 = var_9c9d2;
    highp vec2 var_645ff = var_9c9d2.xy * (1.0 / ((abs(var_cd914.x) + abs(var_cd914.y)) + abs(var_cd914.z)));
    highp vec2 var_532c2;
    if (var_cd914.z < 0.0)
    {
        var_532c2 = (vec2(1.0) - abs(var_645ff.yx)) * ((step(vec2(0.0), var_645ff) * 2.0) - vec2(1.0));
    }
    else
    {
        var_532c2 = var_645ff;
    }
    highp vec4 var_5dd1c = u_viewProj * vec4(v_worldPos, 1.0);
    highp vec4 var_46c40 = var_5dd1c;
    highp float var_bc97b = var_46c40.w;
    highp vec4 var_603d8 = ((var_5dd1c / vec4(var_bc97b)) * 0.5) + vec4(0.5);
    var_46c40 = var_603d8;
    highp vec4 var_21b68 = u_prevViewProj * vec4(v_prevWorldPos - u_prevWorldPosOffset.xyz, 1.0);
    highp vec4 var_96bda = var_21b68;
    highp float var_9ef48 = var_96bda.w;
    highp vec4 var_d0ebc = ((var_21b68 / vec4(var_9ef48)) * 0.5) + vec4(0.5);
    var_96bda = var_d0ebc;
    highp vec3 var_f88c4 = BlockLightColor.xyz;
    highp vec3 var_fbfa9;
    if ((((var_f88c4.x + var_f88c4.y) + var_f88c4.z) < 9.9999997473787516355514526367188e-05) && (TileLightIntensity.x > 9.9999997473787516355514526367188e-05))
    {
        highp vec4 var_0bc6f = vec4(0.0);
        highp float var_88ce0 = TileLightIntensity.x * TileLightIntensity.x;
        var_fbfa9 = clamp(vec3(var_88ce0 + (var_0bc6f.x * var_0bc6f.w), (var_88ce0 * ((((var_88ce0 * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_0bc6f.y * var_0bc6f.w), (var_88ce0 * (((var_88ce0 * var_88ce0) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_0bc6f.z * var_0bc6f.w)), vec3(0.0), vec3(1.0));
    }
    else
    {
        var_fbfa9 = BlockLightColor.xyz;
    }
    highp vec3 var_8f0e5 = var_fbfa9 * vec3(0.16666667163372039794921875);
    highp vec4 var_f46ce = vec4(var_8f0e5, 0.0039215688593685626983642578125);
    highp vec2 var_8a7dd = max(var_f46ce.xy, var_f46ce.zw);
    highp float var_a7109 = ceil(clamp(max(var_8a7dd.x, var_8a7dd.y), 0.0, 1.0) * 255.0) * 0.0039215688593685626983642578125;
    uvec4 var_63c1c = uvec4(clamp(vec4(var_8f0e5 / vec3(var_a7109), var_a7109), vec4(0.0), vec4(1.0)) * 255.0);
    uvec2 var_768db = var_63c1c.xy;
    uvec2 var_f7a74 = uvec2(var_768db.x & 255u, var_768db.y & 255u);
    uvec2 var_cc1c7 = var_63c1c.zw;
    uvec2 var_8bc3e = uvec2(var_cc1c7.x & 255u, var_cc1c7.y & 255u);
    uvec2 var_92e39 = uvec2((var_f7a74.x << 8u) | var_f7a74.y, (var_8bc3e.x << 8u) | var_8bc3e.y);
    uvec2 var_cfc6a = uvec2(uint(clamp(var_be4a2, 0.0, 1.0) * 255.0) & 255u, uint(clamp(var_755f6, 0.0, 1.0) * 255.0) & 255u);
    bgfx_FragData0 = uvec4((var_cfc6a.x << 8u) | var_cfc6a.y, var_92e39.x, var_92e39.y, uint(clamp(TileLightIntensity.y, 0.0, 1.0) * 255.0));
    bgfx_FragData1 = var_6bfdc;
    bgfx_FragData2 = vec4(var_532c2, var_603d8.xy - var_d0ebc.xy);
}
