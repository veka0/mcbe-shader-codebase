#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_PASS (not used)
* - GEOMETRY_PREPASS_PASS (not used)
* - GEOMETRY_PREPASS_ALPHA_TEST_PASS (not used)
*
* Dithering:
* - DITHERING__OFF
* - DITHERING__ON
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* RenderAsBillboards:
* - RENDER_AS_BILLBOARDS__OFF (not used)
*
* Seasons:
* - SEASONS__OFF (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_LightMapTexture;
* - uniform lowp sampler2D s_MatTexture;
* - layout(binding = 3, std430) buffer s_PBRDataBuffer { PBRTextureData s_PBRData[]; };
* - uniform lowp sampler2D s_SeasonsTexture;
* - layout(binding = 4, std430) buffer s_TextureShiftBufferDataBuffer { TextureShiftBuffer s_TextureShiftBufferData[]; };
*
* Uniforms:
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
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

struct TextureShiftBuffer {
    highp float preUV0;
    highp float preUV1;
    highp float postUV0;
    highp float postUV1;
    int packedPBRId;
    highp float globalAlpha;
    highp float localShiftLength;
};

#ifdef DITHERING__ON
float var_7ed9a;
#endif
layout(binding = 3, std430) buffer s_PBRData { PBRTextureData PBRData[]; } var_81887;
layout(binding = 4, std430) buffer s_TextureShiftBufferData { TextureShiftBuffer TextureShiftBufferData[]; } var_8ebd4;
uniform highp mat4 u_prevViewProj;
#ifdef DITHERING__ON
uniform highp mat4 u_view;
#endif
uniform highp mat4 u_viewProj;
uniform highp sampler2D s_MatTexture;
#ifdef DITHERING__ON
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
uniform highp vec4 ViewPositionAndTime;
#endif
uniform highp vec4 u_prevWorldPosOffset;
in highp vec3 v_bitangent;
#ifdef DITHERING__ON
in highp vec4 v_clipPosition;
#endif
in highp vec4 v_color0;
in highp vec2 v_ditheringAndMaskTinting;
in highp vec2 v_lightmapUV;
in highp vec3 v_normal;
in highp vec3 v_tangent;
in highp vec2 v_texcoord0;
flat in highp vec2 v_textureShift;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragData0;
layout(location = 1) out highp vec4 bgfx_FragData1;
layout(location = 2) out highp vec4 bgfx_FragData2;
void func_99506(inout int arg_3c414, inout highp float arg_6a625, inout highp float arg_9eee0, inout highp float arg_a50e1, inout highp float arg_d2a5b, inout highp vec3 arg_51e76, inout highp vec2 arg_0f096) {
    if (arg_3c414 == 65535)
    {
        arg_6a625 = 0.0;
        arg_9eee0 = 1.0;
        arg_a50e1 = 0.0;
        arg_d2a5b = 0.0;
        arg_51e76 = vec3(0.0, 1.0, 0.0);
        return;
    }
    highp vec2 loc_0a83e = vec2(var_81887.PBRData[arg_3c414].colourToNormalUvScale0, var_81887.PBRData[arg_3c414].colourToNormalUvScale1);
    highp vec2 loc_1e303 = vec2(var_81887.PBRData[arg_3c414].colourToNormalUvBias0, var_81887.PBRData[arg_3c414].colourToNormalUvBias1);
    highp vec3 loc_bb5f8;
    if ((var_81887.PBRData[arg_3c414].flags & 4) == 4)
    {
        loc_bb5f8 = (texture(s_MatTexture, (arg_0f096 * loc_0a83e) + loc_1e303).xyz * 2.0) - vec3(1.0);
    }
    else
    {
        highp vec3 loc_9252d;
        if ((var_81887.PBRData[arg_3c414].flags & 8) == 8)
        {
            highp vec2 loc_59472 = (arg_0f096 * loc_0a83e) + loc_1e303;
            highp vec3 loc_2ae5f = vec3(0.0, 0.0, 1.0);
            highp float loc_30a21 = clamp((min(var_81887.PBRData[arg_3c414].maxMipNormal - var_81887.PBRData[arg_3c414].maxMipColour, var_81887.PBRData[arg_3c414].maxMipNormal) * (-1.0)) + 2.0, 0.0, 1.0);
            if (loc_30a21 > 0.0)
            {
                highp vec2 loc_f388f = loc_59472;
                highp vec2 loc_a836e = loc_f388f * vec2(textureSize(s_MatTexture, 0));
                highp vec2 loc_f7221 = fract(loc_a836e);
                if (abs(loc_f7221.x - 0.5) < 0.0625)
                {
                    loc_59472.x += ((loc_f7221.x > 0.5) ? 3.814697265625e-06 : (-3.814697265625e-06));
                }
                if (abs(loc_f7221.y - 0.5) < 0.0625)
                {
                    loc_59472.y += ((loc_f7221.y > 0.5) ? 3.814697265625e-06 : (-3.814697265625e-06));
                }
                highp vec4 loc_224f0 = textureGather(s_MatTexture, loc_59472);
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
                highp vec2 loc_8557e = loc_1cc05.xy * loc_30a21;
                loc_2ae5f = vec3(loc_8557e.x, loc_8557e.y, loc_1cc05.z);
            }
            loc_9252d = loc_2ae5f;
        }
        else
        {
            loc_9252d = vec3(0.0, 0.0, 1.0);
        }
        loc_bb5f8 = loc_9252d;
    }
    highp float loc_5030f;
    highp float loc_bd422;
    highp float loc_fe060;
    highp float loc_70718;
    if ((var_81887.PBRData[arg_3c414].flags & 1) == 1)
    {
        highp vec4 loc_d60eb = texture(s_MatTexture, (arg_0f096 * vec2(var_81887.PBRData[arg_3c414].colourToMaterialUvScale0, var_81887.PBRData[arg_3c414].colourToMaterialUvScale1)) + vec2(var_81887.PBRData[arg_3c414].colourToMaterialUvBias0, var_81887.PBRData[arg_3c414].colourToMaterialUvBias1));
        highp float loc_0f962;
        if ((var_81887.PBRData[arg_3c414].flags & 2) == 2)
        {
            loc_0f962 = loc_d60eb.w;
        }
        else
        {
            loc_0f962 = var_81887.PBRData[arg_3c414].uniformSubsurface;
        }
        loc_70718 = loc_0f962;
        loc_fe060 = loc_d60eb.y;
        loc_bd422 = loc_d60eb.x;
        loc_5030f = loc_d60eb.z;
    }
    else
    {
        loc_70718 = var_81887.PBRData[arg_3c414].uniformSubsurface;
        loc_fe060 = var_81887.PBRData[arg_3c414].uniformEmissive;
        loc_bd422 = var_81887.PBRData[arg_3c414].uniformMetalness;
        loc_5030f = var_81887.PBRData[arg_3c414].uniformRoughness;
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
    arg_6a625 = loc_bd422;
    arg_9eee0 = loc_5030f;
    arg_a50e1 = loc_fe060;
    arg_d2a5b = loc_70718;
    arg_51e76 = transpose(transpose(mat3(normalize(v_tangent), normalize(v_bitangent), normalize(loc_93b23)))) * loc_bb5f8;
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
    highp vec4 var_3f821 = v_color0;
    highp vec2 var_bb45f = v_ditheringAndMaskTinting;
    highp vec2 var_19cca = v_textureShift;
    int var_218bc = int(var_19cca.y * 65535.0);
    highp float var_f7de0 = clamp((var_8ebd4.TextureShiftBufferData[var_218bc].globalAlpha - ((1.0 - var_8ebd4.TextureShiftBufferData[var_218bc].localShiftLength) * var_19cca.x)) / var_8ebd4.TextureShiftBufferData[var_218bc].localShiftLength, 0.0, 1.0);
    highp vec2 var_f486c = v_texcoord0;
    highp vec4 var_45704 = texture(s_MatTexture, vec2(var_f486c.x + var_8ebd4.TextureShiftBufferData[var_218bc].preUV0, var_f486c.y + var_8ebd4.TextureShiftBufferData[var_218bc].preUV1));
    highp vec4 var_457f9 = texture(s_MatTexture, vec2(var_f486c.x + var_8ebd4.TextureShiftBufferData[var_218bc].postUV0, var_f486c.y + var_8ebd4.TextureShiftBufferData[var_218bc].postUV1));
    highp vec4 var_5417d = mix(var_45704, var_457f9, vec4(var_f7de0));
    highp vec2 var_2f8a8 = v_texcoord0;
    int var_39955;
    if (var_f7de0 < 0.5)
    {
        var_2f8a8 = vec2(var_2f8a8.x + var_8ebd4.TextureShiftBufferData[var_218bc].preUV0, var_2f8a8.y + var_8ebd4.TextureShiftBufferData[var_218bc].preUV1);
        var_39955 = (var_8ebd4.TextureShiftBufferData[var_218bc].packedPBRId >> 16) & 65535;
    }
    else
    {
        var_2f8a8 = vec2(var_2f8a8.x + var_8ebd4.TextureShiftBufferData[var_218bc].postUV0, var_2f8a8.y + var_8ebd4.TextureShiftBufferData[var_218bc].postUV1);
        var_39955 = var_8ebd4.TextureShiftBufferData[var_218bc].packedPBRId & 65535;
    }
    var_bb45f = v_ditheringAndMaskTinting;
    highp vec4 var_b902c = var_5417d;
#ifdef DITHERING__OFF
    if (false || (var_b902c.w < 0.5))
#endif
#ifdef DITHERING__ON
    highp vec2 var_4bd41 = DitherParams2[2].xy;
    bool var_dcf5d;
    if (var_bb45f.x > 0.5)
#endif
    {
#ifdef DITHERING__ON
        highp mat4 var_6eb6a = u_view;
        highp vec4 var_bb748 = v_clipPosition;
        highp vec2 var_b2538 = floor(((((v_clipPosition.xyz / vec3(var_bb748.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[2].z)) * DitherParams2[2].z;
        highp vec2 var_28929 = floor(var_b2538 * 0.25);
        highp vec2 var_4cce7 = floor(var_b2538 * 0.5);
        highp vec2 var_2e83b = floor(var_b2538);
        var_dcf5d = smoothstep(var_4bd41.x, var_4bd41.y, dot(-normalize(vec4(var_6eb6a[0].z, var_6eb6a[1].z, var_6eb6a[2].z, var_7ed9a).xyz), v_worldPos - ViewPositionAndTime.xyz)) <= (((((((fract((var_28929.x * 0.5) + ((var_28929.y * var_28929.y) * 0.75)) * 0.25) + fract((var_4cce7.x * 0.5) + ((var_4cce7.y * var_4cce7.y) * 0.75))) * 0.25) + fract((var_2e83b.x * 0.5) + ((var_2e83b.y * var_2e83b.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        var_dcf5d = false;
    }
    if (var_dcf5d || (var_b902c.w < 0.5))
    {
#endif
        discard;
    }
    highp vec4 var_3eefe = var_5417d;
    if (var_bb45f.y != 0.0)
    {
        highp vec3 var_5e4d7 = mix(var_3eefe.xyz, var_3eefe.xyz * v_color0.xyz, vec3(var_3eefe.w)).xyz * var_3f821.w;
        var_3eefe = vec4(var_5e4d7.x, var_5e4d7.y, var_5e4d7.z, var_3eefe.w);
        var_3eefe.w = 1.0;
    }
    else
    {
        highp vec3 var_55928 = var_3eefe.xyz * v_color0.xyz;
        var_3eefe = vec4(var_55928.x, var_55928.y, var_55928.z, var_3eefe.w);
        var_3eefe.w *= var_3f821.w;
    }
    highp vec3 var_b9e8b;
    highp float var_d1699;
    highp float var_731f1;
    highp float var_e012f;
    highp float var_fcacf;
    func_99506(var_39955, var_fcacf, var_e012f, var_731f1, var_d1699, var_b9e8b, var_2f8a8);
    highp vec4 var_08b04 = vec4(var_3eefe.xyz, var_3eefe.w);
    highp vec2 var_f1ecf = v_lightmapUV;
    highp vec4 var_e74f1 = vec4(var_08b04.x, var_08b04.y, var_08b04.z, var_08b04.w);
    highp float var_7aa46;
    func_fb7ab(var_fcacf, var_d1699, var_7aa46);
    var_e74f1.w = var_7aa46;
    highp vec3 var_089df = normalize(var_b9e8b);
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
    highp vec4 var_eaa92 = u_prevViewProj * vec4(v_worldPos - u_prevWorldPosOffset.xyz, 1.0);
    highp vec4 var_96bda = var_eaa92;
    highp float var_9ef48 = var_96bda.w;
    highp vec4 var_c94a9 = ((var_eaa92 / vec4(var_9ef48)) * 0.5) + vec4(0.5);
    var_96bda = var_c94a9;
    bgfx_FragData0 = var_e74f1;
    bgfx_FragData1 = vec4(var_72494, var_efb33.xy - var_c94a9.xy);
    bgfx_FragData2 = vec4(var_731f1, var_f1ecf.x, var_f1ecf.y, var_e012f);
}
