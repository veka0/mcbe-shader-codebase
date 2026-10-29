#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_OPAQUE_PASS (not used)
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

layout(binding = 3, std430) buffer s_TextureShiftBufferData { TextureShiftBuffer TextureShiftBufferData[]; } var_aed23;
uniform highp sampler2D s_LightMapTexture;
uniform highp sampler2D s_MatTexture;
uniform highp vec4 FogColor;
in highp vec4 v_color0;
in highp vec2 v_ditheringAndMaskTinting;
in highp vec4 v_fog;
in highp vec2 v_lightmapUV;
centroid in highp vec2 v_texcoord0;
flat in highp vec2 v_textureShift;
layout(location = 0) out highp vec4 bgfx_FragData0;
void func_5f93d(inout int arg_a60ad, inout highp float arg_0da03) {
    highp float loc_61f81 = 1.0 - (v_textureShift.x * var_aed23.TextureShiftBufferData[arg_a60ad].noiseSpread);
    if (var_aed23.TextureShiftBufferData[arg_a60ad].localShiftLength == 0.0)
    {
        arg_0da03 = step(loc_61f81, var_aed23.TextureShiftBufferData[arg_a60ad].globalAlpha);
        return;
    }
    else
    {
        arg_0da03 = 1.0 - clamp((loc_61f81 - var_aed23.TextureShiftBufferData[arg_a60ad].globalAlpha) / var_aed23.TextureShiftBufferData[arg_a60ad].localShiftLength, 0.0, 1.0);
        return;
    }
}
void main() {
    int var_72bf8 = int(v_textureShift.y * 65535.0);
    highp float var_ed230;
    func_5f93d(var_72bf8, var_ed230);
    highp vec4 var_4a86e = texture(s_MatTexture, vec2(v_texcoord0.x + var_aed23.TextureShiftBufferData[var_72bf8].preUV0, v_texcoord0.y + var_aed23.TextureShiftBufferData[var_72bf8].preUV1));
    highp vec4 var_c699e = texture(s_MatTexture, vec2(v_texcoord0.x + var_aed23.TextureShiftBufferData[var_72bf8].postUV0, v_texcoord0.y + var_aed23.TextureShiftBufferData[var_72bf8].postUV1));
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
    highp vec4 var_e0fc9 = vec4(mix(var_4a86e.xyz, var_c699e.xyz, vec3(var_ed230)), var_7dfb9);
    if (v_ditheringAndMaskTinting.y > 0.5)
    {
        highp vec4 var_ec353 = var_e0fc9;
        highp float var_7a181 = var_e0fc9.w;
        highp vec3 var_d8fa6 = mix(var_ec353.xyz, var_ec353.xyz * v_color0.xyz, vec3(var_7a181));
        var_e0fc9.x = var_d8fa6.x;
        var_e0fc9.y = var_d8fa6.y;
        var_e0fc9.z = var_d8fa6.z;
        highp vec4 var_8e56a = var_e0fc9;
        highp vec3 var_a3d7a = var_8e56a.xyz * v_color0.w;
        var_e0fc9.x = var_a3d7a.x;
        var_e0fc9.y = var_a3d7a.y;
        var_e0fc9.z = var_a3d7a.z;
        var_e0fc9.w = 1.0;
    }
    else
    {
        highp vec4 var_bc465 = var_e0fc9;
        highp vec3 var_30e20 = var_bc465.xyz * v_color0.xyz;
        var_e0fc9.x = var_30e20.x;
        var_e0fc9.y = var_30e20.y;
        var_e0fc9.z = var_30e20.z;
        var_e0fc9.w = v_color0.w;
    }
    highp vec4 var_49453 = vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * var_e0fc9.xyz, var_e0fc9.w);
    highp vec4 var_72c1b = var_49453;
    highp vec3 var_8a63e = mix(var_49453.xyz, FogColor.xyz, vec3(v_fog.w));
    var_72c1b.x = var_8a63e.x;
    var_72c1b.y = var_8a63e.y;
    var_72c1b.z = var_8a63e.z;
    bgfx_FragData0 = var_72c1b;
}
