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
layout(binding = 3, std430) buffer s_TextureShiftBufferData { TextureShiftBuffer TextureShiftBufferData[]; } var_aed23;
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
void func_58137(inout highp vec4 arg_fe7bd, inout bool arg_6899a) {
    if ((arg_fe7bd.w <= 0.0) || (arg_fe7bd.w >= 1.0))
    {
        arg_6899a = arg_fe7bd.w <= 0.0;
        return;
    }
    arg_6899a = arg_fe7bd.w <= fract(52.98291778564453125 * fract(dot(floor((((v_clipPosition.xyz / vec3(v_clipPosition.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) * 1.0, vec2(0.067110560834407806396484375, 0.005837149918079376220703125))));
}
void main() {
    int var_72bf8 = int(v_textureShift.y * 65535.0);
    highp float var_c14e1;
    func_5f93d(var_72bf8, var_c14e1);
    highp vec4 var_4a86e = texture(s_MatTexture, vec2(v_texcoord0.x + var_aed23.TextureShiftBufferData[var_72bf8].preUV0, v_texcoord0.y + var_aed23.TextureShiftBufferData[var_72bf8].preUV1));
    highp vec4 var_c699e = texture(s_MatTexture, vec2(v_texcoord0.x + var_aed23.TextureShiftBufferData[var_72bf8].postUV0, v_texcoord0.y + var_aed23.TextureShiftBufferData[var_72bf8].postUV1));
    highp vec4 var_b757a = var_4a86e;
    highp vec4 var_78b1e = var_c699e;
    highp float var_b2499 = var_c14e1 * var_78b1e.w;
    highp float var_01f5d = ((1.0 - var_c14e1) * var_b757a.w) + var_b2499;
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
        highp float var_cdc5d = clamp(var_c14e1 * 4.0, 0.0, 1.0);
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
    highp vec4 var_fbb16 = vec4(mix(var_4a86e.xyz, var_c699e.xyz, vec3(var_051ec)), var_9e295);
    bool var_8ed6d;
    func_58137(var_fbb16, var_8ed6d);
    var_fbb16.w = var_8ed6d ? 0.0 : 1.0;
    highp vec4 var_4491d = var_fbb16;
#ifdef DITHERING__OFF
    if (false || (var_4491d.w < 0.5))
#endif
#ifdef DITHERING__ON
    highp vec2 var_42b21 = DitherParams2[2].xy;
    bool var_2935c;
    if (v_ditheringAndMaskTinting.x > 0.5)
#endif
    {
#ifdef DITHERING__ON
        highp mat4 var_4228f = u_view;
        highp vec2 var_9b116 = floor(((((v_clipPosition.xyz / vec3(v_clipPosition.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[2].z)) * DitherParams2[2].z;
        highp vec2 var_765a5 = floor(var_9b116 * 0.25);
        highp vec2 var_9b96b = floor(var_9b116 * 0.5);
        highp vec2 var_9ed5c = floor(var_9b116);
        var_2935c = smoothstep(var_42b21.x, var_42b21.y, dot(-normalize(vec4(var_4228f[0].z, var_4228f[1].z, var_4228f[2].z, var_466e6).xyz), v_worldPosition.xyz - ViewPositionAndTime.xyz)) <= (((((((fract((var_765a5.x * 0.5) + ((var_765a5.y * var_765a5.y) * 0.75)) * 0.25) + fract((var_9b96b.x * 0.5) + ((var_9b96b.y * var_9b96b.y) * 0.75))) * 0.25) + fract((var_9ed5c.x * 0.5) + ((var_9ed5c.y * var_9ed5c.y) * 0.75))) * 64.0) + 0.5) * 0.015625);
    }
    else
    {
        var_2935c = false;
    }
    if (var_2935c || (var_4491d.w < 0.5))
    {
#endif
        discard;
    }
    highp vec4 var_1179b = var_4491d;
    highp vec3 var_d7803 = var_1179b.xyz * v_color0.xyz;
    var_4491d.x = var_d7803.x;
    var_4491d.y = var_d7803.y;
    var_4491d.z = var_d7803.z;
    highp vec4 var_49453 = vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * var_4491d.xyz, var_4491d.w);
    highp vec4 var_72c1b = var_49453;
    highp vec3 var_8a63e = mix(var_49453.xyz, FogColor.xyz, vec3(v_fog.w));
    var_72c1b.x = var_8a63e.x;
    var_72c1b.y = var_8a63e.y;
    var_72c1b.z = var_8a63e.z;
    bgfx_FragData0 = var_72c1b;
}
