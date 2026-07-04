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
* - uniform lowp sampler2D s_GbufferRoughness;
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
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData[gl_MaxDrawBuffers];
void main() {
    highp vec4 var_52592 = texture(s_InputTexture, v_texcoord0.xy);
    highp vec4 var_cb8e0 = var_52592;
    highp vec4 var_d7d01 = vec4((var_52592.xy * 2.0) - vec2(1.0), (texture(s_GbufferDepth, var_52592.xy).x * 2.0) - 1.0, 1.0);
    highp mat4 var_3460a = u_invProj;
    highp float var_eb413 = var_d7d01.x;
    highp float var_ac116 = var_d7d01.y;
    highp float var_f2b7c = var_d7d01.w;
    highp float var_0357c = var_d7d01.z;
    highp float var_2c821 = var_d7d01.w;
    highp vec4 var_9666f = vec4(var_eb413 * var_3460a[0].x, var_ac116 * var_3460a[1].y, var_f2b7c * var_3460a[3].z, (var_0357c * var_3460a[2].w) + (var_2c821 * var_3460a[3].w));
    var_d7d01 = var_9666f;
    highp float var_d799e = var_d7d01.w;
    highp vec4 var_ecb7c = var_9666f / vec4(var_d799e);
    var_d7d01 = var_ecb7c;
    highp vec4 var_29b70 = u_prevViewProj * vec4((u_invView * vec4(var_ecb7c.xyz, 1.0)).xyz, 1.0);
    highp vec4 var_53e38 = var_29b70;
    highp vec2 var_c1944 = ((var_29b70.xyz / vec3(var_53e38.w)).xy + vec2(1.0)) * 0.5;
    var_c1944.y = 1.0 - var_c1944.y;
    highp vec4 var_567d7;
    if (var_cb8e0.w >= 0.0)
    {
        var_567d7 = vec4(texture(s_RasterColor, vec2(var_c1944.x, 1.0 - var_c1944.y)).xyz, var_cb8e0.w);
    }
    else
    {
        var_567d7 = vec4(0.0);
    }
    highp vec4 var_648fa;
    if (SSRTemporalAccumulationParams.x > 0.0)
    {
        highp vec4 var_ffe7a = vec4((v_texcoord0.xy * 2.0) - vec2(1.0), (var_cb8e0.z * 2.0) - 1.0, 1.0);
        highp mat4 var_1356c = u_invProj;
        highp float var_a1967 = var_ffe7a.x;
        highp float var_ccc39 = var_ffe7a.y;
        highp float var_071ba = var_ffe7a.w;
        highp float var_55419 = var_ffe7a.z;
        highp float var_10bf4 = var_ffe7a.w;
        highp vec4 var_67b7b = vec4(var_a1967 * var_1356c[0].x, var_ccc39 * var_1356c[1].y, var_071ba * var_1356c[3].z, (var_55419 * var_1356c[2].w) + (var_10bf4 * var_1356c[3].w));
        var_ffe7a = var_67b7b;
        highp float var_750bb = var_ffe7a.w;
        highp vec4 var_62835 = var_67b7b / vec4(var_750bb);
        var_ffe7a = var_62835;
        highp vec4 var_77040 = u_prevViewProj * vec4((u_invView * vec4(var_62835.xyz, 1.0)).xyz, 1.0);
        highp vec4 var_67609 = var_77040;
        highp vec2 var_d1e3c = ((var_77040.xyz / vec3(var_67609.w)).xy + vec2(1.0)) * 0.5;
        var_d1e3c.y = 1.0 - var_d1e3c.y;
        int var_6b3ea = int(SSRTemporalAccumulationParams.z);
        int var_08d17 = -var_6b3ea;
        highp vec4 var_a266f;
        highp float var_4a7a2;
        highp vec4 var_8cd78;
        var_8cd78 = vec4(0.0);
        var_4a7a2 = 0.0;
        var_a266f = vec4(0.0);
        highp float var_b7f64;
        highp vec4 var_c4779;
        highp vec4 var_8c126;
        for (int var_210f2 = var_08d17; var_210f2 <= var_6b3ea; var_8cd78 = var_c4779, var_4a7a2 = var_b7f64, var_a266f = var_8c126, var_210f2++)
        {
            int var_f2c75 = -var_6b3ea;
            var_8c126 = var_a266f;
            var_c4779 = var_8cd78;
            var_b7f64 = var_4a7a2;
            highp float var_84ace;
            highp vec4 var_25bbb;
            highp vec4 var_758f4;
            for (int var_371a7 = var_f2c75; var_371a7 <= var_6b3ea; var_8c126 = var_758f4, var_c4779 = var_25bbb, var_b7f64 = var_84ace, var_371a7++)
            {
                highp vec4 var_c6fe8 = texture(s_InputTexture, v_texcoord0.xy + (vec2(float(var_210f2), float(var_371a7)) * ScreenSize.zw));
                highp vec4 var_4e5f5 = var_c6fe8;
                highp vec4 var_e336d;
                if (var_4e5f5.w >= 0.0)
                {
                    highp vec4 var_f79e8 = vec4((var_c6fe8.xy * 2.0) - vec2(1.0), (texture(s_GbufferDepth, var_c6fe8.xy).x * 2.0) - 1.0, 1.0);
                    highp mat4 var_c3b98 = u_invProj;
                    highp float var_cf8d3 = var_f79e8.x;
                    highp float var_0efa9 = var_f79e8.y;
                    highp float var_2b6d8 = var_f79e8.w;
                    highp float var_0691d = var_f79e8.z;
                    highp float var_04dd4 = var_f79e8.w;
                    highp vec4 var_3bb7d = vec4(var_cf8d3 * var_c3b98[0].x, var_0efa9 * var_c3b98[1].y, var_2b6d8 * var_c3b98[3].z, (var_0691d * var_c3b98[2].w) + (var_04dd4 * var_c3b98[3].w));
                    var_f79e8 = var_3bb7d;
                    highp float var_2c006 = var_f79e8.w;
                    highp vec4 var_6097e = var_3bb7d / vec4(var_2c006);
                    var_f79e8 = var_6097e;
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
        highp vec4 var_af310 = sqrt(max(vec4(0.0), var_a266f / vec4(var_4a7a2 - 1.0)));
        var_648fa = clamp(texture(s_PreviousReflectionBuffer, vec2(var_d1e3c.x, 1.0 - var_d1e3c.y)), var_8cd78 - (var_af310 * SSRTemporalAccumulationParams.y), var_8cd78 + (var_af310 * SSRTemporalAccumulationParams.y));
    }
    else
    {
        var_648fa = var_567d7;
    }
    bgfx_FragData[0] = mix(var_648fa, var_567d7, vec4(SSRTemporalAccumulationParams.w));
}
