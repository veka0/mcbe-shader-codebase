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
* - uniform lowp sampler2D s_txBuffer;
* - uniform lowp sampler2D s_txBuffer1;
*
* Uniforms:
* - uniform vec4 Data_PS[128];
* - uniform vec4 Data_VS[128];
* - uniform vec4 UVTransform[5];
*/

precision mediump float;
precision highp int;
vec3 var_8add6;
uniform highp sampler2D s_txBuffer1;
uniform highp sampler2D s_txBuffer;
uniform highp vec4 Data_PS[128];
uniform highp vec4 UVTransform[5];
in highp vec4 v_Additional;
in highp vec4 v_NoPerspParam;
flat in highp vec4 v_VaryingData;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    uvec4 var_05e85 = uvec4(v_VaryingData);
    int var_8e4d8 = int((var_05e85.z << 4u) | ((var_05e85.y & 240u) >> 4u));
    highp vec4 var_0a8ca = Data_PS[var_8e4d8];
    highp vec4 var_937d7 = Data_PS[var_8e4d8 + 1];
    highp vec4 var_341fb = Data_PS[int(var_0a8ca.x)];
    highp vec2 var_c3e1b = vec2(v_NoPerspParam.z, 1.0 - v_NoPerspParam.w);
    highp float var_c2b62 = var_c3e1b.x;
    highp float var_ace1a = var_c3e1b.y;
    highp vec2 var_b49e8 = vec2(var_c2b62, 1.0 - var_ace1a);
    var_c3e1b = var_b49e8;
    highp vec4 var_aaba4 = texture(s_txBuffer1, vec2(((var_b49e8 * UVTransform[1].zw) + UVTransform[1].xy).x, 1.0 - ((var_b49e8 * UVTransform[1].zw) + UVTransform[1].xy).y));
    highp vec4 var_53b39 = var_aaba4;
    highp vec2 var_132fc = vec2(v_Additional.x, 1.0 - v_Additional.y);
    highp float var_efb1e = var_132fc.x;
    highp float var_ad18e = var_132fc.y;
    highp vec2 var_13da3 = vec2(var_efb1e, 1.0 - var_ad18e);
    var_132fc = var_13da3;
    highp vec4 var_54245 = texture(s_txBuffer, vec2(((var_13da3 * UVTransform[0].zw) + UVTransform[0].xy).x, 1.0 - ((var_13da3 * UVTransform[0].zw) + UVTransform[0].xy).y));
    highp vec4 var_2fba1 = var_54245 * var_937d7.w;
    highp vec4 var_ab3ef = var_2fba1;
    highp vec3 var_3c560 = var_aaba4.xyz / vec3(max(var_53b39.w, 9.9999997473787516355514526367188e-05));
    highp vec3 var_55a07 = var_2fba1.xyz / vec3(max(var_ab3ef.w, 9.9999997473787516355514526367188e-05));
    highp vec3 var_54e22;
    switch (int(var_341fb.x))
    {
        case 0:
        {
            var_54e22 = var_55a07;
            break;
        }
        case 1:
        {
            var_54e22 = var_3c560 * var_55a07;
            break;
        }
        case 2:
        {
            var_54e22 = (var_3c560 + var_55a07) - (var_3c560 * var_55a07);
            break;
        }
        case 3:
        {
            highp vec3 var_fa7c2 = (var_3c560 * 2.0) - vec3(1.0);
            var_54e22 = mix((var_55a07 + var_fa7c2) - (var_55a07 * var_fa7c2), var_55a07 * (var_3c560 * 2.0), step(var_3c560, vec3(0.5)));
            break;
        }
        case 4:
        {
            var_54e22 = min(var_55a07, var_3c560);
            break;
        }
        case 5:
        {
            var_54e22 = max(var_55a07, var_3c560);
            break;
        }
        case 6:
        {
            var_54e22 = min(var_3c560 / max(vec3(1.0) - var_55a07, vec3(9.9999997473787516355514526367188e-05)), vec3(1.0));
            break;
        }
        case 7:
        {
            var_54e22 = vec3(1.0) - min((vec3(1.0) - var_3c560) / max(var_55a07, vec3(9.9999997473787516355514526367188e-05)), vec3(1.0));
            break;
        }
        case 8:
        {
            highp vec3 var_97a7c = (var_55a07 * 2.0) - vec3(1.0);
            var_54e22 = mix((var_3c560 + var_97a7c) - (var_3c560 * var_97a7c), var_3c560 * (var_55a07 * 2.0), step(var_55a07, vec3(0.5)));
            break;
        }
        case 9:
        {
            var_54e22 = mix(var_3c560 + (((var_55a07 * 2.0) - vec3(1.0)) * (mix(sqrt(var_3c560), ((((var_3c560 * 16.0) - vec3(12.0)) * var_3c560) + vec3(4.0)) * var_3c560, step(var_3c560, vec3(0.25))) - var_3c560)), var_3c560 - (((vec3(1.0) - (var_55a07 * 2.0)) * var_3c560) * (vec3(1.0) - var_3c560)), step(var_55a07, vec3(0.5)));
            break;
        }
        case 10:
        {
            var_54e22 = abs(var_3c560 - var_55a07);
            break;
        }
        case 11:
        {
            var_54e22 = (var_3c560 + var_55a07) - ((var_3c560 * 2.0) * var_55a07);
            break;
        }
        case 12:
        {
            highp vec3 var_8c616 = var_3c560;
            highp float var_eb12b = max(max(var_8c616.x, var_8c616.y), var_8c616.z) - min(min(var_8c616.x, var_8c616.y), var_8c616.z);
            highp vec3 var_55c4b = var_55a07;
            if (var_55c4b.x <= var_55c4b.y)
            {
                if (var_55c4b.y <= var_55c4b.z)
                {
                    highp vec3 var_4a060 = var_55c4b;
                    if (var_4a060.z > var_4a060.x)
                    {
                        var_4a060.y = ((var_4a060.y - var_4a060.x) * var_eb12b) / max(var_4a060.z - var_4a060.x, 9.9999997473787516355514526367188e-05);
                        var_4a060.z = var_eb12b;
                    }
                    else
                    {
                        var_4a060.y = 0.0;
                        var_4a060.z = 0.0;
                    }
                    var_55c4b = vec3(0.0, var_4a060.y, var_4a060.z);
                }
                else
                {
                    if (var_55c4b.x <= var_55c4b.z)
                    {
                        highp vec3 var_5ca9c = var_55c4b.xzy;
                        if (var_5ca9c.z > var_5ca9c.x)
                        {
                            var_5ca9c.y = ((var_5ca9c.y - var_5ca9c.x) * var_eb12b) / max(var_5ca9c.z - var_5ca9c.x, 9.9999997473787516355514526367188e-05);
                            var_5ca9c.z = var_eb12b;
                        }
                        else
                        {
                            var_5ca9c.y = 0.0;
                            var_5ca9c.z = 0.0;
                        }
                        highp vec3 var_f67ed = vec3(0.0, var_5ca9c.y, var_5ca9c.z);
                        var_55c4b = vec3(var_f67ed.x, var_f67ed.z, var_f67ed.y);
                    }
                    else
                    {
                        highp vec3 var_c8b3a = var_55c4b.zxy;
                        if (var_c8b3a.z > var_c8b3a.x)
                        {
                            var_c8b3a.y = ((var_c8b3a.y - var_c8b3a.x) * var_eb12b) / max(var_c8b3a.z - var_c8b3a.x, 9.9999997473787516355514526367188e-05);
                            var_c8b3a.z = var_eb12b;
                        }
                        else
                        {
                            var_c8b3a.y = 0.0;
                            var_c8b3a.z = 0.0;
                        }
                        highp vec3 var_315a0 = vec3(0.0, var_c8b3a.y, var_c8b3a.z);
                        var_55c4b = vec3(var_315a0.y, var_315a0.z, var_315a0.x);
                    }
                }
            }
            else
            {
                if (var_55c4b.x <= var_55c4b.z)
                {
                    highp vec3 var_23dd0 = var_55c4b.yxz;
                    if (var_23dd0.z > var_23dd0.x)
                    {
                        var_23dd0.y = ((var_23dd0.y - var_23dd0.x) * var_eb12b) / max(var_23dd0.z - var_23dd0.x, 9.9999997473787516355514526367188e-05);
                        var_23dd0.z = var_eb12b;
                    }
                    else
                    {
                        var_23dd0.y = 0.0;
                        var_23dd0.z = 0.0;
                    }
                    highp vec3 var_414ed = vec3(0.0, var_23dd0.y, var_23dd0.z);
                    var_55c4b = vec3(var_414ed.y, var_414ed.x, var_414ed.z);
                }
                else
                {
                    if (var_55c4b.y <= var_55c4b.z)
                    {
                        highp vec3 var_95e2f = var_55c4b.yzx;
                        if (var_95e2f.z > var_95e2f.x)
                        {
                            var_95e2f.y = ((var_95e2f.y - var_95e2f.x) * var_eb12b) / max(var_95e2f.z - var_95e2f.x, 9.9999997473787516355514526367188e-05);
                            var_95e2f.z = var_eb12b;
                        }
                        else
                        {
                            var_95e2f.y = 0.0;
                            var_95e2f.z = 0.0;
                        }
                        highp vec3 var_7a150 = vec3(0.0, var_95e2f.y, var_95e2f.z);
                        var_55c4b = vec3(var_7a150.z, var_7a150.x, var_7a150.y);
                    }
                    else
                    {
                        highp vec3 var_3cb07 = var_55c4b.zyx;
                        if (var_3cb07.z > var_3cb07.x)
                        {
                            var_3cb07.y = ((var_3cb07.y - var_3cb07.x) * var_eb12b) / max(var_3cb07.z - var_3cb07.x, 9.9999997473787516355514526367188e-05);
                            var_3cb07.z = var_eb12b;
                        }
                        else
                        {
                            var_3cb07.y = 0.0;
                            var_3cb07.z = 0.0;
                        }
                        highp vec3 var_b1fa1 = vec3(0.0, var_3cb07.y, var_3cb07.z);
                        var_55c4b = vec3(var_b1fa1.z, var_b1fa1.y, var_b1fa1.x);
                    }
                }
            }
            highp vec3 var_780e1 = var_3c560;
            highp vec3 var_195db = var_55c4b;
            highp vec3 var_9e21f = var_55c4b + vec3((((0.2125999927520751953125 * var_780e1.x) + (0.715200006961822509765625 * var_780e1.y)) + (0.072200000286102294921875 * var_780e1.z)) - (((0.2125999927520751953125 * var_195db.x) + (0.715200006961822509765625 * var_195db.y)) + (0.072200000286102294921875 * var_195db.z)));
            highp vec3 var_61c3f = var_9e21f;
            highp vec3 var_3f137 = var_9e21f;
            highp float var_6ecec = ((0.2125999927520751953125 * var_3f137.x) + (0.715200006961822509765625 * var_3f137.y)) + (0.072200000286102294921875 * var_3f137.z);
            highp float var_fc727 = min(min(var_61c3f.x, var_61c3f.y), var_61c3f.z);
            highp float var_bc88e = var_61c3f.x;
            highp float var_c3550 = var_61c3f.y;
            highp float var_b4468 = var_61c3f.z;
            highp float var_eb7cb = max(max(var_bc88e, var_c3550), var_b4468);
            if (var_fc727 < 0.0)
            {
                var_61c3f = vec3(var_6ecec) + (((var_61c3f - vec3(var_6ecec)) * var_6ecec) / vec3(max(var_6ecec - var_fc727, 9.9999997473787516355514526367188e-05)));
            }
            if (var_eb7cb > 1.0)
            {
                var_61c3f = vec3(var_6ecec) + (((var_61c3f - vec3(var_6ecec)) * (1.0 - var_6ecec)) / vec3(max(var_eb7cb - var_6ecec, 9.9999997473787516355514526367188e-05)));
            }
            var_54e22 = var_61c3f;
            break;
        }
        case 13:
        {
            highp vec3 var_4d780 = var_55a07;
            highp float var_6b48b = max(max(var_4d780.x, var_4d780.y), var_4d780.z) - min(min(var_4d780.x, var_4d780.y), var_4d780.z);
            highp vec3 var_51615 = var_3c560;
            if (var_51615.x <= var_51615.y)
            {
                if (var_51615.y <= var_51615.z)
                {
                    highp vec3 var_8e9bd = var_51615;
                    if (var_8e9bd.z > var_8e9bd.x)
                    {
                        var_8e9bd.y = ((var_8e9bd.y - var_8e9bd.x) * var_6b48b) / max(var_8e9bd.z - var_8e9bd.x, 9.9999997473787516355514526367188e-05);
                        var_8e9bd.z = var_6b48b;
                    }
                    else
                    {
                        var_8e9bd.y = 0.0;
                        var_8e9bd.z = 0.0;
                    }
                    var_51615 = vec3(0.0, var_8e9bd.y, var_8e9bd.z);
                }
                else
                {
                    if (var_51615.x <= var_51615.z)
                    {
                        highp vec3 var_b942d = var_51615.xzy;
                        if (var_b942d.z > var_b942d.x)
                        {
                            var_b942d.y = ((var_b942d.y - var_b942d.x) * var_6b48b) / max(var_b942d.z - var_b942d.x, 9.9999997473787516355514526367188e-05);
                            var_b942d.z = var_6b48b;
                        }
                        else
                        {
                            var_b942d.y = 0.0;
                            var_b942d.z = 0.0;
                        }
                        highp vec3 var_c98ca = vec3(0.0, var_b942d.y, var_b942d.z);
                        var_51615 = vec3(var_c98ca.x, var_c98ca.z, var_c98ca.y);
                    }
                    else
                    {
                        highp vec3 var_ec4fe = var_51615.zxy;
                        if (var_ec4fe.z > var_ec4fe.x)
                        {
                            var_ec4fe.y = ((var_ec4fe.y - var_ec4fe.x) * var_6b48b) / max(var_ec4fe.z - var_ec4fe.x, 9.9999997473787516355514526367188e-05);
                            var_ec4fe.z = var_6b48b;
                        }
                        else
                        {
                            var_ec4fe.y = 0.0;
                            var_ec4fe.z = 0.0;
                        }
                        highp vec3 var_6717a = vec3(0.0, var_ec4fe.y, var_ec4fe.z);
                        var_51615 = vec3(var_6717a.y, var_6717a.z, var_6717a.x);
                    }
                }
            }
            else
            {
                if (var_51615.x <= var_51615.z)
                {
                    highp vec3 var_cbaec = var_51615.yxz;
                    if (var_cbaec.z > var_cbaec.x)
                    {
                        var_cbaec.y = ((var_cbaec.y - var_cbaec.x) * var_6b48b) / max(var_cbaec.z - var_cbaec.x, 9.9999997473787516355514526367188e-05);
                        var_cbaec.z = var_6b48b;
                    }
                    else
                    {
                        var_cbaec.y = 0.0;
                        var_cbaec.z = 0.0;
                    }
                    highp vec3 var_1cde4 = vec3(0.0, var_cbaec.y, var_cbaec.z);
                    var_51615 = vec3(var_1cde4.y, var_1cde4.x, var_1cde4.z);
                }
                else
                {
                    if (var_51615.y <= var_51615.z)
                    {
                        highp vec3 var_69be8 = var_51615.yzx;
                        if (var_69be8.z > var_69be8.x)
                        {
                            var_69be8.y = ((var_69be8.y - var_69be8.x) * var_6b48b) / max(var_69be8.z - var_69be8.x, 9.9999997473787516355514526367188e-05);
                            var_69be8.z = var_6b48b;
                        }
                        else
                        {
                            var_69be8.y = 0.0;
                            var_69be8.z = 0.0;
                        }
                        highp vec3 var_57c96 = vec3(0.0, var_69be8.y, var_69be8.z);
                        var_51615 = vec3(var_57c96.z, var_57c96.x, var_57c96.y);
                    }
                    else
                    {
                        highp vec3 var_d5d20 = var_51615.zyx;
                        if (var_d5d20.z > var_d5d20.x)
                        {
                            var_d5d20.y = ((var_d5d20.y - var_d5d20.x) * var_6b48b) / max(var_d5d20.z - var_d5d20.x, 9.9999997473787516355514526367188e-05);
                            var_d5d20.z = var_6b48b;
                        }
                        else
                        {
                            var_d5d20.y = 0.0;
                            var_d5d20.z = 0.0;
                        }
                        highp vec3 var_64f55 = vec3(0.0, var_d5d20.y, var_d5d20.z);
                        var_51615 = vec3(var_64f55.z, var_64f55.y, var_64f55.x);
                    }
                }
            }
            highp vec3 var_5b0a5 = var_3c560;
            highp vec3 var_776b5 = var_51615;
            highp vec3 var_13e54 = var_51615 + vec3((((0.2125999927520751953125 * var_5b0a5.x) + (0.715200006961822509765625 * var_5b0a5.y)) + (0.072200000286102294921875 * var_5b0a5.z)) - (((0.2125999927520751953125 * var_776b5.x) + (0.715200006961822509765625 * var_776b5.y)) + (0.072200000286102294921875 * var_776b5.z)));
            highp vec3 var_6e1a6 = var_13e54;
            highp vec3 var_6a75b = var_13e54;
            highp float var_3273f = ((0.2125999927520751953125 * var_6a75b.x) + (0.715200006961822509765625 * var_6a75b.y)) + (0.072200000286102294921875 * var_6a75b.z);
            highp float var_d02ac = min(min(var_6e1a6.x, var_6e1a6.y), var_6e1a6.z);
            highp float var_09da4 = var_6e1a6.x;
            highp float var_34cb6 = var_6e1a6.y;
            highp float var_b2ac4 = var_6e1a6.z;
            highp float var_fc8e2 = max(max(var_09da4, var_34cb6), var_b2ac4);
            if (var_d02ac < 0.0)
            {
                var_6e1a6 = vec3(var_3273f) + (((var_6e1a6 - vec3(var_3273f)) * var_3273f) / vec3(max(var_3273f - var_d02ac, 9.9999997473787516355514526367188e-05)));
            }
            if (var_fc8e2 > 1.0)
            {
                var_6e1a6 = vec3(var_3273f) + (((var_6e1a6 - vec3(var_3273f)) * (1.0 - var_3273f)) / vec3(max(var_fc8e2 - var_3273f, 9.9999997473787516355514526367188e-05)));
            }
            var_54e22 = var_6e1a6;
            break;
        }
        case 14:
        {
            highp vec3 var_a74d2 = var_3c560;
            highp vec3 var_6663f = var_55a07;
            highp vec3 var_79139 = var_55a07 + vec3((((0.2125999927520751953125 * var_a74d2.x) + (0.715200006961822509765625 * var_a74d2.y)) + (0.072200000286102294921875 * var_a74d2.z)) - (((0.2125999927520751953125 * var_6663f.x) + (0.715200006961822509765625 * var_6663f.y)) + (0.072200000286102294921875 * var_6663f.z)));
            highp vec3 var_6bcf9 = var_79139;
            highp vec3 var_da0a3 = var_79139;
            highp float var_ec696 = ((0.2125999927520751953125 * var_da0a3.x) + (0.715200006961822509765625 * var_da0a3.y)) + (0.072200000286102294921875 * var_da0a3.z);
            highp float var_c79c1 = min(min(var_6bcf9.x, var_6bcf9.y), var_6bcf9.z);
            highp float var_b2a9f = var_6bcf9.x;
            highp float var_d2023 = var_6bcf9.y;
            highp float var_236f2 = var_6bcf9.z;
            highp float var_26c05 = max(max(var_b2a9f, var_d2023), var_236f2);
            if (var_c79c1 < 0.0)
            {
                var_6bcf9 = vec3(var_ec696) + (((var_6bcf9 - vec3(var_ec696)) * var_ec696) / vec3(max(var_ec696 - var_c79c1, 9.9999997473787516355514526367188e-05)));
            }
            if (var_26c05 > 1.0)
            {
                var_6bcf9 = vec3(var_ec696) + (((var_6bcf9 - vec3(var_ec696)) * (1.0 - var_ec696)) / vec3(max(var_26c05 - var_ec696, 9.9999997473787516355514526367188e-05)));
            }
            var_54e22 = var_6bcf9;
            break;
        }
        case 15:
        {
            highp vec3 var_88167 = var_55a07;
            highp vec3 var_e692d = var_3c560;
            highp vec3 var_9f80d = var_3c560 + vec3((((0.2125999927520751953125 * var_88167.x) + (0.715200006961822509765625 * var_88167.y)) + (0.072200000286102294921875 * var_88167.z)) - (((0.2125999927520751953125 * var_e692d.x) + (0.715200006961822509765625 * var_e692d.y)) + (0.072200000286102294921875 * var_e692d.z)));
            highp vec3 var_b66b4 = var_9f80d;
            highp vec3 var_ac9fb = var_9f80d;
            highp float var_e0967 = ((0.2125999927520751953125 * var_ac9fb.x) + (0.715200006961822509765625 * var_ac9fb.y)) + (0.072200000286102294921875 * var_ac9fb.z);
            highp float var_61de2 = min(min(var_b66b4.x, var_b66b4.y), var_b66b4.z);
            highp float var_eead3 = var_b66b4.x;
            highp float var_25f04 = var_b66b4.y;
            highp float var_820b4 = var_b66b4.z;
            highp float var_5b07c = max(max(var_eead3, var_25f04), var_820b4);
            if (var_61de2 < 0.0)
            {
                var_b66b4 = vec3(var_e0967) + (((var_b66b4 - vec3(var_e0967)) * var_e0967) / vec3(max(var_e0967 - var_61de2, 9.9999997473787516355514526367188e-05)));
            }
            if (var_5b07c > 1.0)
            {
                var_b66b4 = vec3(var_e0967) + (((var_b66b4 - vec3(var_e0967)) * (1.0 - var_e0967)) / vec3(max(var_5b07c - var_e0967, 9.9999997473787516355514526367188e-05)));
            }
            var_54e22 = var_b66b4;
            break;
        }
        case 16:
        {
            var_54e22 = min(var_55a07 + var_3c560, vec3(1.0));
            break;
        }
        default:
        {
            var_54e22 = vec3(0.0);
            break;
        }
    }
    bgfx_FragData0 = ((var_2fba1 * (1.0 - var_53b39.w)) + (vec4(clamp(var_54e22, vec3(0.0), vec3(1.0)), 1.0) * (var_ab3ef.w * var_53b39.w))) + (var_aaba4 * (1.0 - var_ab3ef.w));
}
