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
struct TextureShiftBuffer {
    highp float preUV0;
    highp float preUV1;
    highp float postUV0;
    highp float postUV1;
    int packedPBRId;
    highp float globalAlpha;
    highp float localShiftLength;
};

layout(binding = 4, std430) buffer s_TextureShiftBufferData { TextureShiftBuffer TextureShiftBufferData[]; } var_8150d;
uniform highp sampler2D s_MatTexture;
in highp vec2 v_texcoord0;
flat in highp vec2 v_textureShift;
layout(location = 0) out highp vec4 bgfx_FragData0;
layout(location = 1) out highp vec4 bgfx_FragData1;
layout(location = 2) out highp vec4 bgfx_FragData2;
void main() {
    highp vec2 var_558f1 = v_textureShift;
    int var_ec921 = int(var_558f1.y * 65535.0);
    highp vec2 var_571c5 = v_texcoord0;
    highp vec4 var_b257d = mix(texture(s_MatTexture, vec2(var_571c5.x + var_8150d.TextureShiftBufferData[var_ec921].preUV0, var_571c5.y + var_8150d.TextureShiftBufferData[var_ec921].preUV1)), texture(s_MatTexture, vec2(var_571c5.x + var_8150d.TextureShiftBufferData[var_ec921].postUV0, var_571c5.y + var_8150d.TextureShiftBufferData[var_ec921].postUV1)), vec4(clamp((var_8150d.TextureShiftBufferData[var_ec921].globalAlpha - ((1.0 - var_8150d.TextureShiftBufferData[var_ec921].localShiftLength) * var_558f1.x)) / var_8150d.TextureShiftBufferData[var_ec921].localShiftLength, 0.0, 1.0)));
    if (var_b257d.w < 0.5)
    {
        discard;
    }
    bgfx_FragData0 = vec4(1.0);
    bgfx_FragData1 = vec4(0.0);
    bgfx_FragData2 = vec4(0.0);
}
