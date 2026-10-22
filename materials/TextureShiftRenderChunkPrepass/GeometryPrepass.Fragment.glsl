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
* Dithering:
* - DITHERING__OFF (not used)
* - DITHERING__ON (not used)
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

layout(binding = 3, std430) buffer s_PBRData { PBRTextureData PBRData[]; } var_6f249;
layout(binding = 4, std430) buffer s_TextureShiftBufferData { TextureShiftBuffer TextureShiftBufferData[]; } var_f0627;
uniform highp mat4 u_prevViewProj;
uniform highp mat4 u_viewProj;
uniform highp sampler2D s_MatTexture;
uniform highp vec4 u_prevWorldPosOffset;
in highp vec3 v_bitangent;
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
void func_5f93d(inout int arg_a60ad, inout highp float arg_0da03) {
    highp float loc_61f81 = 1.0 - (v_textureShift.x * var_f0627.TextureShiftBufferData[arg_a60ad].noiseSpread);
    if (var_f0627.TextureShiftBufferData[arg_a60ad].localShiftLength == 0.0)
    {
        arg_0da03 = step(loc_61f81, var_f0627.TextureShiftBufferData[arg_a60ad].globalAlpha);
        return;
    }
    else
    {
        arg_0da03 = 1.0 - clamp((loc_61f81 - var_f0627.TextureShiftBufferData[arg_a60ad].globalAlpha) / var_f0627.TextureShiftBufferData[arg_a60ad].localShiftLength, 0.0, 1.0);
        return;
    }
}
void func_9bc40(inout int arg_7561c, inout highp float arg_6a625, inout highp float arg_9eee0, inout highp float arg_a50e1, inout highp float arg_d2a5b, inout highp vec3 arg_51e76, inout highp vec2 arg_9466e) {
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
            highp vec3 loc_646d4 = vec3(0.0, 0.0, 1.0);
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
                loc_646d4.x = loc_cf71a[loc_31dc2.x] - loc_cf71a[loc_31dc2.y];
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
                loc_646d4.y = loc_cf71a[loc_31dc2.x] - loc_cf71a[loc_31dc2.y];
                loc_646d4.z = 0.25;
                highp vec3 loc_3f9e3 = loc_646d4;
                highp vec3 loc_d29bb = normalize(loc_3f9e3);
                loc_646d4 = loc_d29bb;
                highp vec2 loc_0d55c = loc_d29bb.xy * loc_30a21;
                loc_646d4.x = loc_0d55c.x;
                loc_646d4.y = loc_0d55c.y;
            }
            loc_a4d0b = loc_646d4;
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
                    highp vec3 loc_b875d = vec3(0.0, 0.0, 1.0);
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
                        loc_b875d.x = loc_1eb74[loc_653e7.x] - loc_1eb74[loc_653e7.y];
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
                        loc_b875d.y = loc_1eb74[loc_653e7.x] - loc_1eb74[loc_653e7.y];
                        loc_b875d.z = 0.25;
                        highp vec3 loc_b2631 = loc_b875d;
                        highp vec3 loc_8a8c2 = normalize(loc_b2631);
                        loc_b875d = loc_8a8c2;
                        highp vec2 loc_3f5e9 = loc_8a8c2.xy * loc_0725d;
                        loc_b875d.x = loc_3f5e9.x;
                        loc_b875d.y = loc_3f5e9.y;
                    }
                    loc_049a7 = loc_b875d;
                }
                else
                {
                    highp vec4 loc_807fe = loc_946d4;
                    highp vec3 loc_70cf3 = vec3(0.0, 0.0, 1.0);
                    highp float loc_3e159 = clamp((loc_65ac1 * (-1.0)) + 2.0, 0.0, 1.0);
                    if (loc_3e159 > 0.0)
                    {
                        highp vec2 loc_6c8bb = fract(loc_6e94b * vec2(textureSize(s_MatTexture, 0)));
                        loc_70cf3.x = (step(0.916666686534881591796875, loc_6c8bb.x) * ((loc_807fe.y * 2.0) - 1.0)) + (step(loc_6c8bb.x, 0.083333335816860198974609375) * (1.0 - (loc_807fe.w * 2.0)));
                        loc_70cf3.y = (step(0.916666686534881591796875, loc_6c8bb.y) * ((loc_807fe.z * 2.0) - 1.0)) + (step(loc_6c8bb.y, 0.083333335816860198974609375) * (1.0 - (loc_807fe.x * 2.0)));
                        loc_70cf3.x = step(0.004999999888241291046142578125, abs(loc_70cf3.x)) * loc_70cf3.x;
                        loc_70cf3.y = step(0.004999999888241291046142578125, abs(loc_70cf3.y)) * loc_70cf3.y;
                        loc_70cf3.z = 0.25;
                        highp vec3 loc_b8a95 = loc_70cf3;
                        highp vec3 loc_ee313 = normalize(loc_b8a95);
                        loc_70cf3 = loc_ee313;
                        highp vec2 loc_dc230 = loc_ee313.xy * loc_3e159;
                        loc_70cf3.x = loc_dc230.x;
                        loc_70cf3.y = loc_dc230.y;
                    }
                    loc_049a7 = loc_70cf3;
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
    highp vec2 var_49a9d = v_ditheringAndMaskTinting;
    int var_fbecd = int(v_textureShift.y * 65535.0);
    highp float var_61961;
    func_5f93d(var_fbecd, var_61961);
    highp vec2 var_2f8a8 = v_texcoord0;
    int var_39955;
    if (var_61961 < 0.5)
    {
        var_2f8a8 = vec2(var_2f8a8.x + var_f0627.TextureShiftBufferData[var_fbecd].preUV0, var_2f8a8.y + var_f0627.TextureShiftBufferData[var_fbecd].preUV1);
        var_39955 = (var_f0627.TextureShiftBufferData[var_fbecd].packedPBRId >> 16) & 65535;
    }
    else
    {
        var_2f8a8 = vec2(var_2f8a8.x + var_f0627.TextureShiftBufferData[var_fbecd].postUV0, var_2f8a8.y + var_f0627.TextureShiftBufferData[var_fbecd].postUV1);
        var_39955 = var_f0627.TextureShiftBufferData[var_fbecd].packedPBRId & 65535;
    }
    var_49a9d = v_ditheringAndMaskTinting;
    highp vec4 var_4a86e = texture(s_MatTexture, vec2(v_texcoord0.x + var_f0627.TextureShiftBufferData[var_fbecd].preUV0, v_texcoord0.y + var_f0627.TextureShiftBufferData[var_fbecd].preUV1));
    highp vec4 var_c699e = texture(s_MatTexture, vec2(v_texcoord0.x + var_f0627.TextureShiftBufferData[var_fbecd].postUV0, v_texcoord0.y + var_f0627.TextureShiftBufferData[var_fbecd].postUV1));
    highp vec4 var_da3c1 = var_4a86e;
    highp vec4 var_e65e5 = var_c699e;
    highp float var_7dfb9;
    if (var_61961 > 0.5)
    {
        var_7dfb9 = var_e65e5.w;
    }
    else
    {
        var_7dfb9 = var_da3c1.w;
    }
    highp vec4 var_794e0 = vec4(mix(var_4a86e.xyz, var_c699e.xyz, vec3(var_61961)), var_7dfb9);
    if (var_49a9d.y != 0.0)
    {
        highp vec4 var_ec353 = var_794e0;
        highp float var_7a181 = var_794e0.w;
        highp vec3 var_d8fa6 = mix(var_ec353.xyz, var_ec353.xyz * v_color0.xyz, vec3(var_7a181));
        var_794e0.x = var_d8fa6.x;
        var_794e0.y = var_d8fa6.y;
        var_794e0.z = var_d8fa6.z;
        highp vec4 var_8e56a = var_794e0;
        highp vec3 var_a3d7a = var_8e56a.xyz * v_color0.w;
        var_794e0.x = var_a3d7a.x;
        var_794e0.y = var_a3d7a.y;
        var_794e0.z = var_a3d7a.z;
        var_794e0.w = 1.0;
    }
    else
    {
        highp vec4 var_bc465 = var_794e0;
        highp vec3 var_30e20 = var_bc465.xyz * v_color0.xyz;
        var_794e0.x = var_30e20.x;
        var_794e0.y = var_30e20.y;
        var_794e0.z = var_30e20.z;
        var_794e0.w *= v_color0.w;
    }
    highp vec3 var_b9e8b;
    highp float var_d1699;
    highp float var_fa861;
    highp float var_5e90d;
    highp float var_fcacf;
    func_9bc40(var_39955, var_fcacf, var_5e90d, var_fa861, var_d1699, var_b9e8b, var_2f8a8);
    highp vec4 var_41868 = vec4(v_lightColor, 0.0);
    highp vec4 var_b74a2 = var_41868;
    highp vec4 var_d93e5 = vec4(var_794e0.xyz, var_794e0.w);
    highp vec4 var_33385 = vec4(0.0);
    var_d93e5.x = var_794e0.x;
    var_d93e5.y = var_794e0.y;
    var_d93e5.z = var_794e0.z;
    highp float var_7aa46;
    func_fb7ab(var_fcacf, var_d1699, var_7aa46);
    var_d93e5.w = var_7aa46;
    highp vec3 var_089df = normalize(var_b9e8b);
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
    highp vec4 var_eaa92 = u_prevViewProj * vec4(v_worldPos - u_prevWorldPosOffset.xyz, 1.0);
    highp vec4 var_96bda = var_eaa92;
    highp float var_9ef48 = var_96bda.w;
    highp vec4 var_82203 = ((var_eaa92 / vec4(var_9ef48)) * 0.5) + vec4(0.5);
    var_96bda = var_82203;
    highp vec2 var_fd2cd = var_7ed87.xy - var_82203.xy;
    var_33385.z = var_fd2cd.x;
    var_33385.w = var_fd2cd.y;
    highp vec3 var_d13a4 = var_41868.xyz;
    highp vec3 var_05c1e = var_d13a4;
    highp vec3 var_eb137;
    if ((((var_05c1e.x + var_05c1e.y) + var_05c1e.z) < 9.9999997473787516355514526367188e-05) && (v_lightmapUV.x > 9.9999997473787516355514526367188e-05))
    {
        highp float var_38611 = v_lightmapUV.x * v_lightmapUV.x;
        var_eb137 = clamp(vec3(var_38611, var_38611 * ((((var_38611 * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625), var_38611 * (((var_38611 * var_38611) * 0.60000002384185791015625) + 0.4000000059604644775390625)), vec3(0.0), vec3(1.0));
    }
    else
    {
        var_eb137 = var_d13a4;
    }
    highp vec3 var_8f0e5 = var_eb137 * vec3(0.16666667163372039794921875);
    highp vec4 var_f46ce = vec4(var_8f0e5, 0.0039215688593685626983642578125);
    highp vec2 var_8a7dd = max(var_f46ce.xy, var_f46ce.zw);
    highp float var_a7109 = ceil(clamp(max(var_8a7dd.x, var_8a7dd.y), 0.0, 1.0) * 255.0) * 0.0039215688593685626983642578125;
    uvec4 var_63c1c = uvec4(clamp(vec4(var_8f0e5 / vec3(var_a7109), var_a7109), vec4(0.0), vec4(1.0)) * 255.0);
    uvec2 var_768db = var_63c1c.xy;
    uvec2 var_f7a74 = uvec2(var_768db.x & 255u, var_768db.y & 255u);
    uvec2 var_cc1c7 = var_63c1c.zw;
    uvec2 var_8bc3e = uvec2(var_cc1c7.x & 255u, var_cc1c7.y & 255u);
    uvec2 var_d91c4 = uvec2((var_f7a74.x << 8u) | var_f7a74.y, (var_8bc3e.x << 8u) | var_8bc3e.y);
    highp vec3 var_0b329 = normalize(v_normal);
    bvec3 var_50211 = greaterThanEqual(abs(var_0b329), vec3(0.9900000095367431640625));
    ivec3 var_9d745 = ivec3(any(lessThan(var_0b329, vec3(-0.5))) ? (-1) : 1) * ivec3(int(var_50211.x), int(var_50211.y), int(var_50211.z));
    ivec3 var_11e7d = abs(var_9d745);
    uvec2 var_56ace = uvec2(uint(clamp(var_5e90d, 0.0, 1.0) * 255.0) & 255u, uint(clamp(var_fa861, 0.0, 1.0) * 255.0) & 255u);
    bgfx_FragData0 = uvec4((var_56ace.x << 8u) | var_56ace.y, var_d91c4.x, var_d91c4.y, (uint(clamp(v_lightmapUV.y, 0.0, 1.0) * 255.0) | uint(((uint(floor(var_b74a2.w * 255.0)) & 1u) != 0u) ? 256 : 0)) | ((((uint(var_11e7d.x + var_11e7d.z) | uint((var_11e7d.y + var_11e7d.z) << 1)) | uint(int(any(equal(vec3(var_9d745), vec3(-1.0)))) << 2)) & 7u) << uint(9)));
    bgfx_FragData1 = var_d93e5;
    bgfx_FragData2 = var_33385;
}
