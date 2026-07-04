#version 310 es

/*
* Available Macros:
*
* Passes:
* - MIN_MAX_DOWN_SAMPLE_PASS (not used)
* - MIN_MAX_INITIALIZE_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_PreviousMip;
* - uniform lowp sampler2D s_RasterColor;
*
* Uniforms:
* - uniform vec4 MipLevel;
* - uniform vec4 MipResolutionAndRecipResolution;
* - uniform vec4 PreviousMipResolutionAndRecipResolution;
* - uniform vec4 ScreenSize;
* - uniform vec4 Thickness;
* - uniform vec4 ViewportScale;
*/

precision mediump float;
precision highp int;
uniform highp mat4 u_invProj;
uniform highp mat4 u_proj;
uniform highp sampler2D s_PreviousMip;
uniform highp vec4 MipResolutionAndRecipResolution;
uniform highp vec4 PreviousMipResolutionAndRecipResolution;
uniform highp vec4 Thickness;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_39b87 = texture(s_PreviousMip, (v_texcoord0.xy * MipResolutionAndRecipResolution.xy) * PreviousMipResolutionAndRecipResolution.zw);
    highp float var_b6b83 = var_39b87.x;
    highp mat4 var_5ca97 = u_invProj;
    highp mat4 var_99c52 = u_invProj;
    highp mat4 var_2fc8e = u_invProj;
    highp float var_3228d = (var_5ca97[3].z / ((((var_b6b83 * 2.0) - 1.0) * var_99c52[2].w) + var_2fc8e[3].w)) - Thickness.x;
    highp mat4 var_c8797 = u_proj;
    highp mat4 var_f6a93 = u_proj;
    highp mat4 var_456a5 = u_proj;
    bgfx_FragColor = vec4(var_b6b83, ((((var_3228d * var_c8797[2].z) + var_f6a93[3].z) / (var_3228d * var_456a5[2].w)) * 0.5) + 0.5, 0.0, 0.0);
}
