#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* FlipOcclusion:
* - FLIP_OCCLUSION__OFF
* - FLIP_OCCLUSION__ON
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* NoOcclusion:
* - NO_OCCLUSION__OFF
* - NO_OCCLUSION__ON
*
* NoVariety:
* - NO_VARIETY__OFF (not used)
* - NO_VARIETY__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_LightingTexture;
* - uniform lowp sampler2D s_OcclusionTexture;
* - uniform lowp sampler2D s_WeatherTexture;
*
* Uniforms:
* - uniform vec4 Dimensions;
* - uniform vec4 FogAndDistanceControl;
* - uniform vec4 FogColor;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MaterialID;
* - uniform vec4 OcclusionHeightOffset;
* - uniform vec4 PositionBaseOffset;
* - uniform vec4 PositionForwardOffset;
* - uniform vec4 PrevPositionBaseOffset;
* - uniform vec4 PrevPositionForwardOffset;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 UVOffsetAndScale;
* - uniform vec4 Velocity;
* - uniform vec4 ViewPosition;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_LightingTexture;
uniform highp sampler2D s_OcclusionTexture;
uniform highp sampler2D s_WeatherTexture;
uniform highp vec4 OcclusionHeightOffset;
in highp vec4 v_fog;
in highp float v_occlusionHeight;
in highp vec2 v_occlusionUV;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
#if defined(FLIP_OCCLUSION__OFF) && defined(NO_OCCLUSION__OFF)
void func_73dd7(inout highp vec2 arg_0a9f5) {
    highp vec4 loc_175e8 = texture(s_OcclusionTexture, v_occlusionUV);
    highp float loc_fd51f = loc_175e8.x;
    highp float loc_5dbf2 = (loc_175e8.y + (loc_175e8.z * 255.0)) - (OcclusionHeightOffset.x * 0.0039215688593685626983642578125);
    bool loc_47b39 = v_occlusionUV.x >= 0.0;
    bool loc_77737;
    if (loc_47b39)
    {
        loc_77737 = v_occlusionUV.x <= 1.0;
    }
    else
    {
        loc_77737 = loc_47b39;
    }
    bool loc_8f253;
    if (loc_77737)
    {
        loc_8f253 = v_occlusionUV.y >= 0.0;
    }
    else
    {
        loc_8f253 = loc_77737;
    }
    bool loc_1a0b7;
    if (loc_8f253)
    {
        loc_1a0b7 = v_occlusionUV.y <= 1.0;
    }
    else
    {
        loc_1a0b7 = loc_8f253;
    }
    if (loc_1a0b7 && (v_occlusionHeight < loc_5dbf2))
    {
        arg_0a9f5 = vec2(0.0);
        return;
    }
    else
    {
        arg_0a9f5 = vec2(clamp(loc_fd51f - (((v_occlusionHeight - loc_5dbf2) * 25.0) * loc_fd51f), 0.0, 1.0), 1.0);
        return;
    }
}
#endif
#ifdef NO_OCCLUSION__ON
void func_b79af(inout highp vec2 arg_c6309) {
    highp vec4 loc_afabb = texture(s_OcclusionTexture, v_occlusionUV);
    highp float loc_97536 = loc_afabb.x;
    arg_c6309 = vec2(clamp(loc_97536 - (((v_occlusionHeight - ((loc_afabb.y + (loc_afabb.z * 255.0)) - (OcclusionHeightOffset.x * 0.0039215688593685626983642578125))) * 25.0) * loc_97536), 0.0, 1.0), 1.0);
}
#endif
#if defined(FLIP_OCCLUSION__ON) && defined(NO_OCCLUSION__OFF)
void func_f0c66(inout highp vec2 arg_0a9f5) {
    highp vec4 loc_175e8 = texture(s_OcclusionTexture, v_occlusionUV);
    highp float loc_fd51f = loc_175e8.x;
    highp float loc_15941 = (loc_175e8.y + (loc_175e8.z * 255.0)) - (OcclusionHeightOffset.x * 0.0039215688593685626983642578125);
    bool loc_47b39 = v_occlusionUV.x >= 0.0;
    bool loc_77737;
    if (loc_47b39)
    {
        loc_77737 = v_occlusionUV.x <= 1.0;
    }
    else
    {
        loc_77737 = loc_47b39;
    }
    bool loc_8f253;
    if (loc_77737)
    {
        loc_8f253 = v_occlusionUV.y >= 0.0;
    }
    else
    {
        loc_8f253 = loc_77737;
    }
    bool loc_65342;
    if (loc_8f253)
    {
        loc_65342 = v_occlusionUV.y <= 1.0;
    }
    else
    {
        loc_65342 = loc_8f253;
    }
    if (loc_65342 && (v_occlusionHeight > loc_15941))
    {
        arg_0a9f5 = vec2(0.0);
        return;
    }
    else
    {
        arg_0a9f5 = vec2(clamp(loc_fd51f - (((v_occlusionHeight - loc_15941) * 25.0) * loc_fd51f), 0.0, 1.0), 1.0);
        return;
    }
}
#endif
void main() {
#ifdef NO_OCCLUSION__OFF
    highp vec4 var_2ffec = texture(s_WeatherTexture, v_texcoord0);
#endif
    highp vec2 var_3e492;
#if defined(FLIP_OCCLUSION__OFF) && defined(NO_OCCLUSION__OFF)
    func_73dd7(var_3e492);
#endif
#ifdef NO_OCCLUSION__ON
    highp vec4 var_2ffec = texture(s_WeatherTexture, v_texcoord0);
    func_b79af(var_3e492);
#endif
#if defined(FLIP_OCCLUSION__ON) && defined(NO_OCCLUSION__OFF)
    func_f0c66(var_3e492);
#endif
    highp vec2 var_cbd4c = var_3e492;
    highp vec4 var_66861 = var_2ffec;
    highp vec3 var_97ad4 = var_66861.xyz * texture(s_LightingTexture, var_3e492).xyz;
    var_2ffec = vec4(var_97ad4.x, var_97ad4.y, var_97ad4.z, var_66861.w);
    highp float var_f4bd6 = var_2ffec.w * var_cbd4c.y;
    highp vec4 var_16b44 = v_fog;
    bgfx_FragColor = vec4(mix(vec4(var_97ad4, var_f4bd6).xyz, v_fog.xyz, vec3(var_16b44.w)), var_f4bd6);
}
