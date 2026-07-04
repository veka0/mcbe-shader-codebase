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

layout(binding = 3, std430) buffer s_PBRData { PBRTextureData PBRData[]; } var_81887;
layout(binding = 4, std430) buffer s_TextureShiftBufferData { TextureShiftBuffer TextureShiftBufferData[]; } var_8ebd4;
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
void func_4f173(inout int arg_3c414, inout highp float arg_6a625, inout highp float arg_9eee0, inout highp float arg_a50e1, inout highp float arg_d2a5b, inout highp vec3 arg_51e76, inout highp vec2 arg_0f096) {
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
            highp vec2 loc_4b360 = (arg_0f096 * loc_0a83e) + loc_1e303;
            highp vec3 loc_850fe = vec3(0.0, 0.0, 1.0);
            highp float loc_30a21 = clamp((min(var_81887.PBRData[arg_3c414].maxMipNormal - var_81887.PBRData[arg_3c414].maxMipColour, var_81887.PBRData[arg_3c414].maxMipNormal) * (-1.0)) + 2.0, 0.0, 1.0);
            if (loc_30a21 > 0.0)
            {
                highp vec4 loc_798a3 = textureLod(s_MatTexture, loc_4b360, 0.0);
                highp vec2 loc_4d034 = fract(loc_4b360 * vec2(textureSize(s_MatTexture, 0)));
                loc_850fe.x = (step(0.916666686534881591796875, loc_4d034.x) * ((loc_798a3.y * 2.0) - 1.0)) + (step(loc_4d034.x, 0.083333335816860198974609375) * (1.0 - (loc_798a3.w * 2.0)));
                loc_850fe.y = (step(0.916666686534881591796875, loc_4d034.y) * ((loc_798a3.z * 2.0) - 1.0)) + (step(loc_4d034.y, 0.083333335816860198974609375) * (1.0 - (loc_798a3.x * 2.0)));
                loc_850fe.x = step(0.004999999888241291046142578125, abs(loc_850fe.x)) * loc_850fe.x;
                loc_850fe.y = step(0.004999999888241291046142578125, abs(loc_850fe.y)) * loc_850fe.y;
                loc_850fe.z = 0.25;
                highp vec3 loc_1cc05 = normalize(loc_850fe);
                highp vec2 loc_8557e = loc_1cc05.xy * loc_30a21;
                loc_850fe = vec3(loc_8557e.x, loc_8557e.y, loc_1cc05.z);
            }
            loc_9252d = loc_850fe;
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
    highp vec2 var_49a9d = v_ditheringAndMaskTinting;
    highp vec2 var_19cca = v_textureShift;
    int var_218bc = int(var_19cca.y * 65535.0);
    highp float var_4ad7a = clamp((var_8ebd4.TextureShiftBufferData[var_218bc].globalAlpha - ((1.0 - var_8ebd4.TextureShiftBufferData[var_218bc].localShiftLength) * var_19cca.x)) / var_8ebd4.TextureShiftBufferData[var_218bc].localShiftLength, 0.0, 1.0);
    highp vec2 var_f486c = v_texcoord0;
    highp vec4 var_45704 = texture(s_MatTexture, vec2(var_f486c.x + var_8ebd4.TextureShiftBufferData[var_218bc].preUV0, var_f486c.y + var_8ebd4.TextureShiftBufferData[var_218bc].preUV1));
    highp vec4 var_457f9 = texture(s_MatTexture, vec2(var_f486c.x + var_8ebd4.TextureShiftBufferData[var_218bc].postUV0, var_f486c.y + var_8ebd4.TextureShiftBufferData[var_218bc].postUV1));
    highp vec2 var_2f8a8 = v_texcoord0;
    int var_39955;
    if (var_4ad7a < 0.5)
    {
        var_2f8a8 = vec2(var_2f8a8.x + var_8ebd4.TextureShiftBufferData[var_218bc].preUV0, var_2f8a8.y + var_8ebd4.TextureShiftBufferData[var_218bc].preUV1);
        var_39955 = (var_8ebd4.TextureShiftBufferData[var_218bc].packedPBRId >> 16) & 65535;
    }
    else
    {
        var_2f8a8 = vec2(var_2f8a8.x + var_8ebd4.TextureShiftBufferData[var_218bc].postUV0, var_2f8a8.y + var_8ebd4.TextureShiftBufferData[var_218bc].postUV1);
        var_39955 = var_8ebd4.TextureShiftBufferData[var_218bc].packedPBRId & 65535;
    }
    var_49a9d = v_ditheringAndMaskTinting;
    highp vec4 var_815fb = mix(var_45704, var_457f9, vec4(var_4ad7a));
    if (var_49a9d.y != 0.0)
    {
        highp vec3 var_5e4d7 = mix(var_815fb.xyz, var_815fb.xyz * v_color0.xyz, vec3(var_815fb.w)).xyz * var_3f821.w;
        var_815fb = vec4(var_5e4d7.x, var_5e4d7.y, var_5e4d7.z, var_815fb.w);
        var_815fb.w = 1.0;
    }
    else
    {
        highp vec3 var_55928 = var_815fb.xyz * v_color0.xyz;
        var_815fb = vec4(var_55928.x, var_55928.y, var_55928.z, var_815fb.w);
        var_815fb.w *= var_3f821.w;
    }
    highp vec3 var_b9e8b;
    highp float var_d1699;
    highp float var_fa861;
    highp float var_5e90d;
    highp float var_fcacf;
    func_4f173(var_39955, var_fcacf, var_5e90d, var_fa861, var_d1699, var_b9e8b, var_2f8a8);
    highp vec4 var_08b04 = vec4(var_815fb.xyz, var_815fb.w);
    highp vec2 var_58222 = v_lightmapUV;
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
    highp vec3 var_2b55b = v_lightColor;
    highp vec3 var_5c15e;
    if ((((var_2b55b.x + var_2b55b.y) + var_2b55b.z) < 9.9999997473787516355514526367188e-05) && (var_58222.x > 9.9999997473787516355514526367188e-05))
    {
        highp vec4 var_0bc6f = vec4(0.0);
        highp float var_9a19a = var_58222.x * var_58222.x;
        var_5c15e = clamp(vec3(var_9a19a + (var_0bc6f.x * var_0bc6f.w), (var_9a19a * ((((var_9a19a * 0.60000002384185791015625) + 0.4000000059604644775390625) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_0bc6f.y * var_0bc6f.w), (var_9a19a * (((var_9a19a * var_9a19a) * 0.60000002384185791015625) + 0.4000000059604644775390625)) + (var_0bc6f.z * var_0bc6f.w)), vec3(0.0), vec3(1.0));
    }
    else
    {
        var_5c15e = v_lightColor;
    }
    highp vec3 var_8f0e5 = var_5c15e * vec3(0.16666667163372039794921875);
    highp vec4 var_f46ce = vec4(var_8f0e5, 0.0039215688593685626983642578125);
    highp vec2 var_8a7dd = max(var_f46ce.xy, var_f46ce.zw);
    highp float var_a7109 = ceil(clamp(max(var_8a7dd.x, var_8a7dd.y), 0.0, 1.0) * 255.0) * 0.0039215688593685626983642578125;
    uvec4 var_63c1c = uvec4(clamp(vec4(var_8f0e5 / vec3(var_a7109), var_a7109), vec4(0.0), vec4(1.0)) * 255.0);
    uvec2 var_768db = var_63c1c.xy;
    uvec2 var_f7a74 = uvec2(var_768db.x & 255u, var_768db.y & 255u);
    uvec2 var_cc1c7 = var_63c1c.zw;
    uvec2 var_8bc3e = uvec2(var_cc1c7.x & 255u, var_cc1c7.y & 255u);
    uvec2 var_12195 = uvec2((var_f7a74.x << 8u) | var_f7a74.y, (var_8bc3e.x << 8u) | var_8bc3e.y);
    uvec2 var_73d15 = uvec2(uint(clamp(var_5e90d, 0.0, 1.0) * 255.0) & 255u, uint(clamp(var_fa861, 0.0, 1.0) * 255.0) & 255u);
    bgfx_FragData0 = uvec4((var_73d15.x << 8u) | var_73d15.y, var_12195.x, var_12195.y, uint(clamp(var_58222.y, 0.0, 1.0) * 255.0));
    bgfx_FragData1 = var_6bfdc;
    bgfx_FragData2 = vec4(var_532c2, var_603d8.xy - var_d0ebc.xy);
}
