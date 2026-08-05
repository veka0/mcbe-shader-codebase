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
void func_5336b(inout uvec4 arg_a0805, inout highp vec2 arg_31df6) {
    highp float loc_519df = float(arg_a0805.z & 15u) * 0.066666670143604278564453125;
    highp float loc_1d09f = (float((arg_a0805.x | (arg_a0805.y << 8u)) & 1023u) + OcclusionHeightOffset.x) * 0.0039215688593685626983642578125;
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
    if (loc_1a0b7 && (v_occlusionHeight < loc_1d09f))
    {
        arg_31df6 = vec2(0.0);
        return;
    }
    else
    {
        arg_31df6 = vec2(loc_519df - (clamp((v_occlusionHeight - loc_1d09f) * 25.0, 0.0, 1.0) * loc_519df), 1.0);
        return;
    }
}
#endif
#ifdef NO_OCCLUSION__ON
void func_0e12e(inout uvec4 arg_adc9f, inout highp vec2 arg_a9ce0) {
    highp float loc_9a9ec = float(arg_adc9f.z & 15u) * 0.066666670143604278564453125;
    arg_a9ce0 = vec2(loc_9a9ec - (clamp((v_occlusionHeight - ((float((arg_adc9f.x | (arg_adc9f.y << 8u)) & 1023u) + OcclusionHeightOffset.x) * 0.0039215688593685626983642578125)) * 25.0, 0.0, 1.0) * loc_9a9ec), 1.0);
}
#endif
#if defined(FLIP_OCCLUSION__ON) && defined(NO_OCCLUSION__OFF)
void func_398ee(inout uvec4 arg_a0805, inout highp vec2 arg_31df6) {
    highp float loc_519df = float(arg_a0805.z & 15u) * 0.066666670143604278564453125;
    highp float loc_a6050 = (float((arg_a0805.x | (arg_a0805.y << 8u)) & 1023u) + OcclusionHeightOffset.x) * 0.0039215688593685626983642578125;
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
    if (loc_65342 && (v_occlusionHeight > loc_a6050))
    {
        arg_31df6 = vec2(0.0);
        return;
    }
    else
    {
        arg_31df6 = vec2(loc_519df - (clamp((v_occlusionHeight - loc_a6050) * 25.0, 0.0, 1.0) * loc_519df), 1.0);
        return;
    }
}
#endif
void main() {
#ifdef NO_OCCLUSION__ON
    highp vec2 var_17770;
#endif
    highp vec4 var_59f74 = texture(s_WeatherTexture, v_texcoord0);
    highp vec4 var_e5cb6 = texture(s_OcclusionTexture, v_occlusionUV);
    uvec4 var_14d49 = uvec4(round(var_e5cb6 * 255.0));
#ifdef NO_OCCLUSION__OFF
    highp vec2 var_17770;
#endif
#if defined(FLIP_OCCLUSION__OFF) && defined(NO_OCCLUSION__OFF)
    func_5336b(var_14d49, var_17770);
#endif
#ifdef NO_OCCLUSION__ON
    func_0e12e(var_14d49, var_17770);
#endif
#if defined(FLIP_OCCLUSION__ON) && defined(NO_OCCLUSION__OFF)
    func_398ee(var_14d49, var_17770);
#endif
    highp vec2 var_cbd4c = var_17770;
    highp vec4 var_66861 = var_59f74;
    highp vec3 var_97ad4 = var_66861.xyz * texture(s_LightingTexture, var_17770).xyz;
    var_59f74 = vec4(var_97ad4.x, var_97ad4.y, var_97ad4.z, var_66861.w);
    highp float var_f4bd6 = var_59f74.w * var_cbd4c.y;
    highp vec4 var_16b44 = v_fog;
    bgfx_FragColor = vec4(mix(vec4(var_97ad4, var_f4bd6).xyz, v_fog.xyz, vec3(var_16b44.w)), var_f4bd6);
}
