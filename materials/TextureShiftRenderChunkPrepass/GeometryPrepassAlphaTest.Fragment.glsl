#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEPTH_ONLY_ALPHA_TEST_PASS (not used)
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
    highp float noiseSpread;
};

#ifdef DITHERING__ON
float var_7ed9a;
#endif
layout(binding = 3, std430) buffer s_PBRData { PBRTextureData PBRData[]; } var_6f249;
layout(binding = 4, std430) buffer s_TextureShiftBufferData { TextureShiftBuffer TextureShiftBufferData[]; } var_90f76;
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
in highp vec3 v_lightColor;
in highp vec2 v_lightmapUV;
in highp vec3 v_normal;
in highp vec3 v_tangent;
in highp vec2 v_texcoord0;
flat in highp vec2 v_textureShift;
in highp vec3 v_worldPos;
layout(location = 0) out uvec4 bgfx_FragData0;
layout(location = 1) out highp vec4 bgfx_FragData1;
layout(location = 2) out highp vec4 bgfx_FragData2;
void func_f1932(inout highp vec2 arg_c2b61, inout int arg_651a0, inout highp float arg_0da03) {
    highp float loc_47c38 = 1.0 - (arg_c2b61.x * var_90f76.TextureShiftBufferData[arg_651a0].noiseSpread);
    if (var_90f76.TextureShiftBufferData[arg_651a0].localShiftLength == 0.0)
    {
        arg_0da03 = step(loc_47c38, var_90f76.TextureShiftBufferData[arg_651a0].globalAlpha);
        return;
    }
    else
    {
        arg_0da03 = 1.0 - clamp((loc_47c38 - var_90f76.TextureShiftBufferData[arg_651a0].globalAlpha) / var_90f76.TextureShiftBufferData[arg_651a0].localShiftLength, 0.0, 1.0);
        return;
    }
}
void func_b5a96(inout int arg_7561c, inout highp float arg_6a625, inout highp float arg_9eee0, inout highp float arg_a50e1, inout highp float arg_d2a5b, inout highp vec3 arg_51e76, inout highp vec2 arg_9466e) {
    if (arg_7561c == 65535)
    {
        arg_6a625 = 0.0;
        arg_9eee0 = 1.0;
        arg_a50e1 = 0.0;
        arg_d2a5b = 0.0;
        arg_51e76 = vec3(0.0, 1.0, 0.0);
        return;
    }
    highp vec2 loc_d939d = vec2(var_6f249.PBRData[arg_7561c].colourToNormalUvScale0, var_6f249.PBRData[arg_7561c].colourToNormalUvScale1);
    highp vec2 loc_06486 = vec2(var_6f249.PBRData[arg_7561c].colourToNormalUvBias0, var_6f249.PBRData[arg_7561c].colourToNormalUvBias1);
    highp vec3 loc_bb5f8;
    if ((var_6f249.PBRData[arg_7561c].flags & 4) == 4)
    {
        loc_bb5f8 = (texture(s_MatTexture, (arg_9466e * loc_d939d) + loc_06486).xyz * 2.0) - vec3(1.0);
    }
    else
    {
        highp vec3 loc_a4d0b;
        if ((var_6f249.PBRData[arg_7561c].flags & 8) == 8)
        {
            highp vec2 loc_59472 = (arg_9466e * loc_d939d) + loc_06486;
            highp vec3 loc_2ae5f = vec3(0.0, 0.0, 1.0);
            highp float loc_30a21 = clamp((min(var_6f249.PBRData[arg_7561c].maxMipNormal - var_6f249.PBRData[arg_7561c].maxMipColour, var_6f249.PBRData[arg_7561c].maxMipNormal) * (-1.0)) + 2.0, 0.0, 1.0);
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
            loc_a4d0b = loc_2ae5f;
        }
        else
        {
            highp vec3 loc_8d6b3;
            if ((var_6f249.PBRData[arg_7561c].flags & 16) == 16)
            {
                highp vec2 loc_6e94b = (arg_9466e * loc_d939d) + loc_06486;
                highp float loc_65ac1 = min(var_6f249.PBRData[arg_7561c].maxMipNormal - var_6f249.PBRData[arg_7561c].maxMipColour, var_6f249.PBRData[arg_7561c].maxMipNormal);
                highp vec4 loc_946d4 = textureLod(s_MatTexture, loc_6e94b, 0.0);
                highp vec4 loc_97cb6 = loc_946d4;
                bool loc_b06a0 = loc_97cb6.x == loc_97cb6.y;
                bool loc_5d1d0;
                if (loc_b06a0)
                {
                    loc_5d1d0 = loc_97cb6.y == loc_97cb6.z;
                }
                else
                {
                    loc_5d1d0 = loc_b06a0;
                }
                highp vec3 loc_049a7;
                if (loc_5d1d0)
                {
                    highp vec2 loc_eaa59 = loc_6e94b;
                    highp vec3 loc_8029f = vec3(0.0, 0.0, 1.0);
                    highp float loc_0725d = clamp((loc_65ac1 * (-1.0)) + 2.0, 0.0, 1.0);
                    if (loc_0725d > 0.0)
                    {
                        highp vec2 loc_7e76e = loc_eaa59;
                        highp vec2 loc_65dec = loc_7e76e * vec2(textureSize(s_MatTexture, 0));
                        highp vec2 loc_3af9d = fract(loc_65dec);
                        if (abs(loc_3af9d.x - 0.5) < 0.0625)
                        {
                            loc_eaa59.x += ((loc_3af9d.x > 0.5) ? 3.814697265625e-06 : (-3.814697265625e-06));
                        }
                        if (abs(loc_3af9d.y - 0.5) < 0.0625)
                        {
                            loc_eaa59.y += ((loc_3af9d.y > 0.5) ? 3.814697265625e-06 : (-3.814697265625e-06));
                        }
                        highp vec4 loc_e61ed = textureGather(s_MatTexture, loc_eaa59);
                        highp vec2 loc_99152 = fract(loc_65dec + vec2(0.5));
                        highp vec2 loc_9413e;
                        if (loc_99152.y > 0.5)
                        {
                            loc_9413e = loc_e61ed.xy;
                        }
                        else
                        {
                            loc_9413e = loc_e61ed.wz;
                        }
                        highp vec2 loc_1eb74 = loc_9413e;
                        ivec2 loc_653e7 = ivec2(clamp(vec2(loc_99152.x - 0.083333335816860198974609375, loc_99152.x + 0.083333335816860198974609375) * 2.0, vec2(0.0), vec2(1.0)));
                        loc_8029f.x = loc_1eb74[loc_653e7.x] - loc_1eb74[loc_653e7.y];
                        highp vec2 loc_11531;
                        if (loc_99152.x > 0.5)
                        {
                            loc_11531 = loc_e61ed.zy;
                        }
                        else
                        {
                            loc_11531 = loc_e61ed.wx;
                        }
                        loc_1eb74 = loc_11531;
                        loc_653e7 = ivec2(clamp(vec2(loc_99152.y - 0.083333335816860198974609375, loc_99152.y + 0.083333335816860198974609375) * 2.0, vec2(0.0), vec2(1.0)));
                        loc_8029f.y = loc_1eb74[loc_653e7.x] - loc_1eb74[loc_653e7.y];
                        loc_8029f.z = 0.25;
                        highp vec3 loc_37fe4 = normalize(loc_8029f);
                        highp vec2 loc_b37fc = loc_37fe4.xy * loc_0725d;
                        loc_8029f = vec3(loc_b37fc.x, loc_b37fc.y, loc_37fe4.z);
                    }
                    loc_049a7 = loc_8029f;
                }
                else
                {
                    highp vec4 loc_807fe = loc_946d4;
                    highp vec3 loc_a34be = vec3(0.0, 0.0, 1.0);
                    highp float loc_3e159 = clamp((loc_65ac1 * (-1.0)) + 2.0, 0.0, 1.0);
                    if (loc_3e159 > 0.0)
                    {
                        highp vec2 loc_6c8bb = fract(loc_6e94b * vec2(textureSize(s_MatTexture, 0)));
                        loc_a34be.x = (step(0.916666686534881591796875, loc_6c8bb.x) * ((loc_807fe.y * 2.0) - 1.0)) + (step(loc_6c8bb.x, 0.083333335816860198974609375) * (1.0 - (loc_807fe.w * 2.0)));
                        loc_a34be.y = (step(0.916666686534881591796875, loc_6c8bb.y) * ((loc_807fe.z * 2.0) - 1.0)) + (step(loc_6c8bb.y, 0.083333335816860198974609375) * (1.0 - (loc_807fe.x * 2.0)));
                        loc_a34be.x = step(0.004999999888241291046142578125, abs(loc_a34be.x)) * loc_a34be.x;
                        loc_a34be.y = step(0.004999999888241291046142578125, abs(loc_a34be.y)) * loc_a34be.y;
                        loc_a34be.z = 0.25;
                        highp vec3 loc_8c503 = normalize(loc_a34be);
                        highp vec2 loc_fafd7 = loc_8c503.xy * loc_3e159;
                        loc_a34be = vec3(loc_fafd7.x, loc_fafd7.y, loc_8c503.z);
                    }
                    loc_049a7 = loc_a34be;
                }
                loc_8d6b3 = loc_049a7;
            }
            else
            {
                loc_8d6b3 = vec3(0.0, 0.0, 1.0);
            }
            loc_a4d0b = loc_8d6b3;
        }
        loc_bb5f8 = loc_a4d0b;
    }
    highp float loc_5030f;
    highp float loc_bd422;
    highp float loc_fe060;
    highp float loc_70718;
    if ((var_6f249.PBRData[arg_7561c].flags & 1) == 1)
    {
        highp vec4 loc_d60eb = texture(s_MatTexture, (arg_9466e * vec2(var_6f249.PBRData[arg_7561c].colourToMaterialUvScale0, var_6f249.PBRData[arg_7561c].colourToMaterialUvScale1)) + vec2(var_6f249.PBRData[arg_7561c].colourToMaterialUvBias0, var_6f249.PBRData[arg_7561c].colourToMaterialUvBias1));
        highp float loc_0f962;
        if ((var_6f249.PBRData[arg_7561c].flags & 2) == 2)
        {
            loc_0f962 = loc_d60eb.w;
        }
        else
        {
            loc_0f962 = var_6f249.PBRData[arg_7561c].uniformSubsurface;
        }
        loc_70718 = loc_0f962;
        loc_fe060 = loc_d60eb.y;
        loc_bd422 = loc_d60eb.x;
        loc_5030f = loc_d60eb.z;
    }
    else
    {
        loc_70718 = var_6f249.PBRData[arg_7561c].uniformSubsurface;
        loc_fe060 = var_6f249.PBRData[arg_7561c].uniformEmissive;
        loc_bd422 = var_6f249.PBRData[arg_7561c].uniformMetalness;
        loc_5030f = var_6f249.PBRData[arg_7561c].uniformRoughness;
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
    highp vec2 var_1614a = v_textureShift;
    int var_34ad7 = int(var_1614a.y * 65535.0);
    highp float var_da8c4;
    func_f1932(var_1614a, var_34ad7, var_da8c4);
    highp vec2 var_f486c = v_texcoord0;
    highp vec4 var_4b671 = texture(s_MatTexture, vec2(var_f486c.x + var_90f76.TextureShiftBufferData[var_34ad7].preUV0, var_f486c.y + var_90f76.TextureShiftBufferData[var_34ad7].preUV1));
    highp vec4 var_2e873 = texture(s_MatTexture, vec2(var_f486c.x + var_90f76.TextureShiftBufferData[var_34ad7].postUV0, var_f486c.y + var_90f76.TextureShiftBufferData[var_34ad7].postUV1));
    highp vec4 var_da3c1 = var_4b671;
    highp vec4 var_e65e5 = var_2e873;
    highp float var_7dfb9;
    if (var_da8c4 > 0.5)
    {
        var_7dfb9 = var_e65e5.w;
    }
    else
    {
        var_7dfb9 = var_da3c1.w;
    }
    highp vec4 var_68814 = vec4(mix(var_4b671.xyz, var_2e873.xyz, vec3(var_da8c4)), var_7dfb9);
    highp vec2 var_2f8a8 = v_texcoord0;
    int var_39955;
    if (var_da8c4 < 0.5)
    {
        var_2f8a8 = vec2(var_2f8a8.x + var_90f76.TextureShiftBufferData[var_34ad7].preUV0, var_2f8a8.y + var_90f76.TextureShiftBufferData[var_34ad7].preUV1);
        var_39955 = (var_90f76.TextureShiftBufferData[var_34ad7].packedPBRId >> 16) & 65535;
    }
    else
    {
        var_2f8a8 = vec2(var_2f8a8.x + var_90f76.TextureShiftBufferData[var_34ad7].postUV0, var_2f8a8.y + var_90f76.TextureShiftBufferData[var_34ad7].postUV1);
        var_39955 = var_90f76.TextureShiftBufferData[var_34ad7].packedPBRId & 65535;
    }
    var_bb45f = v_ditheringAndMaskTinting;
    highp vec4 var_b902c = var_68814;
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
    highp vec4 var_3eefe = var_68814;
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
    highp float var_fa861;
    highp float var_5e90d;
    highp float var_fcacf;
    func_b5a96(var_39955, var_fcacf, var_5e90d, var_fa861, var_d1699, var_b9e8b, var_2f8a8);
    highp vec4 var_08b04 = vec4(var_3eefe.xyz, var_3eefe.w);
    highp vec2 var_26e09 = v_lightmapUV;
    highp vec4 var_41868 = vec4(v_lightColor, 0.0);
    highp vec4 var_cbce5 = var_41868;
    highp vec4 var_6bfdc = vec4(var_08b04.x, var_08b04.y, var_08b04.z, var_08b04.w);
    highp float var_7aa46;
    func_fb7ab(var_fcacf, var_d1699, var_7aa46);
    var_6bfdc.w = var_7aa46;
    highp vec3 var_089df = normalize(var_b9e8b);
    highp vec3 var_cd914 = var_089df;
    highp vec2 var_645ff = var_089df.xy * (1.0 / ((abs(var_cd914.x) + abs(var_cd914.y)) + abs(var_cd914.z)));
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
    highp vec4 var_eaa92 = u_prevViewProj * vec4(v_worldPos - u_prevWorldPosOffset.xyz, 1.0);
    highp vec4 var_96bda = var_eaa92;
    highp float var_9ef48 = var_96bda.w;
    highp vec4 var_d0ebc = ((var_eaa92 / vec4(var_9ef48)) * 0.5) + vec4(0.5);
    var_96bda = var_d0ebc;
    highp vec3 var_d13a4 = var_41868.xyz;
    highp vec3 var_05dbb = var_d13a4;
    highp vec3 var_774df;
    if ((((var_05dbb.x + var_05dbb.y) + var_05dbb.z) < 9.9999997473787516355514526367188e-05) && (var_26e09.x > 9.9999997473787516355514526367188e-05))
    {
        highp vec4 var_0bc6f = vec4(0.0);
        highp float var_9a19a = var_26e09.x * var_26e09.x;
        var_774df = clamp(vec3(var_9a19a + (var_0bc6f.x * var_0bc6f.w), (var_9a19a * ((((var_9a19a * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_0bc6f.y * var_0bc6f.w), (var_9a19a * (((var_9a19a * var_9a19a) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_0bc6f.z * var_0bc6f.w)), vec3(0.0), vec3(1.0));
    }
    else
    {
        var_774df = var_d13a4;
    }
    highp vec3 var_8f0e5 = var_774df * vec3(0.16666667163372039794921875);
    highp vec4 var_f46ce = vec4(var_8f0e5, 0.0039215688593685626983642578125);
    highp vec2 var_8a7dd = max(var_f46ce.xy, var_f46ce.zw);
    highp float var_a7109 = ceil(clamp(max(var_8a7dd.x, var_8a7dd.y), 0.0, 1.0) * 255.0) * 0.0039215688593685626983642578125;
    uvec4 var_63c1c = uvec4(clamp(vec4(var_8f0e5 / vec3(var_a7109), var_a7109), vec4(0.0), vec4(1.0)) * 255.0);
    uvec2 var_768db = var_63c1c.xy;
    uvec2 var_f7a74 = uvec2(var_768db.x & 255u, var_768db.y & 255u);
    uvec2 var_cc1c7 = var_63c1c.zw;
    uvec2 var_8bc3e = uvec2(var_cc1c7.x & 255u, var_cc1c7.y & 255u);
    uvec2 var_ef8ed = uvec2((var_f7a74.x << 8u) | var_f7a74.y, (var_8bc3e.x << 8u) | var_8bc3e.y);
    uint var_af2f9 = uint(clamp(var_26e09.y, 0.0, 1.0) * 255.0);
    uint var_d3959;
    if (var_cbce5.w != 0.0)
    {
        var_d3959 = var_af2f9 | 256u;
    }
    else
    {
        var_d3959 = var_af2f9;
    }
    uvec2 var_e14de = uvec2(uint(clamp(var_5e90d, 0.0, 1.0) * 255.0) & 255u, uint(clamp(var_fa861, 0.0, 1.0) * 255.0) & 255u);
    bgfx_FragData0 = uvec4((var_e14de.x << 8u) | var_e14de.y, var_ef8ed.x, var_ef8ed.y, var_d3959);
    bgfx_FragData1 = var_6bfdc;
    bgfx_FragData2 = vec4(var_532c2, var_603d8.xy - var_d0ebc.xy);
}
