#version 310 es

/*
* Available Macros:
*
* Passes:
* - MIN_MAX_DOWN_SAMPLE_PASS (not used)
*
* Mode:
* - MODE__INITIALIZE
* - MODE__MIP
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_PreviousMip;
* - uniform lowp sampler2D s_RasterColor;
*
* Uniforms:
* - uniform vec4 MipResolutionAndRecipResolution;
* - uniform vec4 PreviousMipResolutionAndRecipResolution;
* - uniform vec4 ScreenSize;
* - uniform vec4 ViewportScale;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_PreviousMip;
uniform highp vec4 MipResolutionAndRecipResolution;
uniform highp vec4 PreviousMipResolutionAndRecipResolution;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec2 var_06275 = floor(v_texcoord0.xy * MipResolutionAndRecipResolution.xy) * MipResolutionAndRecipResolution.zw;
    highp vec4 var_821d7 = vec4(0.0);
#ifdef MODE__MIP
    highp vec4 var_6068e = vec4(0.0);
#endif
    highp vec2 var_975ea = texture(s_PreviousMip, var_06275).xy;
    var_821d7.x = var_975ea.x;
#ifdef MODE__MIP
    var_6068e.x = var_975ea.y;
#endif
    var_975ea = texture(s_PreviousMip, var_06275 + (vec2(1.0, 0.0) * PreviousMipResolutionAndRecipResolution.zw)).xy;
    var_821d7.y = var_975ea.x;
#ifdef MODE__MIP
    var_6068e.y = var_975ea.y;
#endif
    var_975ea = texture(s_PreviousMip, var_06275 + PreviousMipResolutionAndRecipResolution.zw).xy;
    var_821d7.z = var_975ea.x;
#ifdef MODE__MIP
    var_6068e.z = var_975ea.y;
#endif
    var_975ea = texture(s_PreviousMip, var_06275 + (vec2(0.0, 1.0) * PreviousMipResolutionAndRecipResolution.zw)).xy;
    var_821d7.w = var_975ea.x;
#ifdef MODE__INITIALIZE
    highp vec4 var_6068e = ((vec4(-500.0) / ((var_821d7 * 999.75) - vec4(1000.25))) - vec4(0.25)) * vec4(0.001000250107608735561370849609375);
#endif
#ifdef MODE__MIP
    var_6068e.w = var_975ea.y;
    highp vec2 var_0d58c = min(var_821d7.xy, var_821d7.zw);
#endif
#ifdef MODE__INITIALIZE
    highp vec2 var_0d58c = min(var_6068e.xy, var_6068e.zw);
#endif
    highp vec2 var_2da52 = max(var_6068e.xy, var_6068e.zw);
    bgfx_FragColor = vec4(min(var_0d58c.x, var_0d58c.y), max(var_2da52.x, var_2da52.y), 0.0, 0.0);
}
