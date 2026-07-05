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
float var_8909c;
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
in highp vec2 v_ditheringAndMaskTinting;
in highp vec4 v_fog;
in highp vec2 v_lightmapUV;
centroid in highp vec2 v_texcoord0;
flat in highp vec2 v_textureShift;
#ifdef DITHERING__ON
in highp vec4 v_worldPosition;
#endif
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_3f821 = v_color0;
    highp vec2 var_558f1 = v_textureShift;
    int var_ec921 = int(var_558f1.y * 65535.0);
    highp vec2 var_571c5 = v_texcoord0;
    highp vec2 var_97eb7 = v_ditheringAndMaskTinting;
    highp vec4 var_78375 = mix(texture(s_MatTexture, vec2(var_571c5.x + var_95f1f.TextureShiftBufferData[var_ec921].preUV0, var_571c5.y + var_95f1f.TextureShiftBufferData[var_ec921].preUV1)), texture(s_MatTexture, vec2(var_571c5.x + var_95f1f.TextureShiftBufferData[var_ec921].postUV0, var_571c5.y + var_95f1f.TextureShiftBufferData[var_ec921].postUV1)), vec4(clamp((var_95f1f.TextureShiftBufferData[var_ec921].globalAlpha - ((1.0 - var_95f1f.TextureShiftBufferData[var_ec921].localShiftLength) * var_558f1.x)) / var_95f1f.TextureShiftBufferData[var_ec921].localShiftLength, 0.0, 1.0)));
    if (var_97eb7.y > 0.5)
    {
        highp vec3 var_5e4d7 = mix(var_78375.xyz, var_78375.xyz * v_color0.xyz, vec3(var_78375.w)).xyz * var_3f821.w;
        var_78375 = vec4(var_5e4d7.x, var_5e4d7.y, var_5e4d7.z, var_78375.w);
        var_78375.w = 1.0;
    }
    else
    {
        highp vec3 var_55928 = var_78375.xyz * v_color0.xyz;
        var_78375 = vec4(var_55928.x, var_55928.y, var_55928.z, var_78375.w);
        var_78375.w *= var_3f821.w;
    }
#ifdef DITHERING__ON
    highp vec2 var_8dad0 = DitherParams2[2].xy;
    if (var_97eb7.x > 0.5)
    {
        highp mat4 var_06d92 = u_view;
        highp vec4 var_bb748 = v_clipPosition;
        highp vec2 var_b2538 = floor(((((v_clipPosition.xyz / vec3(var_bb748.w)).xy * 0.5) + vec2(0.5)) * DitherParams.xy) / vec2(DitherParams2[2].z)) * DitherParams2[2].z;
        highp vec2 var_ea24e = floor(var_b2538 * 0.25);
        highp vec2 var_ff607 = floor(var_b2538 * 0.5);
        highp vec2 var_0a695 = floor(var_b2538);
        if (smoothstep(var_8dad0.x, var_8dad0.y, dot(-normalize(vec4(var_06d92[0].z, var_06d92[1].z, var_06d92[2].z, var_8909c).xyz), v_worldPosition.xyz - ViewPositionAndTime.xyz)) <= (((((((fract((var_ea24e.x * 0.5) + ((var_ea24e.y * var_ea24e.y) * 0.75)) * 0.25) + fract((var_ff607.x * 0.5) + ((var_ff607.y * var_ff607.y) * 0.75))) * 0.25) + fract((var_0a695.x * 0.5) + ((var_0a695.y * var_0a695.y) * 0.75))) * 64.0) + 0.5) * 0.015625))
        {
            var_78375.w = 0.0;
        }
    }
#endif
    highp vec4 var_390de = v_fog;
    bgfx_FragColor = vec4(mix(vec4(texture(s_LightMapTexture, v_lightmapUV).xyz * var_78375.xyz, var_78375.w).xyz, FogColor.xyz, vec3(var_390de.w)), var_78375.w);
}
