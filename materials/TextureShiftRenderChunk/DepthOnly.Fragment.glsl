#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_PASS (not used)
* - OPAQUE_PASS (not used)
* - TRANSPARENT_PASS (not used)
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
* - uniform lowp sampler2D s_SeasonsTexture;
* - layout(binding = 3, std430) buffer s_TextureShiftBufferDataBuffer { TextureShiftBuffer s_TextureShiftBufferData[]; };
*
* Uniforms:
* - uniform vec4 DitherParams;
* - uniform vec4 DitherParams2[3];
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 GlobalRoughness;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MaterialID;
* - uniform vec4 MeshContext;
* - uniform vec4 RenderChunkFogAlpha;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 ViewPositionAndTime;
*/

precision mediump float;
precision highp int;
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

layout(binding = 3, std430) buffer s_TextureShiftBufferData { TextureShiftBuffer TextureShiftBufferData[]; } var_803cb;
uniform highp sampler2D s_LightMapTexture;
uniform highp sampler2D s_MatTexture;
uniform highp vec4 FogColor;
in highp vec4 v_fog;
in highp vec2 v_lightmapUV;
centroid in highp vec2 v_texcoord0;
flat in highp vec2 v_textureShift;
layout(location = 0) out highp vec4 bgfx_FragColor;
void func_f1932(inout highp vec2 arg_c2b61, inout int arg_651a0, inout highp float arg_0da03) {
    highp float loc_47c38 = 1.0 - (arg_c2b61.x * var_803cb.TextureShiftBufferData[arg_651a0].noiseSpread);
    if (var_803cb.TextureShiftBufferData[arg_651a0].localShiftLength == 0.0)
    {
        arg_0da03 = step(loc_47c38, var_803cb.TextureShiftBufferData[arg_651a0].globalAlpha);
        return;
    }
    else
    {
        arg_0da03 = 1.0 - clamp((loc_47c38 - var_803cb.TextureShiftBufferData[arg_651a0].globalAlpha) / var_803cb.TextureShiftBufferData[arg_651a0].localShiftLength, 0.0, 1.0);
        return;
    }
}
void main() {
    highp vec2 var_1614a = v_textureShift;
    int var_d0c42 = int(var_1614a.y * 65535.0);
    highp float var_b4fa2;
    func_f1932(var_1614a, var_d0c42, var_b4fa2);
    highp vec2 var_f486c = v_texcoord0;
    highp vec4 var_4b671 = texture(s_MatTexture, vec2(var_f486c.x + var_803cb.TextureShiftBufferData[var_d0c42].preUV0, var_f486c.y + var_803cb.TextureShiftBufferData[var_d0c42].preUV1));
    highp vec4 var_2e873 = texture(s_MatTexture, vec2(var_f486c.x + var_803cb.TextureShiftBufferData[var_d0c42].postUV0, var_f486c.y + var_803cb.TextureShiftBufferData[var_d0c42].postUV1));
    highp vec4 var_da3c1 = var_4b671;
    highp vec4 var_e65e5 = var_2e873;
    highp float var_7dfb9;
    if (var_b4fa2 > 0.5)
    {
        var_7dfb9 = var_e65e5.w;
    }
    else
    {
        var_7dfb9 = var_da3c1.w;
    }
    highp vec4 var_11092 = vec4(mix(var_4b671.xyz, var_2e873.xyz, vec3(var_b4fa2)), var_7dfb9);
    if (var_11092.w < 0.5)
    {
        discard;
    }
    highp vec4 var_89572 = v_fog;
    bgfx_FragColor = vec4(mix(vec4(texture(s_LightMapTexture, v_lightmapUV).xyz, 1.0).xyz, FogColor.xyz, vec3(var_89572.w)), 1.0);
}
