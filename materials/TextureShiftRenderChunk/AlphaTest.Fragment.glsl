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

#ifdef DITHERING__ON
float var_466e6;
#endif
layout(binding = 3, std430) buffer s_TextureShiftBufferData { TextureShiftBuffer TextureShiftBufferData[]; } var_803cb;
#ifdef DITHERING__ON
uniform highp mat4 u_view;
#endif
uniform highp sampler2D s_LightMapTexture;
uniform highp sampler2D s_MatTexture;
#ifdef DITHERING__ON
uniform highp vec4 DitherParams2[3];
#endif
uniform highp vec4 DitherParams;
uniform highp vec4 FogColor;
#ifdef DITHERING__ON
uniform highp vec4 ViewPositionAndTime;
#endif
in highp vec4 v_clipPosition;
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
layout(location = 0) out highp vec4 bgfx_FragData0;
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
void func_c5ced(inout highp vec4 arg_909f3, inout bool arg_d6663) {
    if ((arg_909f3.w <= 0.0) || (arg_909f3.w >= 1.0))
    {
        arg_d6663 = arg_909f3.w <= 0.0;
        return;
    }
    highp vec4 loc_de7d3 = v_clipPosition;
    arg_d6663 = arg_909f3.w <= fract(52.98291778564453125 * fract(dot(floor((((v_clipPosition.xyz / vec3(loc_de7d3.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) * 1.0, vec2(0.067110560834407806396484375, 0.005837149918079376220703125))));
}
void main() {
    highp vec2 var_1614a = v_textureShift;
    int var_d0c42 = int(var_1614a.y * 65535.0);
    highp float var_c18c9;
    func_f1932(var_1614a, var_d0c42, var_c18c9);
    highp vec2 var_f486c = v_texcoord0;
    highp vec4 var_4b671 = texture(s_MatTexture, vec2(var_f486c.x + var_803cb.TextureShiftBufferData[var_d0c42].preUV0, var_f486c.y + var_803cb.TextureShiftBufferData[var_d0c42].preUV1));
    highp vec4 var_2e873 = texture(s_MatTexture, vec2(var_f486c.x + var_803cb.TextureShiftBufferData[var_d0c42].postUV0, var_f486c.y + var_803cb.TextureShiftBufferData[var_d0c42].postUV1));
    highp vec4 var_b757a = var_4b671;
    highp vec4 var_78b1e = var_2e873;
    highp float var_b2499 = var_c18c9 * var_78b1e.w;
    highp float var_01f5d = ((1.0 - var_c18c9) * var_b757a.w) + var_b2499;
    highp float var_051ec;
    if (var_01f5d > 0.0)
    {
        var_051ec = var_b2499 / var_01f5d;
    }
    else
    {
        var_051ec = 0.0;
    }
    bool var_bd722 = var_b757a.w >= 0.5;
    bool var_84047 = var_78b1e.w >= 0.5;
    highp float var_9e295;
    if (var_bd722 == var_84047)
    {
        var_9e295 = float(var_bd722);
    }
    else
    {
        highp float var_cdc5d = clamp(var_c18c9 * 4.0, 0.0, 1.0);
        highp float var_dc0f1;
        if (var_84047)
        {
            var_dc0f1 = var_cdc5d;
        }
        else
        {
            var_dc0f1 = 1.0 - var_cdc5d;
        }
        var_9e295 = var_dc0f1;
    }
    highp vec4 var_fbb16 = vec4(mix(var_4b671.xyz, var_2e873.xyz, vec3(var_051ec)), var_9e295);
    bool var_8ed6d;
    func_c5ced(var_fbb16, var_8ed6d);
    var_fbb16.w = var_8ed6d ? 0.0 : 1.0;
#ifdef DITHERING__ON
    highp vec2 var_4f8e7 = v_ditheringAndMaskTinting;
#endif
    highp vec4 var_bf701 = var_fbb16;
#ifdef DITHERING__OFF
    if (false || (var_bf701.w < 0.5))
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
    if (var_2935c || (var_bf701.w < 0.5))
    {
#endif
        discard;
    }
    highp vec4 var_15f8b = var_bf701;
    highp vec3 var_47b05 = var_15f8b.xyz * v_color0.xyz;
    var_bf701 = vec4(var_47b05.x, var_47b05.y, var_47b05.z, var_15f8b.w);
    highp vec4 var_713a6 = v_fog;
    bgfx_FragData0 = vec4(mix(vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * var_47b05.xyz, var_bf701.w).xyz, FogColor.xyz, vec3(var_713a6.w)), var_bf701.w);
}
