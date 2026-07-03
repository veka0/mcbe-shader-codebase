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
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* RenderAsBillboards:
* - RENDER_AS_BILLBOARDS__OFF (not used)
* - RENDER_AS_BILLBOARDS__ON (not used)
*
* Seasons:
* - SEASONS__OFF
* - SEASONS__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_LightMapTexture;
* - uniform lowp sampler2D s_MatTexture;
* - layout(binding = 2, std430) buffer s_PBRDataBuffer { PBRTextureData s_PBRData[]; };
* - uniform lowp sampler2D s_SeasonsTexture;
*
* Uniforms:
* - uniform vec4 AmbientOcclusionParameters;
* - uniform vec4 GlobalRoughness;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MaterialID;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 ViewPositionAndTime;
*/

precision mediump float;
precision highp int;
struct PBRTextureData {
    highp float colourToMaterialUvScale0;
    highp float colourToMaterialUvScale1;
    highp float colourToMaterialUvBias0;
    highp float colourToMaterialUvBias1;
    highp float colourToNormalUvScale0;
    highp float colourToNormalUvScale1;
    highp float colourToNormalUvBias0;
    highp float colourToNormalUvBias1;
    int flags;
    highp float uniformRoughness;
    highp float uniformEmissive;
    highp float uniformMetalness;
    highp float uniformSubsurface;
    highp float maxMipColour;
    highp float maxMipMer;
    highp float maxMipNormal;
};

