#version 310 es

/*
* Available Macros:
*
* Passes:
* - FALLBACK_PASS (not used)
* - TAAU_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_InputBufferMotionVectors;
* - uniform lowp sampler2D s_InputFinalColor;
* - uniform lowp sampler2D s_InputTAAHistory;
*
* Uniforms:
* - uniform mat4 CurrentViewProjectionMatrixUniform;
* - uniform vec4 CurrentWorldOrigin;
* - uniform vec4 DisplayResolution;
* - uniform mat4 PreviousViewProjectionMatrixUniform;
* - uniform vec4 PreviousWorldOrigin;
* - uniform vec4 RecipDisplayResolution;
* - uniform vec4 RenderResolution;
* - uniform vec4 ResolutionRatiosAndFPEpsilon;
* - uniform vec4 SubPixelJitter;
* - uniform vec4 TAAUpscalingParameters;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_InputBufferMotionVectors;
uniform highp sampler2D s_InputFinalColor;
uniform highp sampler2D s_InputTAAHistory;
uniform highp vec4 DisplayResolution;
uniform highp vec4 RecipDisplayResolution;
uniform highp vec4 RenderResolution;
uniform highp vec4 ResolutionRatiosAndFPEpsilon;
uniform highp vec4 SubPixelJitter;
uniform highp vec4 TAAUpscalingParameters;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec2 var_c0f1b = DisplayResolution.xy * v_texcoord0;
    uint var_c27a1 = uint(var_c0f1b.x);
    uint var_1463d = uint(var_c0f1b.y);
    highp vec2 var_55832 = ((vec2(float(var_c27a1) + 0.5, float(var_1463d) + 0.5) * ResolutionRatiosAndFPEpsilon.x) - vec2(SubPixelJitter.x, -SubPixelJitter.y)) - vec2(0.5);
    highp vec2 var_56e6a = var_55832;
    ivec2 var_2c3be = ivec2(int(round(var_56e6a.x)), int(round(var_56e6a.y)));
    highp vec4 var_b18e6 = texelFetch(s_InputFinalColor, var_2c3be, 0);
    highp vec2 var_eab04;
    highp vec3 var_01fa5;
    highp vec3 var_24173;
    var_24173 = var_b18e6.xyz * var_b18e6.xyz;
    var_01fa5 = var_b18e6.xyz;
    var_eab04 = texelFetch(s_InputBufferMotionVectors, var_2c3be, 0).zw;
    highp vec3 var_c3970;
    highp vec3 var_268f2;
    highp vec2 var_b75b3;
    for (int var_66671 = -1; var_66671 <= 1; var_24173 = var_268f2, var_01fa5 = var_c3970, var_eab04 = var_b75b3, var_66671++)
    {
        var_b75b3 = var_eab04;
        var_268f2 = var_24173;
        var_c3970 = var_01fa5;
        highp vec3 var_671cd;
        highp vec3 var_74095;
        highp vec2 var_cbc1b;
        for (int var_59d8a = -1; var_59d8a <= 1; var_b75b3 = var_cbc1b, var_268f2 = var_74095, var_c3970 = var_671cd, var_59d8a++)
        {
            if ((var_66671 == 0) && (var_59d8a == 0))
            {
                var_cbc1b = var_b75b3;
                var_74095 = var_268f2;
                var_671cd = var_c3970;
                continue;
            }
            ivec2 var_07969 = var_2c3be + ivec2(var_66671, var_59d8a);
            highp vec3 var_4da2f = texelFetch(s_InputFinalColor, var_07969, 0).xyz;
            highp vec2 var_05872 = texelFetch(s_InputBufferMotionVectors, var_07969, 0).zw;
            highp vec2 var_b8c0f;
            if (TAAUpscalingParameters.w != 0.0)
            {
                highp vec2 var_c3c98;
                if (dot(var_05872, var_05872) > dot(var_b75b3, var_b75b3))
                {
                    var_c3c98 = var_05872;
                }
                else
                {
                    var_c3c98 = var_b75b3;
                }
                var_b8c0f = var_c3c98;
            }
            else
            {
                var_b8c0f = var_b75b3;
            }
            var_cbc1b = var_b8c0f;
            var_74095 = var_268f2 + (var_4da2f * var_4da2f);
            var_671cd = var_c3970 + var_4da2f;
        }
    }
    highp vec2 var_6a6cb = var_eab04 * RenderResolution.xy;
    highp vec3 var_9ea21 = var_01fa5 * vec3(0.111111111938953399658203125);
    highp vec3 var_15974 = sqrt(max(vec3(0.0), (var_24173 * vec3(0.111111111938953399658203125)) - (var_9ea21 * var_9ea21)));
    highp float var_8954e = smoothstep(0.0, 1.0, sqrt(dot(var_6a6cb, var_6a6cb)));
    highp float var_80b18 = mix(TAAUpscalingParameters.y, TAAUpscalingParameters.x, var_8954e);
    highp vec3 var_5ae17 = var_9ea21 - (var_15974 * var_80b18);
    highp vec3 var_ad110 = var_9ea21 + (var_15974 * var_80b18);
    highp vec2 var_589d9 = clamp(vec2(float(var_c27a1) + 0.5, float(var_1463d) + 0.5) - (var_6a6cb * ResolutionRatiosAndFPEpsilon.y), vec2(0.0), DisplayResolution.xy - vec2(1.0));
    highp vec2 var_fc97f = floor(var_589d9 - vec2(0.5));
    highp vec2 var_dcdb2 = var_fc97f + vec2(0.5);
    highp vec2 var_23409 = clamp(var_589d9 - var_dcdb2, vec2(0.0), vec2(1.0));
    highp vec2 var_57836 = var_23409 * var_23409;
    highp vec2 var_571fa = var_57836 * var_23409;
    highp vec2 var_d4010 = var_57836 - ((var_571fa + var_23409) * 0.5);
    highp vec2 var_c1a04 = var_d4010;
    highp vec2 var_4024f = ((var_571fa * 1.5) - (var_57836 * 2.5)) + vec2(1.0);
    highp vec2 var_9857d = (var_571fa - var_57836) * 0.5;
    highp vec2 var_a1d94 = var_9857d;
    highp vec2 var_dd35c = ((vec2(1.0) - var_d4010) - var_4024f) - var_9857d;
    highp vec2 var_3c8bb = var_4024f + var_dd35c;
    highp vec2 var_7ed75 = var_3c8bb;
    highp vec2 var_6032f = (var_fc97f + vec2(-0.5)) * RecipDisplayResolution.xy;
    highp vec2 var_93a5a = (var_dcdb2 + (var_dd35c / var_3c8bb)) * RecipDisplayResolution.xy;
    highp vec2 var_3e506 = (var_fc97f + vec2(2.5)) * RecipDisplayResolution.xy;
    highp vec3 var_99678 = max(vec3(0.0), ((((((((textureLod(s_InputTAAHistory, vec2(var_6032f.x, var_6032f.y), 0.0).xyz * (var_c1a04.x * var_c1a04.y)) + (textureLod(s_InputTAAHistory, vec2(var_6032f.x, var_93a5a.y), 0.0).xyz * (var_c1a04.x * var_7ed75.y))) + (textureLod(s_InputTAAHistory, vec2(var_6032f.x, var_3e506.y), 0.0).xyz * (var_c1a04.x * var_a1d94.y))) + (textureLod(s_InputTAAHistory, vec2(var_93a5a.x, var_6032f.y), 0.0).xyz * (var_7ed75.x * var_c1a04.y))) + (textureLod(s_InputTAAHistory, vec2(var_93a5a.x, var_93a5a.y), 0.0).xyz * (var_7ed75.x * var_7ed75.y))) + (textureLod(s_InputTAAHistory, vec2(var_93a5a.x, var_3e506.y), 0.0).xyz * (var_7ed75.x * var_a1d94.y))) + (textureLod(s_InputTAAHistory, vec2(var_3e506.x, var_6032f.y), 0.0).xyz * (var_a1d94.x * var_c1a04.y))) + (textureLod(s_InputTAAHistory, vec2(var_3e506.x, var_93a5a.y), 0.0).xyz * (var_a1d94.x * var_7ed75.y))) + (textureLod(s_InputTAAHistory, vec2(var_3e506.x, var_3e506.y), 0.0).xyz * (var_a1d94.x * var_a1d94.y)));
    highp vec3 var_aae60;
    if (TAAUpscalingParameters.z != 0.0)
    {
        bool var_5b456 = any(greaterThan(var_99678, var_ad110));
        bool var_4b3a6;
        if (!var_5b456)
        {
            var_4b3a6 = any(lessThan(var_99678, var_5ae17));
        }
        else
        {
            var_4b3a6 = var_5b456;
        }
        highp vec3 var_a4d0b;
        if (var_4b3a6)
        {
            highp vec3 var_bc1a4 = var_5ae17;
            highp vec3 var_263c9 = var_ad110;
            highp vec3 var_16c6d = var_99678;
            highp vec3 var_2b95b = var_b18e6.xyz - var_99678;
            highp vec3 var_699c1 = var_2b95b;
            highp float var_7747b = length(var_2b95b);
            if (var_7747b > 0.0)
            {
                var_699c1 = vec3(var_699c1.x / var_7747b, var_699c1.y / var_7747b, var_699c1.z / var_7747b);
            }
            bool var_8d824;
            highp float var_b6607;
            highp float var_10f5f;
            var_10f5f = 65000.0;
            var_b6607 = -65000.0;
            var_8d824 = false;
            bool var_f99c7;
            highp float var_740b8;
            highp float var_ce0e0;
            for (int var_8e22d = 0; var_8e22d < 3; var_10f5f = var_ce0e0, var_b6607 = var_740b8, var_8d824 = var_f99c7, var_8e22d++)
            {
                if (abs(var_699c1[var_8e22d]) > ResolutionRatiosAndFPEpsilon.z)
                {
                    highp float var_94a82 = (var_bc1a4[var_8e22d] - var_16c6d[var_8e22d]) / var_699c1[var_8e22d];
                    highp float var_97502 = (var_263c9[var_8e22d] - var_16c6d[var_8e22d]) / var_699c1[var_8e22d];
                    highp float var_164d2;
                    highp float var_8e57d;
                    if (var_94a82 > var_97502)
                    {
                        var_8e57d = var_94a82;
                        var_164d2 = var_97502;
                    }
                    else
                    {
                        var_8e57d = var_97502;
                        var_164d2 = var_94a82;
                    }
                    highp float var_cf6be;
                    if (var_164d2 > var_b6607)
                    {
                        var_cf6be = var_164d2;
                    }
                    else
                    {
                        var_cf6be = var_b6607;
                    }
                    highp float var_0bef8;
                    if (var_8e57d < var_10f5f)
                    {
                        var_0bef8 = var_8e57d;
                    }
                    else
                    {
                        var_0bef8 = var_10f5f;
                    }
                    bool var_fc26e;
                    if (var_cf6be > var_0bef8)
                    {
                        var_fc26e = true;
                    }
                    else
                    {
                        var_fc26e = var_8d824;
                    }
                    bool var_e474c;
                    if (var_0bef8 < 0.0)
                    {
                        var_e474c = true;
                    }
                    else
                    {
                        var_e474c = var_fc26e;
                    }
                    var_ce0e0 = var_0bef8;
                    var_740b8 = var_cf6be;
                    var_f99c7 = var_e474c;
                }
                else
                {
                    bool var_5f5a1 = var_16c6d[var_8e22d] < var_bc1a4[var_8e22d];
                    bool var_930e1;
                    if (!var_5f5a1)
                    {
                        var_930e1 = var_16c6d[var_8e22d] > var_263c9[var_8e22d];
                    }
                    else
                    {
                        var_930e1 = var_5f5a1;
                    }
                    bool var_298f7;
                    if (var_930e1)
                    {
                        var_298f7 = true;
                    }
                    else
                    {
                        var_298f7 = var_8d824;
                    }
                    var_ce0e0 = var_10f5f;
                    var_740b8 = var_b6607;
                    var_f99c7 = var_298f7;
                }
            }
            highp vec3 var_eda31;
            if (!var_8d824)
            {
                highp vec3 var_1f3f4;
                if (var_b6607 > 0.0)
                {
                    var_1f3f4 = var_99678 + (var_699c1 * vec3(var_b6607));
                }
                else
                {
                    var_1f3f4 = var_99678 + (var_699c1 * vec3(var_10f5f));
                }
                var_eda31 = var_1f3f4;
            }
            else
            {
                var_eda31 = min(var_ad110, max(var_5ae17, var_99678));
            }
            var_a4d0b = var_eda31;
        }
        else
        {
            var_a4d0b = var_99678;
        }
        var_aae60 = var_a4d0b;
    }
    else
    {
        var_aae60 = min(var_ad110, max(var_5ae17, var_99678));
    }
    highp vec2 var_60f23 = var_55832 - vec2(var_2c3be);
    bgfx_FragColor = vec4(mix(var_aae60, var_b18e6.xyz, vec3(max(var_8954e, clamp(1.0 - (ResolutionRatiosAndFPEpsilon.y * dot(var_60f23, var_60f23)), 0.0500000007450580596923828125, 1.0)) * 0.100000001490116119384765625)), 0.0);
}
