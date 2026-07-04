#version 310 es

/*
* Available Macros:
*
* Passes:
* - DUAL_MIN_MAX_DOWN_SAMPLE_PASS (not used)
*
* Mode:
* - MODE__INITIALIZE
* - MODE__MIP
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_PreviousMip;
* - uniform lowp sampler2D s_PreviousMip2;
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
#ifdef MODE__INITIALIZE
uniform highp sampler2D s_PreviousMip2;
#endif
uniform highp sampler2D s_PreviousMip;
uniform highp vec4 MipResolutionAndRecipResolution;
uniform highp vec4 PreviousMipResolutionAndRecipResolution;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec2 var_fe63b = floor(v_texcoord0.xy * MipResolutionAndRecipResolution.xy) * MipResolutionAndRecipResolution.zw;
    highp vec4 var_daf29 = texture(s_PreviousMip, var_fe63b);
    highp vec4 var_a5a02;
    var_a5a02.x = var_daf29.x;
#ifdef MODE__MIP
    highp vec4 var_5e74d;
    var_5e74d.x = var_daf29.y;
    highp vec4 var_749fe;
    var_749fe.x = var_daf29.z;
    highp vec4 var_54906;
    var_54906.x = var_daf29.w;
#endif
    var_daf29 = texture(s_PreviousMip, var_fe63b + (vec2(1.0, 0.0) * PreviousMipResolutionAndRecipResolution.zw));
    var_a5a02.y = var_daf29.x;
#ifdef MODE__MIP
    var_5e74d.y = var_daf29.y;
    var_749fe.y = var_daf29.z;
    var_54906.y = var_daf29.w;
#endif
    var_daf29 = texture(s_PreviousMip, var_fe63b + PreviousMipResolutionAndRecipResolution.zw);
    var_a5a02.z = var_daf29.x;
#ifdef MODE__MIP
    var_5e74d.z = var_daf29.y;
    var_749fe.z = var_daf29.z;
    var_54906.z = var_daf29.w;
#endif
    var_daf29 = texture(s_PreviousMip, var_fe63b + (vec2(0.0, 1.0) * PreviousMipResolutionAndRecipResolution.zw));
    var_a5a02.w = var_daf29.x;
#ifdef MODE__INITIALIZE
    highp vec4 var_d84f7 = texture(s_PreviousMip2, var_fe63b);
    highp vec4 var_54906;
    var_54906.x = var_d84f7.z;
    var_d84f7 = texture(s_PreviousMip2, var_fe63b + (vec2(1.0, 0.0) * PreviousMipResolutionAndRecipResolution.zw));
    var_54906.y = var_d84f7.z;
    var_d84f7 = texture(s_PreviousMip2, var_fe63b + PreviousMipResolutionAndRecipResolution.zw);
    var_54906.z = var_d84f7.z;
    var_d84f7 = texture(s_PreviousMip2, var_fe63b + (vec2(0.0, 1.0) * PreviousMipResolutionAndRecipResolution.zw));
#endif
#ifdef MODE__MIP
    var_5e74d.w = var_daf29.y;
    var_749fe.w = var_daf29.z;
#endif
#ifdef MODE__INITIALIZE
    var_54906.w = var_d84f7.z;
    highp vec4 var_5e74d = ((vec4(-500.0) / ((var_a5a02 * 999.75) - vec4(1000.25))) - vec4(0.25)) * vec4(0.001000250107608735561370849609375);
#endif
#ifdef MODE__MIP
    var_54906.w = var_daf29.w;
    highp vec2 var_534b2 = min(var_a5a02.xy, var_a5a02.zw);
#endif
#ifdef MODE__INITIALIZE
    highp vec2 var_534b2 = min(var_5e74d.xy, var_5e74d.zw);
#endif
    highp vec2 var_3f475 = max(var_5e74d.xy, var_5e74d.zw);
#ifdef MODE__INITIALIZE
    highp vec2 var_c2a39 = min(var_54906.xy, var_54906.zw);
#endif
#ifdef MODE__MIP
    highp vec2 var_c2a39 = min(var_749fe.xy, var_749fe.zw);
#endif
    highp vec2 var_5dd98 = max(var_54906.xy, var_54906.zw);
    bgfx_FragColor = vec4(min(var_534b2.x, var_534b2.y), max(var_3f475.x, var_3f475.y), min(var_c2a39.x, var_c2a39.y), max(var_5dd98.x, var_5dd98.y));
}
