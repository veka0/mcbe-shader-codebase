#version 310 es

/*
* Available Macros:
*
* Passes:
* - SSR_FILL_GAPS_PASS (not used)
* - SSR_GET_REFLECTED_COLOR_PASS (not used)
* - SSR_RAY_MARCH_PASS (not used)
* - SSR_RAY_MARCH_HZB_PASS (not used)
*
* ExtendedGapFill:
* - EXTENDED_GAP_FILL__OFF
* - EXTENDED_GAP_FILL__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_GbufferDepth;
* - uniform lowp sampler2D s_GbufferNormal;
* - uniform lowp usampler2D s_GbufferRoughness;
* - uniform lowp sampler2D s_HiZBuffer;
* - uniform lowp sampler2D s_InputTexture;
* - uniform lowp sampler2D s_PreviousReflectionBuffer;
* - uniform lowp sampler2D s_RasterColor;
*
* Uniforms:
* - uniform vec4 CameraData;
* - uniform vec4 HiZMipCount;
* - uniform vec4 HiZViewportDimensionsAndBufferDimensions;
* - uniform vec4 SSRFadingParamsAndThickness;
* - uniform vec4 SSRRayMarchingParams;
* - uniform vec4 SSRRoughnessCutoffParams;
* - uniform vec4 SSRTemporalAccumulationParams;
* - uniform vec4 ScreenSize;
* - uniform vec4 ScreenSpaceRayOffset;
* - uniform vec4 UnitPlaneExtents;
* - uniform vec4 ViewportScale;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_InputTexture;
uniform highp vec4 ScreenSize;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec2 var_e8909 = ScreenSize.zw;
    highp vec4 var_55922 = texture(s_InputTexture, v_texcoord0.xy);
    if (!(var_55922.w >= 0.0))
    {
#ifdef EXTENDED_GAP_FILL__OFF
        highp vec4 var_b481d = texture(s_InputTexture, v_texcoord0.xy + vec2(0.0, var_e8909.y));
#endif
#ifdef EXTENDED_GAP_FILL__ON
        highp vec2 var_5be3e = vec2(0.0, var_e8909.y);
        highp vec4 var_b481d = texture(s_InputTexture, v_texcoord0.xy + var_5be3e);
        if (!(var_b481d.w >= 0.0))
        {
            var_b481d = texture(s_InputTexture, v_texcoord0.xy + (var_5be3e * 2.0));
        }
#endif
        highp vec4 var_ca8d5 = var_b481d;
#ifdef EXTENDED_GAP_FILL__OFF
        highp vec4 var_3262b = texture(s_InputTexture, v_texcoord0.xy + vec2(0.0, -var_e8909.y));
#endif
#ifdef EXTENDED_GAP_FILL__ON
        highp vec2 var_14e8a = vec2(0.0, -var_e8909.y);
        highp vec4 var_3262b = texture(s_InputTexture, v_texcoord0.xy + var_14e8a);
        if (!(var_3262b.w >= 0.0))
        {
            var_3262b = texture(s_InputTexture, v_texcoord0.xy + (var_14e8a * 2.0));
        }
#endif
        highp vec4 var_db61b = var_3262b;
        bool var_64c0c = var_ca8d5.w >= 0.0;
        bool var_8cdf6;
        if (var_64c0c)
        {
            var_8cdf6 = var_db61b.w >= 0.0;
        }
        else
        {
            var_8cdf6 = var_64c0c;
        }
        if (var_8cdf6)
        {
            var_55922 = (var_b481d + var_3262b) * 0.5;
        }
    }
    bgfx_FragData0 = var_55922;
}
