#version 310 es

/*
* Available Macros:
*
* Passes:
* - SSR_FILL_GAPS_PASS (not used)
* - SSR_GET_REFLECTED_COLOR_PASS (not used)
* - SSR_RAY_MARCH_PASS (not used)
*
* ExtendedGapFill:
* - EXTENDED_GAP_FILL__OFF (not used)
* - EXTENDED_GAP_FILL__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_GbufferDepth;
* - uniform lowp sampler2D s_GbufferNormal;
* - uniform lowp usampler2D s_GbufferRoughness;
* - uniform lowp sampler2D s_InputTexture;
* - uniform lowp sampler2D s_PreviousReflectionBuffer;
* - uniform lowp sampler2D s_RasterColor;
*
* Uniforms:
* - uniform vec4 CameraData;
* - uniform vec4 SSRFadingParamsAndThickness;
* - uniform vec4 SSRRayMarchingParams;
* - uniform vec4 SSRRoughnessCutoffParams;
* - uniform vec4 SSRTemporalAccumulationParams;
* - uniform vec4 ScreenSize;
* - uniform vec4 UnitPlaneExtents;
* - uniform vec4 ViewportScale;
*/

precision mediump float;
precision highp int;
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_prevViewProj;
uniform highp sampler2D s_GbufferDepth;
uniform highp sampler2D s_InputTexture;
uniform highp sampler2D s_PreviousReflectionBuffer;
uniform highp sampler2D s_RasterColor;
uniform highp vec4 SSRTemporalAccumulationParams;
uniform highp vec4 ScreenSize;
uniform highp vec4 ViewportScale;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_afbc3 = texture(s_InputTexture, v_texcoord0.xy);
    highp vec4 var_6ae05 = var_afbc3;
    highp vec2 var_1fa6b = var_afbc3.xy;
    var_1fa6b = vec2(var_1fa6b.x, 1.0 - var_1fa6b.y);
    highp float var_c2b62 = var_1fa6b.x;
    highp float var_ace1a = var_1fa6b.y;
    highp vec2 var_56cc5 = vec2(var_c2b62, 1.0 - var_ace1a);
    var_1fa6b = var_56cc5;
    highp vec4 var_78434 = vec4((var_56cc5 * 2.0) - vec2(1.0), (texture(s_GbufferDepth, var_afbc3.xy).x * 2.0) - 1.0, 1.0);
    highp mat4 var_4fa47 = u_invProj;
    highp mat4 var_498b7 = u_invProj;
    highp mat4 var_4882d = u_invProj;
    highp mat4 var_78c1b = u_invProj;
    highp mat4 var_40575 = u_invProj;
    highp float var_eb413 = var_78434.x;
    highp float var_ac116 = var_78434.y;
    highp float var_f2b7c = var_78434.w;
    highp float var_0357c = var_78434.z;
    highp float var_2c821 = var_78434.w;
    highp vec4 var_9666f = vec4(var_eb413 * var_4fa47[0].x, var_ac116 * var_498b7[1].y, var_f2b7c * var_4882d[3].z, (var_0357c * var_78c1b[2].w) + (var_2c821 * var_40575[3].w));
    var_78434 = var_9666f;
    highp float var_d799e = var_78434.w;
    highp vec4 var_ecb7c = var_9666f / vec4(var_d799e);
    var_78434 = var_ecb7c;
    highp vec4 var_29b70 = u_prevViewProj * vec4((u_invView * vec4(var_ecb7c.xyz, 1.0)).xyz, 1.0);
    highp vec4 var_53e38 = var_29b70;
    highp vec2 var_c1944 = ((var_29b70.xyz / vec3(var_53e38.w)).xy + vec2(1.0)) * 0.5;
    var_c1944.y = 1.0 - var_c1944.y;
    highp vec4 var_f2a5f;
    if (var_6ae05.w >= 0.0)
    {
        var_f2a5f = vec4(texture(s_RasterColor, vec2(var_c1944.x, 1.0 - var_c1944.y)).xyz, var_6ae05.w);
    }
    else
    {
        var_f2a5f = vec4(0.0);
    }
    highp vec4 var_2ba0f;
    if (SSRTemporalAccumulationParams.x > 0.0)
    {
        highp vec2 var_26d5f = v_texcoord0.xy;
        var_26d5f = vec2(var_26d5f.x, 1.0 - var_26d5f.y);
        highp float var_236dd = var_26d5f.x;
        highp float var_44bd7 = var_26d5f.y;
        highp vec2 var_34a9c = vec2(var_236dd, 1.0 - var_44bd7);
        var_26d5f = var_34a9c;
        highp vec4 var_c013c = vec4((var_34a9c * 2.0) - vec2(1.0), (var_6ae05.z * 2.0) - 1.0, 1.0);
        highp mat4 var_66373 = u_invProj;
        highp mat4 var_27f4c = u_invProj;
        highp mat4 var_fb307 = u_invProj;
        highp mat4 var_622c9 = u_invProj;
        highp mat4 var_88001 = u_invProj;
        highp float var_a1967 = var_c013c.x;
        highp float var_ccc39 = var_c013c.y;
        highp float var_071ba = var_c013c.w;
        highp float var_55419 = var_c013c.z;
        highp float var_10bf4 = var_c013c.w;
        highp vec4 var_67b7b = vec4(var_a1967 * var_66373[0].x, var_ccc39 * var_27f4c[1].y, var_071ba * var_fb307[3].z, (var_55419 * var_622c9[2].w) + (var_10bf4 * var_88001[3].w));
        var_c013c = var_67b7b;
        highp float var_750bb = var_c013c.w;
        highp vec4 var_62835 = var_67b7b / vec4(var_750bb);
        var_c013c = var_62835;
        highp vec4 var_77040 = u_prevViewProj * vec4((u_invView * vec4(var_62835.xyz, 1.0)).xyz, 1.0);
        highp vec4 var_67609 = var_77040;
        highp vec2 var_68901 = ((var_77040.xyz / vec3(var_67609.w)).xy + vec2(1.0)) * 0.5;
        var_68901.y = 1.0 - var_68901.y;
        int var_6b3ea = int(SSRTemporalAccumulationParams.z);
        int var_08d17 = -var_6b3ea;
        highp vec4 var_a266f;
        highp float var_4a7a2;
        highp vec4 var_a0312;
        var_a0312 = vec4(0.0);
        var_4a7a2 = 0.0;
        var_a266f = vec4(0.0);
        highp float var_b7f64;
        highp vec4 var_c4779;
        highp vec4 var_8c126;
        for (int var_210f2 = var_08d17; var_210f2 <= var_6b3ea; var_a0312 = var_c4779, var_4a7a2 = var_b7f64, var_a266f = var_8c126, var_210f2++)
        {
            int var_f2c75 = -var_6b3ea;
            var_8c126 = var_a266f;
            var_c4779 = var_a0312;
            var_b7f64 = var_4a7a2;
            highp float var_84ace;
            highp vec4 var_25bbb;
            highp vec4 var_758f4;
            for (int var_371a7 = var_f2c75; var_371a7 <= var_6b3ea; var_8c126 = var_758f4, var_c4779 = var_25bbb, var_b7f64 = var_84ace, var_371a7++)
            {
                highp vec4 var_5d1fe = texture(s_InputTexture, v_texcoord0.xy + (vec2(float(var_210f2), float(var_371a7)) * ScreenSize.zw));
                highp vec4 var_4e5f5 = var_5d1fe;
                highp vec4 var_e336d;
                if (var_4e5f5.w >= 0.0)
                {
                    highp vec2 var_365ce = var_5d1fe.xy;
                    var_365ce = vec2(var_365ce.x, 1.0 - var_365ce.y);
                    highp float var_1ce3f = var_365ce.x;
                    highp float var_eb157 = var_365ce.y;
                    highp vec2 var_e0f7f = vec2(var_1ce3f, 1.0 - var_eb157);
                    var_365ce = var_e0f7f;
                    highp vec4 var_09711 = vec4((var_e0f7f * 2.0) - vec2(1.0), (texture(s_GbufferDepth, var_5d1fe.xy).x * 2.0) - 1.0, 1.0);
                    highp mat4 var_318a4 = u_invProj;
                    highp mat4 var_faa6f = u_invProj;
                    highp mat4 var_f255a = u_invProj;
                    highp mat4 var_e0c06 = u_invProj;
                    highp mat4 var_872b6 = u_invProj;
                    highp float var_cf8d3 = var_09711.x;
                    highp float var_0efa9 = var_09711.y;
                    highp float var_2b6d8 = var_09711.w;
                    highp float var_0691d = var_09711.z;
                    highp float var_04dd4 = var_09711.w;
                    highp vec4 var_3bb7d = vec4(var_cf8d3 * var_318a4[0].x, var_0efa9 * var_faa6f[1].y, var_2b6d8 * var_f255a[3].z, (var_0691d * var_e0c06[2].w) + (var_04dd4 * var_872b6[3].w));
                    var_09711 = var_3bb7d;
                    highp float var_2c006 = var_09711.w;
                    highp vec4 var_6097e = var_3bb7d / vec4(var_2c006);
                    var_09711 = var_6097e;
                    highp vec4 var_06e21 = u_prevViewProj * vec4((u_invView * vec4(var_6097e.xyz, 1.0)).xyz, 1.0);
                    highp vec4 var_801fa = var_06e21;
                    highp vec2 var_03532 = ((var_06e21.xyz / vec3(var_801fa.w)).xy + vec2(1.0)) * 0.5;
                    var_03532.y = 1.0 - var_03532.y;
                    var_e336d = vec4(texture(s_RasterColor, vec2(var_03532.x, 1.0 - var_03532.y)).xyz, var_4e5f5.w);
                }
                else
                {
                    var_e336d = vec4(0.0);
                }
                var_84ace = var_b7f64 + 1.0;
                var_25bbb = var_c4779 + ((var_e336d - var_c4779) / vec4(var_84ace));
                var_758f4 = var_8c126 + ((var_e336d - var_c4779) * (var_e336d - var_25bbb));
            }
        }
        highp vec4 var_96519 = sqrt(max(vec4(0.0), var_a266f / vec4(var_4a7a2 - 1.0)));
        var_2ba0f = clamp(texture(s_PreviousReflectionBuffer, vec2(var_68901.x, 1.0 - var_68901.y) * ViewportScale.zw), var_a0312 - (var_96519 * SSRTemporalAccumulationParams.y), var_a0312 + (var_96519 * SSRTemporalAccumulationParams.y));
    }
    else
    {
        var_2ba0f = var_f2a5f;
    }
    bgfx_FragData0 = mix(var_2ba0f, var_f2a5f, vec4(SSRTemporalAccumulationParams.w));
}
