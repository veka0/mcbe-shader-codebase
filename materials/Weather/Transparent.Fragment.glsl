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
void func_7355d(inout highp vec2 arg_f694b) {
    highp vec4 loc_175e8 = texture(s_OcclusionTexture, v_occlusionUV);
    highp float loc_7116a = loc_175e8.x;
    highp float loc_2c54e = (loc_175e8.y + (loc_175e8.z * 255.0)) - (OcclusionHeightOffset.x * 0.0039215688593685626983642578125);
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
    if (loc_1a0b7 && (v_occlusionHeight < loc_2c54e))
    {
        arg_f694b = vec2(0.0);
        return;
    }
    else
    {
        arg_f694b = vec2(loc_7116a - (((v_occlusionHeight - loc_2c54e) * 25.0) * loc_7116a), 1.0);
        return;
    }
}
#endif
#ifdef NO_OCCLUSION__ON
void func_2e092(inout highp vec2 arg_003d1) {
    highp vec4 loc_6e6a0 = texture(s_OcclusionTexture, v_occlusionUV);
    highp float loc_a92e4 = loc_6e6a0.x;
    arg_003d1 = vec2(loc_a92e4 - (((v_occlusionHeight - ((loc_6e6a0.y + (loc_6e6a0.z * 255.0)) - (OcclusionHeightOffset.x * 0.0039215688593685626983642578125))) * 25.0) * loc_a92e4), 1.0);
}
#endif
#if defined(FLIP_OCCLUSION__ON) && defined(NO_OCCLUSION__OFF)
void func_195f6(inout highp vec2 arg_f694b) {
    highp vec4 loc_175e8 = texture(s_OcclusionTexture, v_occlusionUV);
    highp float loc_7116a = loc_175e8.x;
    highp float loc_c2c30 = (loc_175e8.y + (loc_175e8.z * 255.0)) - (OcclusionHeightOffset.x * 0.0039215688593685626983642578125);
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
    if (loc_65342 && (v_occlusionHeight > loc_c2c30))
    {
        arg_f694b = vec2(0.0);
        return;
    }
    else
    {
        arg_f694b = vec2(loc_7116a - (((v_occlusionHeight - loc_c2c30) * 25.0) * loc_7116a), 1.0);
        return;
    }
}
#endif
void main() {
#ifdef NO_OCCLUSION__OFF
    highp vec4 var_de9a8 = texture(s_WeatherTexture, v_texcoord0);
#endif
    highp vec2 var_3e492;
#if defined(FLIP_OCCLUSION__OFF) && defined(NO_OCCLUSION__OFF)
    func_7355d(var_3e492);
#endif
#ifdef NO_OCCLUSION__ON
    highp vec4 var_de9a8 = texture(s_WeatherTexture, v_texcoord0);
    func_2e092(var_3e492);
#endif
#if defined(FLIP_OCCLUSION__ON) && defined(NO_OCCLUSION__OFF)
    func_195f6(var_3e492);
#endif
    highp vec2 var_7e6be = var_3e492;
    highp vec4 var_66861 = var_de9a8;
    highp vec3 var_035d8 = var_66861.xyz * texture(s_LightingTexture, var_3e492).xyz;
    var_de9a8 = vec4(var_035d8.x, var_035d8.y, var_035d8.z, var_66861.w);
    highp vec4 var_a82ec = vec4(var_035d8, var_de9a8.w * var_7e6be.y);
    highp vec4 var_6ca24 = v_fog;
    highp vec3 var_14685 = mix(var_a82ec.xyz, v_fog.xyz, vec3(var_6ca24.w));
    bgfx_FragColor = vec4(var_14685.x, var_14685.y, var_14685.z, var_a82ec.w);
}
