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
};

layout(binding = 3, std430) buffer s_TextureShiftBufferData { TextureShiftBuffer TextureShiftBufferData[]; } var_95f1f;
uniform highp sampler2D s_LightMapTexture;
uniform highp sampler2D s_MatTexture;
uniform highp vec4 FogColor;
in highp vec4 v_color0;
in highp vec2 v_ditheringAndMaskTinting;
in highp vec4 v_fog;
in highp vec2 v_lightmapUV;
centroid in highp vec2 v_texcoord0;
flat in highp vec2 v_textureShift;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_29486 = v_color0;
    highp vec2 var_558f1 = v_textureShift;
    int var_ec921 = int(var_558f1.y * 65535.0);
    highp vec2 var_571c5 = v_texcoord0;
    highp vec2 var_7bd33 = v_ditheringAndMaskTinting;
    highp vec4 var_76414 = mix(texture(s_MatTexture, vec2(var_571c5.x + var_95f1f.TextureShiftBufferData[var_ec921].preUV0, var_571c5.y + var_95f1f.TextureShiftBufferData[var_ec921].preUV1)), texture(s_MatTexture, vec2(var_571c5.x + var_95f1f.TextureShiftBufferData[var_ec921].postUV0, var_571c5.y + var_95f1f.TextureShiftBufferData[var_ec921].postUV1)), vec4(clamp((var_95f1f.TextureShiftBufferData[var_ec921].globalAlpha - ((1.0 - var_95f1f.TextureShiftBufferData[var_ec921].localShiftLength) * var_558f1.x)) / var_95f1f.TextureShiftBufferData[var_ec921].localShiftLength, 0.0, 1.0)));
    if (var_7bd33.y > 0.5)
    {
        highp vec3 var_5e4d7 = mix(var_76414.xyz, var_76414.xyz * v_color0.xyz, vec3(var_76414.w)).xyz * var_29486.w;
        var_76414 = vec4(var_5e4d7.x, var_5e4d7.y, var_5e4d7.z, var_76414.w);
        var_76414.w = 1.0;
    }
    else
    {
        highp vec3 var_55928 = var_76414.xyz * v_color0.xyz;
        var_76414 = vec4(var_55928.x, var_55928.y, var_55928.z, var_76414.w);
        var_76414.w = var_29486.w;
    }
    highp vec4 var_390de = v_fog;
    bgfx_FragColor = vec4(mix(vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * var_76414.xyz, var_76414.w).xyz, FogColor.xyz, vec3(var_390de.w)), var_76414.w);
}
