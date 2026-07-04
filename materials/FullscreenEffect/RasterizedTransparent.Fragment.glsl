#version 310 es

/*
* Available Macros:
*
* Passes:
* - RASTERIZED_TRANSPARENT_PASS (not used)
*
* AlphaTest:
* - ALPHA_TEST__OFF
* - ALPHA_TEST__ON_DISCARD_VALUE_BASED
* - ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED
*
* Lit:
* - LIT__OFF (not used)
* - LIT__ON (not used)
*
* UseTextures:
* - USE_TEXTURES__OFF
* - USE_TEXTURES__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 ColorGrading_OptimizeGammaCorrection;
* - uniform vec4 CurrentColor;
* - uniform vec4 DiscardValue;
* - uniform vec4 HudOpacity;
* - uniform vec4 SubPixelOffset;
* - uniform vec4 UVAnimation;
* - uniform vec4 ZShiftValue;
*/

precision mediump float;
precision highp int;
#ifdef USE_TEXTURES__ON
uniform highp sampler2D s_MatTexture;
#endif
uniform highp vec4 ColorGrading_OptimizeGammaCorrection;
uniform highp vec4 CurrentColor;
#ifdef ALPHA_TEST__ON_DISCARD_VALUE_BASED
uniform highp vec4 DiscardValue;
#endif
uniform highp vec4 HudOpacity;
in highp vec4 v_color;
#ifdef USE_TEXTURES__ON
centroid in highp vec2 v_texCoords;
#endif
layout(location = 0) out highp vec4 bgfx_FragColor;
#ifdef USE_TEXTURES__OFF
void func_00e11(inout highp vec3 arg_de54a) {
    if (ColorGrading_OptimizeGammaCorrection.x != 0.0)
    {
        arg_de54a = vec3(1.0);
        return;
    }
    else
    {
        highp vec3 loc_26da9 = vec3(1.0);
        highp vec3 loc_ae26a = vec3(0.077399380505084991455078125);
        highp vec3 loc_9e3c3 = vec3(1.0);
        highp float loc_e81ff;
        if (loc_26da9.x <= 0.040449999272823333740234375)
        {
            loc_e81ff = loc_ae26a.x;
        }
        else
        {
            loc_e81ff = loc_9e3c3.x;
        }
        loc_26da9.x = loc_e81ff;
        highp float loc_007b0;
        if (loc_26da9.y <= 0.040449999272823333740234375)
        {
            loc_007b0 = loc_ae26a.y;
        }
        else
        {
            loc_007b0 = loc_9e3c3.y;
        }
        loc_26da9.y = loc_007b0;
        highp float loc_fa4a6;
        if (loc_26da9.z <= 0.040449999272823333740234375)
        {
            loc_fa4a6 = loc_ae26a.z;
        }
        else
        {
            loc_fa4a6 = loc_9e3c3.z;
        }
        loc_26da9.z = loc_fa4a6;
        arg_de54a = loc_26da9;
        return;
    }
}
#endif
#ifdef USE_TEXTURES__ON
void func_9b87e(inout highp vec3 arg_3007f, inout highp vec3 arg_87bd1) {
    if (ColorGrading_OptimizeGammaCorrection.x != 0.0)
    {
        arg_3007f = pow(max(arg_87bd1, vec3(0.0)), vec3(2.2000000476837158203125));
        return;
    }
    else
    {
        highp vec3 loc_407b7 = arg_87bd1;
        highp vec3 loc_67ff9 = arg_87bd1 * vec3(0.077399380505084991455078125);
        highp vec3 loc_b63b1 = pow((arg_87bd1 + vec3(0.054999999701976776123046875)) * vec3(0.947867333889007568359375), vec3(2.400000095367431640625));
        highp float loc_e81ff;
        if (loc_407b7.x <= 0.040449999272823333740234375)
        {
            loc_e81ff = loc_67ff9.x;
        }
        else
        {
            loc_e81ff = loc_b63b1.x;
        }
        loc_407b7.x = loc_e81ff;
        highp float loc_007b0;
        if (loc_407b7.y <= 0.040449999272823333740234375)
        {
            loc_007b0 = loc_67ff9.y;
        }
        else
        {
            loc_007b0 = loc_b63b1.y;
        }
        loc_407b7.y = loc_007b0;
        highp float loc_fa4a6;
        if (loc_407b7.z <= 0.040449999272823333740234375)
        {
            loc_fa4a6 = loc_67ff9.z;
        }
        else
        {
            loc_fa4a6 = loc_b63b1.z;
        }
        loc_407b7.z = loc_fa4a6;
        arg_3007f = loc_407b7;
        return;
    }
}
#endif
void main() {
#ifdef USE_TEXTURES__OFF
    highp vec4 var_d1d67 = vec4(1.0);
    highp vec4 var_da465 = vec4(1.0);
#endif
#ifdef USE_TEXTURES__ON
    highp vec4 var_7edd0 = texture(s_MatTexture, v_texCoords);
    highp vec4 var_d1d67 = var_7edd0;
    highp vec4 var_da465 = var_7edd0;
    highp vec3 var_9e11a = var_7edd0.xyz;
#endif
    highp vec3 var_99a6d;
#ifdef USE_TEXTURES__OFF
    func_00e11(var_99a6d);
#endif
#ifdef USE_TEXTURES__ON
    func_9b87e(var_99a6d, var_9e11a);
#endif
#ifdef ALPHA_TEST__OFF
    var_d1d67 = (CurrentColor * v_color) * vec4(var_99a6d, var_da465.w);
#endif
#ifndef ALPHA_TEST__OFF
    var_d1d67 = vec4(var_99a6d, var_da465.w);
#endif
#ifdef ALPHA_TEST__ON_DISCARD_VALUE_BASED
    if (var_d1d67.w < DiscardValue.x)
#endif
#ifdef ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED
    if (var_d1d67.w <= 0.0)
#endif
#ifndef ALPHA_TEST__OFF
    {
        discard;
    }
    var_d1d67 = (CurrentColor * v_color) * var_d1d67;
#endif
    var_d1d67.w *= HudOpacity.x;
    bgfx_FragColor = var_d1d67;
}