layout(binding = 2, std430) buffer s_PBRData { PBRTextureData PBRData[]; } var_147c9;
uniform highp mat4 u_prevViewProj;
uniform highp mat4 u_viewProj;
uniform highp sampler2D s_MatTexture;
#ifdef SEASONS__OFF
uniform highp vec4 AmbientOcclusionParameters;
#endif
#ifdef SEASONS__ON
uniform highp sampler2D s_SeasonsTexture;
#endif
uniform highp vec4 u_prevWorldPosOffset;
in highp vec3 v_bitangent;
in highp vec4 v_color0;
in highp vec2 v_lightmapUV;
in highp vec3 v_normal;
flat in int v_pbrTextureId;
in highp vec3 v_tangent;
in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData[gl_MaxDrawBuffers];
void func_a72a6(inout highp float arg_6a625, inout highp float arg_9eee0, inout highp float arg_a50e1, inout highp float arg_d2a5b, inout highp vec3 arg_51e76) {
    if (v_pbrTextureId == 65535)
    {
        arg_6a625 = 0.0;
        arg_9eee0 = 1.0;
        arg_a50e1 = 0.0;
        arg_d2a5b = 0.0;
        arg_51e76 = vec3(0.0, 1.0, 0.0);
        return;
    }
    highp vec2 loc_59055 = vec2(var_147c9.PBRData[v_pbrTextureId].colourToNormalUvScale0, var_147c9.PBRData[v_pbrTextureId].colourToNormalUvScale1);
    highp vec2 loc_39ca3 = vec2(var_147c9.PBRData[v_pbrTextureId].colourToNormalUvBias0, var_147c9.PBRData[v_pbrTextureId].colourToNormalUvBias1);
    highp vec3 loc_b4ff6;
    if ((var_147c9.PBRData[v_pbrTextureId].flags & 4) == 4)
    {
        loc_b4ff6 = (texture(s_MatTexture, (v_texcoord0 * loc_59055) + loc_39ca3).xyz * 2.0) - vec3(1.0);
    }
    else
    {
        highp vec3 loc_9252d;
        if ((var_147c9.PBRData[v_pbrTextureId].flags & 8) == 8)
        {
            highp vec2 loc_218fe = (v_texcoord0 * loc_59055) + loc_39ca3;
            highp vec3 loc_2ae5f = vec3(0.0, 0.0, 1.0);
            highp float loc_b88fd = clamp((min(var_147c9.PBRData[v_pbrTextureId].maxMipNormal - var_147c9.PBRData[v_pbrTextureId].maxMipColour, var_147c9.PBRData[v_pbrTextureId].maxMipNormal) * (-1.0)) + 2.0, 0.0, 1.0);
            if (loc_b88fd > 0.0)
            {
                highp vec2 loc_f388f = loc_218fe;
                highp vec2 loc_a836e = loc_f388f * vec2(textureSize(s_MatTexture, 0));
                highp vec2 loc_f7221 = fract(loc_a836e);
                if (abs(loc_f7221.x - 0.5) < 0.0625)
                {
                    loc_218fe.x += ((loc_f7221.x > 0.5) ? 3.814697265625e-06 : (-3.814697265625e-06));
                }
                if (abs(loc_f7221.y - 0.5) < 0.0625)
                {
                    loc_218fe.y += ((loc_f7221.y > 0.5) ? 3.814697265625e-06 : (-3.814697265625e-06));
                }
                highp vec4 loc_224f0 = textureGather(s_MatTexture, loc_218fe);
                highp vec2 loc_7487c = fract(loc_a836e + vec2(0.5));
                highp vec2 loc_ed03c;
                if (loc_7487c.y > 0.5)
                {
                    loc_ed03c = loc_224f0.xy;
                }
                else
                {
                    loc_ed03c = loc_224f0.wz;
                }
                highp vec2 loc_cf71a = loc_ed03c;
                ivec2 loc_31dc2 = ivec2(clamp(vec2(loc_7487c.x - 0.083333335816860198974609375, loc_7487c.x + 0.083333335816860198974609375) * 2.0, vec2(0.0), vec2(1.0)));
                loc_2ae5f.x = loc_cf71a[loc_31dc2.x] - loc_cf71a[loc_31dc2.y];
                highp vec2 loc_a6d82;
                if (loc_7487c.x > 0.5)
                {
                    loc_a6d82 = loc_224f0.zy;
                }
                else
                {
                    loc_a6d82 = loc_224f0.wx;
                }
                loc_cf71a = loc_a6d82;
                loc_31dc2 = ivec2(clamp(vec2(loc_7487c.y - 0.083333335816860198974609375, loc_7487c.y + 0.083333335816860198974609375) * 2.0, vec2(0.0), vec2(1.0)));
                loc_2ae5f.y = loc_cf71a[loc_31dc2.x] - loc_cf71a[loc_31dc2.y];
                loc_2ae5f.z = 0.25;
                highp vec3 loc_1cc05 = normalize(loc_2ae5f);
                highp vec2 loc_8557e = loc_1cc05.xy * loc_b88fd;
                loc_2ae5f = vec3(loc_8557e.x, loc_8557e.y, loc_1cc05.z);
            }
            loc_9252d = loc_2ae5f;
        }
        else
        {
            loc_9252d = vec3(0.0, 0.0, 1.0);
        }
        loc_b4ff6 = loc_9252d;
    }
    highp float loc_659d6;
    highp float loc_73c14;
    highp float loc_00c14;
    highp float loc_d7d8a;
    if ((var_147c9.PBRData[v_pbrTextureId].flags & 1) == 1)
    {
        highp vec4 loc_300fb = texture(s_MatTexture, (v_texcoord0 * vec2(var_147c9.PBRData[v_pbrTextureId].colourToMaterialUvScale0, var_147c9.PBRData[v_pbrTextureId].colourToMaterialUvScale1)) + vec2(var_147c9.PBRData[v_pbrTextureId].colourToMaterialUvBias0, var_147c9.PBRData[v_pbrTextureId].colourToMaterialUvBias1));
        highp float loc_c4db1;
        if ((var_147c9.PBRData[v_pbrTextureId].flags & 2) == 2)
        {
            loc_c4db1 = loc_300fb.w;
        }
        else
        {
            loc_c4db1 = var_147c9.PBRData[v_pbrTextureId].uniformSubsurface;
        }
        loc_d7d8a = loc_c4db1;
        loc_00c14 = loc_300fb.y;
        loc_73c14 = loc_300fb.x;
        loc_659d6 = loc_300fb.z;
    }
    else
    {
        loc_d7d8a = var_147c9.PBRData[v_pbrTextureId].uniformSubsurface;
        loc_00c14 = var_147c9.PBRData[v_pbrTextureId].uniformEmissive;
        loc_73c14 = var_147c9.PBRData[v_pbrTextureId].uniformMetalness;
        loc_659d6 = var_147c9.PBRData[v_pbrTextureId].uniformRoughness;
    }
    highp vec3 loc_93b23;
    if (int(gl_FrontFacing) != 0)
    {
        loc_93b23 = -v_normal;
    }
    else
    {
        loc_93b23 = v_normal;
    }
    arg_6a625 = loc_73c14;
    arg_9eee0 = loc_659d6;
    arg_a50e1 = loc_00c14;
    arg_d2a5b = loc_d7d8a;
    arg_51e76 = transpose(transpose(mat3(normalize(v_tangent), normalize(v_bitangent), normalize(loc_93b23)))) * loc_b4ff6;
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
    highp vec4 var_f0bdd = v_color0;
    highp vec4 var_78efb = texture(s_MatTexture, v_texcoord0);
#ifdef SEASONS__OFF
    highp vec4 var_f910b = var_78efb;
    highp vec3 var_c5724 = (var_f910b.xyz * v_color0.xyz).xyz * ((AmbientOcclusionParameters.x + (AmbientOcclusionParameters.y * pow(var_f0bdd.w, AmbientOcclusionParameters.w))) * AmbientOcclusionParameters.z);
    var_78efb = vec4(var_c5724.x, var_c5724.y, var_c5724.z, var_f910b.w);
#endif
#ifdef SEASONS__ON
    highp vec3 var_2455e = v_color0.xyz;
    highp vec3 var_2b07f = (var_78efb.xyz * mix(vec3(1.0), texture(s_SeasonsTexture, v_color0.xy).xyz * 2.0, vec3(var_2455e.z))).xyz * vec3(var_f0bdd.w);
    highp vec4 var_2648f = vec4(var_2b07f.x, var_2b07f.y, var_2b07f.z, var_78efb.w);
    var_2648f.w = 1.0;
    var_78efb = var_2648f;
#endif
    highp vec3 var_d2ce2;
    highp float var_bd3b6;
    highp float var_8ed44;
    highp float var_0e0cd;
    highp float var_5431f;
    func_a72a6(var_5431f, var_0e0cd, var_8ed44, var_bd3b6, var_d2ce2);
#ifdef SEASONS__OFF
    highp vec4 var_b71d9 = vec4(var_c5724, var_78efb.w);
#endif
#ifdef SEASONS__ON
    highp vec4 var_b71d9 = vec4(var_2648f.xyz, var_78efb.w);
#endif
    highp vec2 var_ea830 = v_lightmapUV;
    highp vec4 var_6de71 = vec4(var_b71d9.x, var_b71d9.y, var_b71d9.z, var_b71d9.w);
    highp float var_7aa46;
    func_fb7ab(var_5431f, var_bd3b6, var_7aa46);
    var_6de71.w = var_7aa46;
    highp vec3 var_089df = normalize(var_d2ce2);
    highp vec3 var_cd914 = var_089df;
    highp vec2 var_645ff = var_089df.xy * (1.0 / ((abs(var_cd914.x) + abs(var_cd914.y)) + abs(var_cd914.z)));
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
    highp vec4 var_eaa92 = u_prevViewProj * vec4(v_worldPos - u_prevWorldPosOffset.xyz, 1.0);
    highp vec4 var_96bda = var_eaa92;
    highp float var_9ef48 = var_96bda.w;
    highp vec4 var_82203 = ((var_eaa92 / vec4(var_9ef48)) * 0.5) + vec4(0.5);
    var_96bda = var_82203;
    highp vec2 var_ec5a5 = var_7ed87.xy - var_82203.xy;
    bgfx_FragData[0] = var_6de71;
    bgfx_FragData[1] = vec4(var_5a694.x, var_5a694.y, var_ec5a5.x, var_ec5a5.y);
    bgfx_FragData[2] = vec4(var_8ed44, var_ea830.x, var_ea830.y, var_0e0cd);
}
