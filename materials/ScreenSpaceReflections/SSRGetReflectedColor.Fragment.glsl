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
uniform highp mat4 u_invProj;
uniform highp mat4 u_invView;
uniform highp mat4 u_prevViewProj;
uniform highp sampler2D s_GbufferDepth;
uniform highp sampler2D s_InputTexture;
uniform highp sampler2D s_RasterColor;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData[gl_MaxDrawBuffers];
void main() {
    highp vec4 var_249e1 = texture(s_InputTexture, v_texcoord0);
    highp vec4 var_484ca = var_249e1;
    highp vec4 var_c4910;
    if (var_484ca.w >= 0.0)
    {
        highp vec2 var_d6eca = var_249e1.xy;
        highp vec4 var_fb205 = vec4((var_d6eca * 2.0) - vec2(1.0), (texture(s_GbufferDepth, var_d6eca).x * 2.0) - 1.0, 1.0);
        highp mat4 var_1356c = u_invProj;
        highp float var_a1967 = var_fb205.x;
        highp float var_ccc39 = var_fb205.y;
        highp float var_071ba = var_fb205.w;
        highp float var_55419 = var_fb205.z;
        highp float var_10bf4 = var_fb205.w;
        highp vec4 var_67b7b = vec4(var_a1967 * var_1356c[0].x, var_ccc39 * var_1356c[1].y, var_071ba * var_1356c[3].z, (var_55419 * var_1356c[2].w) + (var_10bf4 * var_1356c[3].w));
        var_fb205 = var_67b7b;
        highp float var_750bb = var_fb205.w;
        highp vec4 var_62835 = var_67b7b / vec4(var_750bb);
        var_fb205 = var_62835;
        highp vec4 var_77040 = u_prevViewProj * vec4((u_invView * vec4(var_62835.xyz, 1.0)).xyz, 1.0);
        highp vec4 var_67609 = var_77040;
        highp vec2 var_6ce92 = ((var_77040.xyz / vec3(var_67609.w)).xy + vec2(1.0)) * 0.5;
        var_6ce92.y = 1.0 - var_6ce92.y;
        var_c4910 = vec4(texture(s_RasterColor, vec2(var_6ce92.x, 1.0 - var_6ce92.y)).xyz, var_484ca.w);
    }
    else
    {
        var_c4910 = vec4(0.0);
    }
    bgfx_FragData[0] = var_c4910;
}
