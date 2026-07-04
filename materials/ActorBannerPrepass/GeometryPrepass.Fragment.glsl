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
uniform highp vec4 BannerBasePBRTextureData[4];
uniform highp vec4 HudOpacity;
uniform highp vec4 TileLightIntensity;
uniform highp vec4 u_prevWorldPosOffset;
in highp vec3 v_bitangent;
#ifdef TINTING__ENABLED
in highp vec4 v_color0;
#endif
in highp vec3 v_normal;
in highp vec3 v_prevWorldPos;
in highp vec3 v_tangent;
centroid in highp vec4 v_texcoords;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData[gl_MaxDrawBuffers];
void func_65dae(inout highp vec3 arg_14c07, inout highp float arg_3d8de) {
    if (arg_14c07.x <= 0.040449999272823333740234375)
    {
        arg_3d8de = arg_14c07.x * 0.077399380505084991455078125;
        return;
    }
    else
    {
        arg_3d8de = pow((arg_14c07.x + 0.054999999701976776123046875) * 0.947867333889007568359375, 2.400000095367431640625);
        return;
    }
}
void func_78d48(inout highp vec3 arg_ad8f4, inout highp float arg_d93f4) {
    if (arg_ad8f4.y <= 0.040449999272823333740234375)
    {
        arg_d93f4 = arg_ad8f4.y * 0.077399380505084991455078125;
        return;
    }
    else
    {
        arg_d93f4 = pow((arg_ad8f4.y + 0.054999999701976776123046875) * 0.947867333889007568359375, 2.400000095367431640625);
        return;
    }
}
void func_50a1f(inout highp vec3 arg_4e442, inout highp float arg_3aa09) {
    if (arg_4e442.z <= 0.040449999272823333740234375)
    {
        arg_3aa09 = arg_4e442.z * 0.077399380505084991455078125;
        return;
    }
    else
    {
        arg_3aa09 = pow((arg_4e442.z + 0.054999999701976776123046875) * 0.947867333889007568359375, 2.400000095367431640625);
        return;
    }
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
#ifdef TINTING__ENABLED
    highp vec4 var_a3564 = v_color0;
#endif
    int var_95bcd = int(BannerBasePBRTextureData[2].x);
    highp vec2 var_2b923 = vec2(BannerBasePBRTextureData[1].x, BannerBasePBRTextureData[1].y);
    highp vec2 var_b7839 = vec2(BannerBasePBRTextureData[1].z, BannerBasePBRTextureData[1].w);
    highp vec3 var_7291d;
    if ((var_95bcd & 4) == 4)
    {
        var_7291d = (texture(s_MatTexture, (v_texcoords.zw * var_2b923) + var_b7839).xyz * 2.0) - vec3(1.0);
    }
    else
    {
        highp vec3 var_9252d;
        if ((var_95bcd & 8) == 8)
        {
            highp vec2 var_9491c = (v_texcoords.zw * var_2b923) + var_b7839;
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
            var_9252d = var_2ae5f;
        }
        else
        {
            var_9252d = vec3(0.0, 0.0, 1.0);
        }
        var_7291d = var_9252d;
    }
    highp float var_777db;
    highp float var_e87f4;
    highp float var_237cc;
    highp float var_e9ad4;
    if ((var_95bcd & 1) == 1)
    {
        highp vec4 var_fb54f = texture(s_MatTexture, (v_texcoords.zw * vec2(BannerBasePBRTextureData[0].x, BannerBasePBRTextureData[0].y)) + vec2(BannerBasePBRTextureData[0].z, BannerBasePBRTextureData[0].w));
        highp float var_0c75b;
        if ((var_95bcd & 2) == 2)
        {
            var_0c75b = var_fb54f.w;
        }
        else
        {
            var_0c75b = BannerBasePBRTextureData[3].x;
        }
        var_e9ad4 = var_0c75b;
        var_237cc = var_fb54f.y;
        var_e87f4 = var_fb54f.x;
        var_777db = var_fb54f.z;
    }
    else
    {
        var_e9ad4 = BannerBasePBRTextureData[3].x;
        var_237cc = BannerBasePBRTextureData[2].z;
        var_e87f4 = BannerBasePBRTextureData[2].w;
        var_777db = BannerBasePBRTextureData[2].y;
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
#ifdef TINTING__ENABLED
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
    highp vec3 var_574b1 = var_e9521.xyz;
#endif
#ifdef TINTING__DISABLED
    highp vec3 var_574b1 = var_1e2a8.xyz;
#endif
    highp float var_33fb0;
    func_65dae(var_574b1, var_33fb0);
    highp float var_1eaae;
    func_78d48(var_574b1, var_1eaae);
    highp float var_d75e7;
    func_50a1f(var_574b1, var_d75e7);
    highp vec3 var_a0775 = vec3(var_33fb0, var_1eaae, var_d75e7);
    highp vec4 var_edaf7 = vec4(var_a0775.x, var_a0775.y, var_a0775.z, var_1e2a8.w);
    var_edaf7.w *= HudOpacity.x;
    highp vec4 var_1d587 = var_edaf7;
    highp vec4 var_08b04 = vec4(var_edaf7.xyz, var_1d587.w);
    highp vec4 var_6de71 = vec4(var_08b04.x, var_08b04.y, var_08b04.z, var_08b04.w);
    highp float var_7aa46;
    func_fb7ab(var_e87f4, var_e9ad4, var_7aa46);
    var_6de71.w = var_7aa46;
    highp vec3 var_9c9d2 = normalize(transpose(transpose(mat3(normalize(v_tangent), normalize(v_bitangent), normalize(var_276aa)))) * var_7291d);
    highp vec3 var_cd914 = var_9c9d2;
    highp vec2 var_645ff = var_9c9d2.xy * (1.0 / ((abs(var_cd914.x) + abs(var_cd914.y)) + abs(var_cd914.z)));
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
    bgfx_FragData[2] = vec4(var_237cc, TileLightIntensity.x, TileLightIntensity.y, var_777db);
}
