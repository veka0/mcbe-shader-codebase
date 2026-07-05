#version 310 es

/*
* Available Macros:
*
* Passes:
* - COLOR_POST_PROCESS_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_ColorTexture;
* - uniform lowp sampler2D s_RasterColor;
*
* Uniforms:
* - uniform vec4 ColorGrading_Misc;
* - uniform vec4 ScreenSize;
* - uniform vec4 ViewportScale;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_ColorTexture;
uniform highp vec4 ColorGrading_Misc;
in highp vec4 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void func_8e2a0(inout highp vec3 arg_3007f, inout highp vec3 arg_87bd1) {
    if (ColorGrading_Misc.y != 0.0)
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
void func_f3623(inout highp vec3 arg_fb793, inout highp vec3 arg_0b881) {
    if (ColorGrading_Misc.y != 0.0)
    {
        arg_fb793 = pow(max(arg_0b881, vec3(0.0)), vec3(1.0) / (vec3(2.2000000476837158203125) * ColorGrading_Misc.x));
        return;
    }
    else
    {
        highp vec3 loc_8ff5b = arg_0b881;
        highp vec3 loc_f65c2 = arg_0b881 * 12.9200000762939453125;
        highp vec3 loc_3a1d5 = (pow(abs(arg_0b881), vec3(0.4166666567325592041015625)) * 1.05499994754791259765625) - vec3(0.054999999701976776123046875);
        highp float loc_e81ff;
        if (loc_8ff5b.x <= 0.003130800090730190277099609375)
        {
            loc_e81ff = loc_f65c2.x;
        }
        else
        {
            loc_e81ff = loc_3a1d5.x;
        }
        loc_8ff5b.x = loc_e81ff;
        highp float loc_007b0;
        if (loc_8ff5b.y <= 0.003130800090730190277099609375)
        {
            loc_007b0 = loc_f65c2.y;
        }
        else
        {
            loc_007b0 = loc_3a1d5.y;
        }
        loc_8ff5b.y = loc_007b0;
        highp float loc_fa4a6;
        if (loc_8ff5b.z <= 0.003130800090730190277099609375)
        {
            loc_fa4a6 = loc_f65c2.z;
        }
        else
        {
            loc_fa4a6 = loc_3a1d5.z;
        }
        loc_8ff5b.z = loc_fa4a6;
        arg_fb793 = pow(loc_8ff5b, vec3(2.2000000476837158203125) / (vec3(2.2000000476837158203125) * ColorGrading_Misc.x));
        return;
    }
}
void main() {
    highp vec4 var_be1e6 = texture(s_ColorTexture, v_texcoord0.xy);
    highp vec3 var_9e11a = var_be1e6.xyz;
    highp vec3 var_c60a3;
    func_8e2a0(var_c60a3, var_9e11a);
    highp vec3 var_fbc9d;
    func_f3623(var_fbc9d, var_c60a3);
    bgfx_FragColor = vec4(clamp(var_fbc9d, vec3(0.0), vec3(1.0)), 1.0);
}
