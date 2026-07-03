#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_Texture0;
* - uniform lowp sampler2D s_Texture1;
*
* Uniforms:
* - uniform vec4 PrimProps0;
* - uniform mat4 Transform;
*/

precision mediump float;
precision highp int;
vec3 var_8add6;
uniform highp sampler2D s_Texture0;
uniform highp sampler2D s_Texture1;
uniform highp vec4 PrimProps0;
in highp vec4 v_additional;
in highp vec4 v_color;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_c2563 = v_additional;
    highp vec4 var_ef0c7 = v_color;
    highp vec4 var_3774c = texture(s_Texture1, vec2(var_c2563.z, 1.0 - var_c2563.w));
    highp vec4 var_a5547 = var_3774c;
    highp vec4 var_1797c = texture(s_Texture0, vec2(var_c2563.x, 1.0 - var_c2563.y));
    highp vec4 var_51ac8 = var_1797c * var_ef0c7.w;
    highp vec4 var_9b012 = var_51ac8;
    highp vec3 var_bc0eb = var_3774c.xyz / vec3(max(var_a5547.w, 9.9999997473787516355514526367188e-05));
    highp vec3 var_dfa90 = var_51ac8.xyz / vec3(max(var_9b012.w, 9.9999997473787516355514526367188e-05));
    highp vec3 var_78b63;
    switch (int(PrimProps0.x))
    {
        case 0:
        {
            var_78b63 = var_dfa90;
            break;
        }
        case 1:
        {
            var_78b63 = var_bc0eb * var_dfa90;
            break;
        }
        case 2:
        {
            var_78b63 = (var_bc0eb + var_dfa90) - (var_bc0eb * var_dfa90);
            break;
        }
        case 3:
        {
            highp vec3 var_b526f = (var_bc0eb * 2.0) - vec3(1.0);
            var_78b63 = mix((var_dfa90 + var_b526f) - (var_dfa90 * var_b526f), var_dfa90 * (var_bc0eb * 2.0), step(vec3(0.5), var_bc0eb));
            break;
        }
        case 4:
        {
            var_78b63 = min(var_dfa90, var_bc0eb);
            break;
        }
        case 5:
        {
            var_78b63 = max(var_dfa90, var_bc0eb);
            break;
        }
        case 6:
        {
            var_78b63 = min(var_bc0eb / max(vec3(1.0) - var_dfa90, vec3(9.9999997473787516355514526367188e-05)), vec3(1.0));
            break;
        }
        case 7:
        {
            var_78b63 = vec3(1.0) - min((vec3(1.0) - var_bc0eb) / max(var_dfa90, vec3(9.9999997473787516355514526367188e-05)), vec3(1.0));
            break;
        }
        case 8:
        {
            highp vec3 var_6203c = (var_dfa90 * 2.0) - vec3(1.0);
            var_78b63 = mix((var_bc0eb + var_6203c) - (var_bc0eb * var_6203c), var_bc0eb * (var_dfa90 * 2.0), step(vec3(0.5), var_dfa90));
            break;
        }
        case 9:
        {
            var_78b63 = mix(var_bc0eb + (((var_dfa90 * 2.0) - vec3(1.0)) * (mix(sqrt(var_bc0eb), ((((var_bc0eb * 16.0) - vec3(12.0)) * var_bc0eb) + vec3(4.0)) * var_bc0eb, step(vec3(0.25), var_bc0eb)) - var_bc0eb)), var_bc0eb - (((vec3(1.0) - (var_dfa90 * 2.0)) * var_bc0eb) * (vec3(1.0) - var_bc0eb)), step(vec3(0.5), var_dfa90));
            break;
        }
        case 10:
        {
            var_78b63 = abs(var_bc0eb - var_dfa90);
            break;
        }
        case 11:
        {
            var_78b63 = (var_bc0eb + var_dfa90) - ((var_bc0eb * 2.0) * var_dfa90);
            break;
        }
        case 12:
        {
            highp vec3 var_8c616 = var_bc0eb;
            highp float var_23fec = max(max(var_8c616.x, var_8c616.y), var_8c616.z) - min(min(var_8c616.x, var_8c616.y), var_8c616.z);
            highp vec3 var_98eb8 = var_dfa90;
            if (var_98eb8.x <= var_98eb8.y)
            {
                if (var_98eb8.y <= var_98eb8.z)
                {
                    highp vec3 var_7cf72 = var_98eb8;
                    if (var_7cf72.z > var_7cf72.x)
                    {
                        var_7cf72.y = ((var_7cf72.y - var_7cf72.x) * var_23fec) / (var_7cf72.z - var_7cf72.x);
                        var_7cf72.z = var_23fec;
                    }
                    else
                    {
                        var_7cf72 = vec3(var_7cf72.x, vec2(0.0).x, vec2(0.0).y);
                    }
                    var_98eb8 = vec3(0.0, var_7cf72.y, var_7cf72.z);
                }
                else
                {
                    if (var_98eb8.x <= var_98eb8.z)
                    {
                        highp vec3 var_6afc0 = var_98eb8.xzy;
                        if (var_6afc0.z > var_6afc0.x)
                        {
                            var_6afc0.y = ((var_6afc0.y - var_6afc0.x) * var_23fec) / (var_6afc0.z - var_6afc0.x);
                            var_6afc0.z = var_23fec;
                        }
                        else
                        {
                            var_6afc0 = vec3(var_6afc0.x, vec2(0.0).x, vec2(0.0).y);
                        }
                        highp vec3 var_f67ed = vec3(0.0, var_6afc0.y, var_6afc0.z);
                        var_98eb8 = vec3(var_f67ed.x, var_f67ed.z, var_f67ed.y);
                    }
                    else
                    {
                        highp vec3 var_45b2c = var_98eb8.zxy;
                        if (var_45b2c.z > var_45b2c.x)
                        {
                            var_45b2c.y = ((var_45b2c.y - var_45b2c.x) * var_23fec) / (var_45b2c.z - var_45b2c.x);
                            var_45b2c.z = var_23fec;
                        }
                        else
                        {
                            var_45b2c = vec3(var_45b2c.x, vec2(0.0).x, vec2(0.0).y);
                        }
                        highp vec3 var_315a0 = vec3(0.0, var_45b2c.y, var_45b2c.z);
                        var_98eb8 = vec3(var_315a0.y, var_315a0.z, var_315a0.x);
                    }
                }
            }
            else
            {
                if (var_98eb8.x <= var_98eb8.z)
                {
                    highp vec3 var_6209d = var_98eb8.yxz;
                    if (var_6209d.z > var_6209d.x)
                    {
                        var_6209d.y = ((var_6209d.y - var_6209d.x) * var_23fec) / (var_6209d.z - var_6209d.x);
                        var_6209d.z = var_23fec;
                    }
                    else
                    {
                        var_6209d = vec3(var_6209d.x, vec2(0.0).x, vec2(0.0).y);
                    }
                    highp vec3 var_414ed = vec3(0.0, var_6209d.y, var_6209d.z);
                    var_98eb8 = vec3(var_414ed.y, var_414ed.x, var_414ed.z);
                }
                else
                {
                    if (var_98eb8.y <= var_98eb8.z)
                    {
                        highp vec3 var_f347b = var_98eb8.yzx;
                        if (var_f347b.z > var_f347b.x)
                        {
                            var_f347b.y = ((var_f347b.y - var_f347b.x) * var_23fec) / (var_f347b.z - var_f347b.x);
                            var_f347b.z = var_23fec;
                        }
                        else
                        {
                            var_f347b = vec3(var_f347b.x, vec2(0.0).x, vec2(0.0).y);
                        }
                        highp vec3 var_7a150 = vec3(0.0, var_f347b.y, var_f347b.z);
                        var_98eb8 = vec3(var_7a150.z, var_7a150.x, var_7a150.y);
                    }
                    else
                    {
                        highp vec3 var_bf949 = var_98eb8.zyx;
                        if (var_bf949.z > var_bf949.x)
                        {
                            var_bf949.y = ((var_bf949.y - var_bf949.x) * var_23fec) / (var_bf949.z - var_bf949.x);
                            var_bf949.z = var_23fec;
                        }
                        else
                        {
                            var_bf949 = vec3(var_bf949.x, vec2(0.0).x, vec2(0.0).y);
                        }
                        highp vec3 var_b1fa1 = vec3(0.0, var_bf949.y, var_bf949.z);
                        var_98eb8 = vec3(var_b1fa1.z, var_b1fa1.y, var_b1fa1.x);
                    }
                }
            }
            highp vec3 var_cb858 = var_98eb8 + vec3((((0.2125999927520751953125 * var_bc0eb.x) + (0.715200006961822509765625 * var_bc0eb.y)) + (0.072200000286102294921875 * var_bc0eb.z)) - (((0.2125999927520751953125 * var_98eb8.x) + (0.715200006961822509765625 * var_98eb8.y)) + (0.072200000286102294921875 * var_98eb8.z)));
            highp vec3 var_066ba = var_cb858;
            highp float var_d7cfd = ((0.2125999927520751953125 * var_cb858.x) + (0.715200006961822509765625 * var_cb858.y)) + (0.072200000286102294921875 * var_cb858.z);
            highp float var_47449 = min(min(var_066ba.x, var_066ba.y), var_066ba.z);
            highp float var_bc88e = var_066ba.x;
            highp float var_c3550 = var_066ba.y;
            highp float var_b4468 = var_066ba.z;
            highp float var_bebcc = max(max(var_bc88e, var_c3550), var_b4468);
            if (var_47449 < 0.0)
            {
                var_066ba = vec3(var_d7cfd) + (((var_066ba - vec3(var_d7cfd)) * var_d7cfd) / vec3(var_d7cfd - var_47449));
            }
            if (var_bebcc > 1.0)
            {
                var_066ba = vec3(var_d7cfd) + (((var_066ba - vec3(var_d7cfd)) * (1.0 - var_d7cfd)) / vec3(var_bebcc - var_d7cfd));
            }
            var_78b63 = var_066ba;
            break;
        }
        case 13:
        {
            highp vec3 var_4d780 = var_dfa90;
            highp float var_e0384 = max(max(var_4d780.x, var_4d780.y), var_4d780.z) - min(min(var_4d780.x, var_4d780.y), var_4d780.z);
            highp vec3 var_117f4 = var_bc0eb;
            if (var_117f4.x <= var_117f4.y)
            {
                if (var_117f4.y <= var_117f4.z)
                {
                    highp vec3 var_19909 = var_117f4;
                    if (var_19909.z > var_19909.x)
                    {
                        var_19909.y = ((var_19909.y - var_19909.x) * var_e0384) / (var_19909.z - var_19909.x);
                        var_19909.z = var_e0384;
                    }
                    else
                    {
                        var_19909 = vec3(var_19909.x, vec2(0.0).x, vec2(0.0).y);
                    }
                    var_117f4 = vec3(0.0, var_19909.y, var_19909.z);
                }
                else
                {
                    if (var_117f4.x <= var_117f4.z)
                    {
                        highp vec3 var_b645d = var_117f4.xzy;
                        if (var_b645d.z > var_b645d.x)
                        {
                            var_b645d.y = ((var_b645d.y - var_b645d.x) * var_e0384) / (var_b645d.z - var_b645d.x);
                            var_b645d.z = var_e0384;
                        }
                        else
                        {
                            var_b645d = vec3(var_b645d.x, vec2(0.0).x, vec2(0.0).y);
                        }
                        highp vec3 var_c98ca = vec3(0.0, var_b645d.y, var_b645d.z);
                        var_117f4 = vec3(var_c98ca.x, var_c98ca.z, var_c98ca.y);
                    }
                    else
                    {
                        highp vec3 var_57f84 = var_117f4.zxy;
                        if (var_57f84.z > var_57f84.x)
                        {
                            var_57f84.y = ((var_57f84.y - var_57f84.x) * var_e0384) / (var_57f84.z - var_57f84.x);
                            var_57f84.z = var_e0384;
                        }
                        else
                        {
                            var_57f84 = vec3(var_57f84.x, vec2(0.0).x, vec2(0.0).y);
                        }
                        highp vec3 var_6717a = vec3(0.0, var_57f84.y, var_57f84.z);
                        var_117f4 = vec3(var_6717a.y, var_6717a.z, var_6717a.x);
                    }
                }
            }
            else
            {
                if (var_117f4.x <= var_117f4.z)
                {
                    highp vec3 var_5eacc = var_117f4.yxz;
                    if (var_5eacc.z > var_5eacc.x)
                    {
                        var_5eacc.y = ((var_5eacc.y - var_5eacc.x) * var_e0384) / (var_5eacc.z - var_5eacc.x);
                        var_5eacc.z = var_e0384;
                    }
                    else
                    {
                        var_5eacc = vec3(var_5eacc.x, vec2(0.0).x, vec2(0.0).y);
                    }
                    highp vec3 var_1cde4 = vec3(0.0, var_5eacc.y, var_5eacc.z);
                    var_117f4 = vec3(var_1cde4.y, var_1cde4.x, var_1cde4.z);
                }
                else
                {
                    if (var_117f4.y <= var_117f4.z)
                    {
                        highp vec3 var_33a78 = var_117f4.yzx;
                        if (var_33a78.z > var_33a78.x)
                        {
                            var_33a78.y = ((var_33a78.y - var_33a78.x) * var_e0384) / (var_33a78.z - var_33a78.x);
                            var_33a78.z = var_e0384;
                        }
                        else
                        {
                            var_33a78 = vec3(var_33a78.x, vec2(0.0).x, vec2(0.0).y);
                        }
                        highp vec3 var_57c96 = vec3(0.0, var_33a78.y, var_33a78.z);
                        var_117f4 = vec3(var_57c96.z, var_57c96.x, var_57c96.y);
                    }
                    else
                    {
                        highp vec3 var_89d81 = var_117f4.zyx;
                        if (var_89d81.z > var_89d81.x)
                        {
                            var_89d81.y = ((var_89d81.y - var_89d81.x) * var_e0384) / (var_89d81.z - var_89d81.x);
                            var_89d81.z = var_e0384;
                        }
                        else
                        {
                            var_89d81 = vec3(var_89d81.x, vec2(0.0).x, vec2(0.0).y);
                        }
                        highp vec3 var_64f55 = vec3(0.0, var_89d81.y, var_89d81.z);
                        var_117f4 = vec3(var_64f55.z, var_64f55.y, var_64f55.x);
                    }
                }
            }
            highp vec3 var_bc8aa = var_117f4 + vec3((((0.2125999927520751953125 * var_bc0eb.x) + (0.715200006961822509765625 * var_bc0eb.y)) + (0.072200000286102294921875 * var_bc0eb.z)) - (((0.2125999927520751953125 * var_117f4.x) + (0.715200006961822509765625 * var_117f4.y)) + (0.072200000286102294921875 * var_117f4.z)));
            highp vec3 var_f1dca = var_bc8aa;
            highp float var_edfe8 = ((0.2125999927520751953125 * var_bc8aa.x) + (0.715200006961822509765625 * var_bc8aa.y)) + (0.072200000286102294921875 * var_bc8aa.z);
            highp float var_43fe3 = min(min(var_f1dca.x, var_f1dca.y), var_f1dca.z);
            highp float var_09da4 = var_f1dca.x;
            highp float var_34cb6 = var_f1dca.y;
            highp float var_b2ac4 = var_f1dca.z;
            highp float var_93556 = max(max(var_09da4, var_34cb6), var_b2ac4);
            if (var_43fe3 < 0.0)
            {
                var_f1dca = vec3(var_edfe8) + (((var_f1dca - vec3(var_edfe8)) * var_edfe8) / vec3(var_edfe8 - var_43fe3));
            }
            if (var_93556 > 1.0)
            {
                var_f1dca = vec3(var_edfe8) + (((var_f1dca - vec3(var_edfe8)) * (1.0 - var_edfe8)) / vec3(var_93556 - var_edfe8));
            }
            var_78b63 = var_f1dca;
            break;
        }
        case 14:
        {
            highp vec3 var_a3aeb = var_dfa90 + vec3((((0.2125999927520751953125 * var_bc0eb.x) + (0.715200006961822509765625 * var_bc0eb.y)) + (0.072200000286102294921875 * var_bc0eb.z)) - (((0.2125999927520751953125 * var_dfa90.x) + (0.715200006961822509765625 * var_dfa90.y)) + (0.072200000286102294921875 * var_dfa90.z)));
            highp vec3 var_742ab = var_a3aeb;
            highp float var_bf5b9 = ((0.2125999927520751953125 * var_a3aeb.x) + (0.715200006961822509765625 * var_a3aeb.y)) + (0.072200000286102294921875 * var_a3aeb.z);
            highp float var_f8e5b = min(min(var_742ab.x, var_742ab.y), var_742ab.z);
            highp float var_b2a9f = var_742ab.x;
            highp float var_d2023 = var_742ab.y;
            highp float var_236f2 = var_742ab.z;
            highp float var_f2877 = max(max(var_b2a9f, var_d2023), var_236f2);
            if (var_f8e5b < 0.0)
            {
                var_742ab = vec3(var_bf5b9) + (((var_742ab - vec3(var_bf5b9)) * var_bf5b9) / vec3(var_bf5b9 - var_f8e5b));
            }
            if (var_f2877 > 1.0)
            {
                var_742ab = vec3(var_bf5b9) + (((var_742ab - vec3(var_bf5b9)) * (1.0 - var_bf5b9)) / vec3(var_f2877 - var_bf5b9));
            }
            var_78b63 = var_742ab;
            break;
        }
        case 15:
        {
            highp vec3 var_14681 = var_bc0eb + vec3((((0.2125999927520751953125 * var_dfa90.x) + (0.715200006961822509765625 * var_dfa90.y)) + (0.072200000286102294921875 * var_dfa90.z)) - (((0.2125999927520751953125 * var_bc0eb.x) + (0.715200006961822509765625 * var_bc0eb.y)) + (0.072200000286102294921875 * var_bc0eb.z)));
            highp vec3 var_259ab = var_14681;
            highp float var_762b6 = ((0.2125999927520751953125 * var_14681.x) + (0.715200006961822509765625 * var_14681.y)) + (0.072200000286102294921875 * var_14681.z);
            highp float var_df6ac = min(min(var_259ab.x, var_259ab.y), var_259ab.z);
            highp float var_eead3 = var_259ab.x;
            highp float var_25f04 = var_259ab.y;
            highp float var_820b4 = var_259ab.z;
            highp float var_9ff98 = max(max(var_eead3, var_25f04), var_820b4);
            if (var_df6ac < 0.0)
            {
                var_259ab = vec3(var_762b6) + (((var_259ab - vec3(var_762b6)) * var_762b6) / vec3(var_762b6 - var_df6ac));
            }
            if (var_9ff98 > 1.0)
            {
                var_259ab = vec3(var_762b6) + (((var_259ab - vec3(var_762b6)) * (1.0 - var_762b6)) / vec3(var_9ff98 - var_762b6));
            }
            var_78b63 = var_259ab;
            break;
        }
        case 16:
        {
            var_78b63 = min(var_dfa90 + var_bc0eb, vec3(1.0));
            break;
        }
        default:
        {
            var_78b63 = vec3(0.0);
            break;
        }
    }
    bgfx_FragColor = ((var_51ac8 * (1.0 - var_a5547.w)) + (vec4(clamp(var_78b63, vec3(0.0), vec3(1.0)), 1.0) * (var_9b012.w * var_a5547.w))) + (var_3774c * (1.0 - var_9b012.w));
}
