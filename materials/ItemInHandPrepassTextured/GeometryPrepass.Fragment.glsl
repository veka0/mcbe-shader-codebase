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
* Fancy:
* - FANCY__OFF (not used)
* - FANCY__ON (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* MultiColorTint:
* - MULTI_COLOR_TINT__OFF
* - MULTI_COLOR_TINT__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
* - layout(binding = 1, std430) buffer s_PBRDataBuffer { PBRTextureData s_PBRData[]; };
*
* Uniforms:
* - uniform vec4 AlphaMaskedTint;
* - uniform vec4 BlockLightColor;
* - uniform vec4 ChangeColor;
* - uniform vec4 ColorBased;
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
* - uniform vec4 DitheringEnabledToggle;
* - uniform vec4 FogColor;
* - uniform vec4 FogControl;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MatColor;
* - uniform vec4 MaterialID;
* - uniform vec4 MultiplicativeTintColor;
* - uniform vec4 OverlayColor;
* - uniform mat4 PrevWorld;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 TileLightColor;
* - uniform vec4 TileLightIntensity;
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

float var_33fae;
layout(binding = 1, std430) buffer s_PBRData { PBRTextureData PBRData[]; } var_5f101;
uniform highp mat4 u_invView;
uniform highp mat4 u_prevViewProj;
uniform highp mat4 u_view;
uniform highp mat4 u_viewProj;
uniform highp sampler2D s_MatTexture;
uniform highp vec4 AlphaMaskedTint;
uniform highp vec4 BlockLightColor;
uniform highp vec4 ChangeColor;
uniform highp vec4 ColorBased;
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
uniform highp vec4 DitheringEnabledToggle;
uniform highp vec4 MatColor;
#ifdef MULTI_COLOR_TINT__ON
uniform highp vec4 MultiplicativeTintColor;
#endif
uniform highp vec4 OverlayColor;
uniform highp vec4 TileLightIntensity;
uniform highp vec4 u_prevWorldPosOffset;
in highp vec3 v_bitangent;
in highp vec4 v_clipPosition;
in highp vec4 v_color0;
in highp vec3 v_normal;
flat in int v_pbrTextureId;
in highp vec3 v_prevWorldPos;
in highp vec3 v_tangent;
in highp vec2 v_texcoord0;
in highp vec3 v_worldPos;
layout(location = 0) out uvec4 bgfx_FragData0;
layout(location = 1) out highp vec4 bgfx_FragData1;
layout(location = 2) out highp vec4 bgfx_FragData2;
void func_028da(inout highp float arg_6a625, inout highp float arg_9eee0, inout highp float arg_a50e1, inout highp float arg_d2a5b, inout highp vec3 arg_2dec6) {
    if (v_pbrTextureId == 65535)
    {
        arg_6a625 = 0.0;
        arg_9eee0 = 1.0;
        arg_a50e1 = 0.0;
        arg_d2a5b = 0.0;
        arg_2dec6 = v_normal;
        return;
    }
    highp vec2 loc_59055 = vec2(var_5f101.PBRData[v_pbrTextureId].colourToNormalUvScale0, var_5f101.PBRData[v_pbrTextureId].colourToNormalUvScale1);
    highp vec2 loc_39ca3 = vec2(var_5f101.PBRData[v_pbrTextureId].colourToNormalUvBias0, var_5f101.PBRData[v_pbrTextureId].colourToNormalUvBias1);
    highp vec3 loc_b4ff6;
    if ((var_5f101.PBRData[v_pbrTextureId].flags & 4) == 4)
    {
        loc_b4ff6 = (texture(s_MatTexture, (v_texcoord0 * loc_59055) + loc_39ca3).xyz * 2.0) - vec3(1.0);
    }
    else
    {
        highp vec3 loc_9252d;
        if ((var_5f101.PBRData[v_pbrTextureId].flags & 8) == 8)
        {
            highp vec2 loc_32eb7 = (v_texcoord0 * loc_59055) + loc_39ca3;
            highp vec3 loc_850fe = vec3(0.0, 0.0, 1.0);
            highp float loc_b88fd = clamp((min(var_5f101.PBRData[v_pbrTextureId].maxMipNormal - var_5f101.PBRData[v_pbrTextureId].maxMipColour, var_5f101.PBRData[v_pbrTextureId].maxMipNormal) * (-1.0)) + 2.0, 0.0, 1.0);
            if (loc_b88fd > 0.0)
            {
                highp vec4 loc_798a3 = textureLod(s_MatTexture, loc_32eb7, 0.0);
                highp vec2 loc_4d034 = fract(loc_32eb7 * vec2(textureSize(s_MatTexture, 0)));
                loc_850fe.x = (step(0.916666686534881591796875, loc_4d034.x) * ((loc_798a3.y * 2.0) - 1.0)) + (step(loc_4d034.x, 0.083333335816860198974609375) * (1.0 - (loc_798a3.w * 2.0)));
                loc_850fe.y = (step(0.916666686534881591796875, loc_4d034.y) * ((loc_798a3.z * 2.0) - 1.0)) + (step(loc_4d034.y, 0.083333335816860198974609375) * (1.0 - (loc_798a3.x * 2.0)));
                loc_850fe.x = step(0.004999999888241291046142578125, abs(loc_850fe.x)) * loc_850fe.x;
                loc_850fe.y = step(0.004999999888241291046142578125, abs(loc_850fe.y)) * loc_850fe.y;
                loc_850fe.z = 0.25;
                highp vec3 loc_1cc05 = normalize(loc_850fe);
                highp vec2 loc_8557e = loc_1cc05.xy * loc_b88fd;
                loc_850fe = vec3(loc_8557e.x, loc_8557e.y, loc_1cc05.z);
            }
            loc_9252d = loc_850fe;
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
    if ((var_5f101.PBRData[v_pbrTextureId].flags & 1) == 1)
    {
        highp vec4 loc_300fb = texture(s_MatTexture, (v_texcoord0 * vec2(var_5f101.PBRData[v_pbrTextureId].colourToMaterialUvScale0, var_5f101.PBRData[v_pbrTextureId].colourToMaterialUvScale1)) + vec2(var_5f101.PBRData[v_pbrTextureId].colourToMaterialUvBias0, var_5f101.PBRData[v_pbrTextureId].colourToMaterialUvBias1));
        highp float loc_c4db1;
        if ((var_5f101.PBRData[v_pbrTextureId].flags & 2) == 2)
        {
            loc_c4db1 = loc_300fb.w;
        }
        else
        {
            loc_c4db1 = var_5f101.PBRData[v_pbrTextureId].uniformSubsurface;
        }
        loc_d7d8a = loc_c4db1;
        loc_00c14 = loc_300fb.y;
        loc_73c14 = loc_300fb.x;
        loc_659d6 = loc_300fb.z;
    }
    else
    {
        loc_d7d8a = var_5f101.PBRData[v_pbrTextureId].uniformSubsurface;
        loc_00c14 = var_5f101.PBRData[v_pbrTextureId].uniformEmissive;
        loc_73c14 = var_5f101.PBRData[v_pbrTextureId].uniformMetalness;
        loc_659d6 = var_5f101.PBRData[v_pbrTextureId].uniformRoughness;
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
    arg_2dec6 = transpose(transpose(mat3(normalize(v_tangent), normalize(v_bitangent), normalize(loc_93b23)))) * loc_b4ff6;
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
    highp vec4 var_af32d = v_color0;
    highp vec4 var_1bee0 = texture(s_MatTexture, v_texcoord0);
    if (AlphaMaskedTint.x != 0.0)
    {
        highp vec3 var_5e4d7 = mix(var_1bee0.xyz, var_1bee0.xyz * v_color0.xyz, vec3(var_1bee0.w)).xyz * var_af32d.w;
        var_1bee0 = vec4(var_5e4d7.x, var_5e4d7.y, var_5e4d7.z, var_1bee0.w);
        var_1bee0.w = 1.0;
    }
    else
    {
        highp vec3 var_55928 = var_1bee0.xyz * v_color0.xyz;
        var_1bee0 = vec4(var_55928.x, var_55928.y, var_55928.z, var_1bee0.w);
    }
    highp vec4 var_74395 = var_1bee0;
    highp vec4 var_0d9b4 = var_74395 * MatColor;
    var_1bee0 = var_0d9b4;
#ifdef MULTI_COLOR_TINT__OFF
    highp vec3 var_2ce32 = var_0d9b4.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
#endif
#ifdef MULTI_COLOR_TINT__ON
    highp vec3 var_0bba1 = var_0d9b4.xyz * mix(vec3(1.0), v_color0.xyz, vec3(ColorBased.x));
    highp vec2 var_35473 = var_0bba1.xy;
    highp vec3 var_f9ddb = mix(mix((var_0bba1.xxx * ChangeColor.xyz).xyz, var_0bba1.yyy * MultiplicativeTintColor.xyz, vec3(ceil(var_35473.y))).xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    highp vec4 var_d0f6d = vec4(var_f9ddb.x, var_f9ddb.y, var_f9ddb.z, var_0d9b4.w);
#endif
#ifdef MULTI_COLOR_TINT__OFF
    highp vec4 var_24ae4 = vec4(var_2ce32.x, var_2ce32.y, var_2ce32.z, var_0d9b4.w);
    highp vec3 var_99f3c = mix(mix(var_24ae4, var_24ae4 * ChangeColor, vec4(var_af32d.w)).xyz, OverlayColor.xyz, vec3(OverlayColor.w));
    highp vec4 var_d0f6d = vec4(var_99f3c.x, var_99f3c.y, var_99f3c.z, var_0d9b4.w);
#endif
    highp vec2 var_7c9c5 = DitherParams2[0].xy;
    bool var_410b5;
    if (DitheringEnabledToggle.x != 0.0)
    {
        highp mat4 var_4971e = u_view;
        highp vec4 var_d36cf = v_clipPosition;
        highp vec2 var_886c2 = floor(((((v_clipPosition.xyz / vec3(var_d36cf.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[0].z)) * DitherParams2[0].z;
        highp vec2 var_f4989 = floor(var_886c2 * 0.25);
        highp vec2 var_85686 = floor(var_886c2 * 0.5);
        highp vec2 var_09c49 = floor(var_886c2);
        var_410b5 = smoothstep(var_7c9c5.x, var_7c9c5.y, dot(-normalize(vec4(var_4971e[0].z, var_4971e[1].z, var_4971e[2].z, var_33fae).xyz), v_worldPos - (u_invView * vec4(0.0, 0.0, 0.0, 1.0)).xyz)) <= (((((((fract((var_f4989.x * 0.5) + ((var_f4989.y * var_f4989.y) * 0.75)) * 0.25) + fract((var_85686.x * 0.5) + ((var_85686.y * var_85686.y) * 0.75))) * 0.25) + fract((var_09c49.x * 0.5) + ((var_09c49.y * var_09c49.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        var_410b5 = false;
    }
    if (var_410b5)
    {
        var_d0f6d.w = 0.0;
    }
    highp vec3 var_d2ce2;
    highp float var_bd3b6;
    highp float var_de0d6;
    highp float var_08af3;
    highp float var_5431f;
    func_028da(var_5431f, var_08af3, var_de0d6, var_bd3b6, var_d2ce2);
    highp vec4 var_08b04 = vec4(var_d0f6d.xyz, var_d0f6d.w);
    highp vec4 var_6bfdc = vec4(var_08b04.x, var_08b04.y, var_08b04.z, var_08b04.w);
    highp float var_7aa46;
    func_fb7ab(var_5431f, var_bd3b6, var_7aa46);
    var_6bfdc.w = var_7aa46;
    highp vec3 var_089df = normalize(var_d2ce2);
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
    uvec2 var_cfc6a = uvec2(uint(clamp(var_08af3, 0.0, 1.0) * 255.0) & 255u, uint(clamp(var_de0d6, 0.0, 1.0) * 255.0) & 255u);
    bgfx_FragData0 = uvec4((var_cfc6a.x << 8u) | var_cfc6a.y, var_92e39.x, var_92e39.y, uint(clamp(TileLightIntensity.y, 0.0, 1.0) * 255.0));
    bgfx_FragData1 = var_6bfdc;
    bgfx_FragData2 = vec4(var_532c2, var_603d8.xy - var_d0ebc.xy);
}
