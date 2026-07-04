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
* - EXTENDED_GAP_FILL__OFF
* - EXTENDED_GAP_FILL__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_GbufferDepth;
* - uniform lowp sampler2D s_GbufferNormal;
* - uniform lowp sampler2D s_GbufferRoughness;
* - uniform lowp sampler2D s_InputTexture;
* - uniform lowp sampler2D s_RasterColor;
*
* Uniforms:
* - uniform vec4 CameraData;
* - uniform vec4 RenderMode;
* - uniform vec4 SSRFadingParams;
* - uniform vec4 SSRRayMarchingParams;
* - uniform vec4 SSRRoughnessCutoffParams;
* - uniform vec4 ScreenSize;
* - uniform vec4 UnitPlaneExtents;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_InputTexture;
uniform highp vec4 ScreenSize;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec2 var_dbb06 = ScreenSize.zw;
    highp vec4 var_f5b35 = texture(s_InputTexture, v_texcoord0);
    if (!(var_f5b35.w >= 0.0))
    {
#ifdef EXTENDED_GAP_FILL__OFF
        highp vec4 var_de8f0 = texture(s_InputTexture, v_texcoord0 + vec2(0.0, var_dbb06.y));
#endif
#ifdef EXTENDED_GAP_FILL__ON
        highp vec2 var_31fd1 = vec2(0.0, var_dbb06.y);
        highp vec4 var_de8f0 = texture(s_InputTexture, v_texcoord0 + var_31fd1);
        if (!(var_de8f0.w >= 0.0))
        {
            var_de8f0 = texture(s_InputTexture, v_texcoord0 + (var_31fd1 * 2.0));
        }
#endif
        highp vec4 var_ca8d5 = var_de8f0;
#ifdef EXTENDED_GAP_FILL__OFF
        highp vec4 var_9fb36 = texture(s_InputTexture, v_texcoord0 + vec2(0.0, -var_dbb06.y));
#endif
#ifdef EXTENDED_GAP_FILL__ON
        highp vec2 var_d45cd = vec2(0.0, -var_dbb06.y);
        highp vec4 var_9fb36 = texture(s_InputTexture, v_texcoord0 + var_d45cd);
        if (!(var_9fb36.w >= 0.0))
        {
            var_9fb36 = texture(s_InputTexture, v_texcoord0 + (var_d45cd * 2.0));
        }
#endif
        highp vec4 var_db61b = var_9fb36;
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
            var_f5b35 = (var_de8f0 + var_9fb36) * 0.5;
        }
    }
    bgfx_FragColor = var_f5b35;
}
