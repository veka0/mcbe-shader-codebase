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

#ifdef DITHERING__ON
float var_466e6;
#endif
layout(binding = 3, std430) buffer s_TextureShiftBufferData { TextureShiftBuffer TextureShiftBufferData[]; } var_95f1f;
#ifdef DITHERING__ON
uniform highp mat4 u_view;
#endif
uniform highp sampler2D s_LightMapTexture;
uniform highp sampler2D s_MatTexture;
#ifdef DITHERING__ON
uniform highp vec4 DitherParams2[3];
uniform highp vec4 DitherParams;
#endif
uniform highp vec4 FogColor;
#ifdef DITHERING__ON
uniform highp vec4 ViewPositionAndTime;
in highp vec4 v_clipPosition;
#endif
in highp vec4 v_color0;
#ifdef DITHERING__ON
in highp vec2 v_ditheringAndMaskTinting;
#endif
in highp vec4 v_fog;
in highp vec2 v_lightmapUV;
centroid in highp vec2 v_texcoord0;
flat in highp vec2 v_textureShift;
#ifdef DITHERING__ON
in highp vec4 v_worldPosition;
#endif
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec2 var_558f1 = v_textureShift;
    int var_ec921 = int(var_558f1.y * 65535.0);
    highp vec2 var_571c5 = v_texcoord0;
#ifdef DITHERING__ON
    highp vec2 var_4f8e7 = v_ditheringAndMaskTinting;
#endif
    highp vec4 var_407d1 = mix(texture(s_MatTexture, vec2(var_571c5.x + var_95f1f.TextureShiftBufferData[var_ec921].preUV0, var_571c5.y + var_95f1f.TextureShiftBufferData[var_ec921].preUV1)), texture(s_MatTexture, vec2(var_571c5.x + var_95f1f.TextureShiftBufferData[var_ec921].postUV0, var_571c5.y + var_95f1f.TextureShiftBufferData[var_ec921].postUV1)), vec4(clamp((var_95f1f.TextureShiftBufferData[var_ec921].globalAlpha - ((1.0 - var_95f1f.TextureShiftBufferData[var_ec921].localShiftLength) * var_558f1.x)) / var_95f1f.TextureShiftBufferData[var_ec921].localShiftLength, 0.0, 1.0)));
#ifdef DITHERING__OFF
    if (false || (var_407d1.w < 0.5))
#endif
#ifdef DITHERING__ON
    highp vec2 var_42b21 = DitherParams2[2].xy;
    bool var_2935c;
    if (var_4f8e7.x > 0.5)
#endif
    {
#ifdef DITHERING__ON
        highp mat4 var_4228f = u_view;
        highp vec4 var_bb748 = v_clipPosition;
        highp vec2 var_b2538 = floor(((((v_clipPosition.xyz / vec3(var_bb748.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[2].z)) * DitherParams2[2].z;
        highp vec2 var_765a5 = floor(var_b2538 * 0.25);
        highp vec2 var_9b96b = floor(var_b2538 * 0.5);
        highp vec2 var_9ed5c = floor(var_b2538);
        var_2935c = smoothstep(var_42b21.x, var_42b21.y, dot(-normalize(vec4(var_4228f[0].z, var_4228f[1].z, var_4228f[2].z, var_466e6).xyz), v_worldPosition.xyz - ViewPositionAndTime.xyz)) <= (((((((fract((var_765a5.x * 0.5) + ((var_765a5.y * var_765a5.y) * 0.75)) * 0.25) + fract((var_9b96b.x * 0.5) + ((var_9b96b.y * var_9b96b.y) * 0.75))) * 0.25) + fract((var_9ed5c.x * 0.5) + ((var_9ed5c.y * var_9ed5c.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        var_2935c = false;
    }
    if (var_2935c || (var_407d1.w < 0.5))
    {
#endif
        discard;
    }
    highp vec4 var_15f8b = var_407d1;
    highp vec3 var_877b8 = var_15f8b.xyz * v_color0.xyz;
    var_407d1 = vec4(var_877b8.x, var_877b8.y, var_877b8.z, var_15f8b.w);
    highp vec4 var_390de = v_fog;
    bgfx_FragColor = vec4(mix(vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * var_877b8.xyz, var_407d1.w).xyz, FogColor.xyz, vec3(var_390de.w)), var_407d1.w);
}
