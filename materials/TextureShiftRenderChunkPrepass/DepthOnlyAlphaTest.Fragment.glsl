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

layout(binding = 4, std430) buffer s_TextureShiftBufferData { TextureShiftBuffer TextureShiftBufferData[]; } var_8983d;
uniform highp sampler2D s_MatTexture;
in highp vec2 v_texcoord0;
flat in highp vec2 v_textureShift;
layout(location = 0) out highp vec4 bgfx_FragColor;
void func_5f93d(inout int arg_a60ad, inout highp float arg_0da03) {
    highp float loc_61f81 = 1.0 - (v_textureShift.x * var_8983d.TextureShiftBufferData[arg_a60ad].noiseSpread);
    if (var_8983d.TextureShiftBufferData[arg_a60ad].localShiftLength == 0.0)
    {
        arg_0da03 = step(loc_61f81, var_8983d.TextureShiftBufferData[arg_a60ad].globalAlpha);
        return;
    }
    else
    {
        arg_0da03 = 1.0 - clamp((loc_61f81 - var_8983d.TextureShiftBufferData[arg_a60ad].globalAlpha) / var_8983d.TextureShiftBufferData[arg_a60ad].localShiftLength, 0.0, 1.0);
        return;
    }
}
void main() {
    int var_72bf8 = int(v_textureShift.y * 65535.0);
    highp float var_ed230;
    func_5f93d(var_72bf8, var_ed230);
    highp vec4 var_4a86e = texture(s_MatTexture, vec2(v_texcoord0.x + var_8983d.TextureShiftBufferData[var_72bf8].preUV0, v_texcoord0.y + var_8983d.TextureShiftBufferData[var_72bf8].preUV1));
    highp vec4 var_c699e = texture(s_MatTexture, vec2(v_texcoord0.x + var_8983d.TextureShiftBufferData[var_72bf8].postUV0, v_texcoord0.y + var_8983d.TextureShiftBufferData[var_72bf8].postUV1));
    highp vec4 var_da3c1 = var_4a86e;
    highp vec4 var_e65e5 = var_c699e;
    highp float var_7dfb9;
    if (var_ed230 > 0.5)
    {
        var_7dfb9 = var_e65e5.w;
    }
    else
    {
        var_7dfb9 = var_da3c1.w;
    }
    highp vec4 var_11092 = vec4(mix(var_4a86e.xyz, var_c699e.xyz, vec3(var_ed230)), var_7dfb9);
    if (var_11092.w < 0.5)
    {
        discard;
    }
    bgfx_FragColor = vec4(0.0);
}
