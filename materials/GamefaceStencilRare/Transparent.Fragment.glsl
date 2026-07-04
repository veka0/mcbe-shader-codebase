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
* - uniform lowp sampler2D s_Texture2;
* - uniform lowp sampler2D s_Texture3;
*
* Uniforms:
* - uniform vec4 Coefficients[3];
* - uniform vec4 PixelOffsets[6];
* - uniform vec4 PrimProps0;
* - uniform vec4 PrimProps1;
* - uniform vec4 ShaderType;
* - uniform mat4 Transform;
* - uniform vec4 Viewport;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_Texture0;
uniform highp sampler2D s_Texture1;
uniform highp sampler2D s_Texture2;
uniform highp sampler2D s_Texture3;
uniform highp vec4 Coefficients[3];
uniform highp vec4 PixelOffsets[6];
uniform highp vec4 PrimProps0;
uniform highp vec4 PrimProps1;
uniform highp vec4 ShaderType;
in highp vec4 v_additional;
in highp vec4 v_color;
in highp vec4 v_screenPosition;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_dba13 = v_color;
    highp vec4 var_ebbd5 = v_additional;
    highp vec4 var_f86b9 = v_color;
    highp vec4 var_a6719 = v_color;
    highp float var_8a542;
    if (int(ShaderType.x) == 1)
    {
        var_8a542 = clamp(0.5 - (length(v_screenPosition.xy - v_additional.xy) - var_ebbd5.z), 0.0, 1.0);
    }
    else
    {
        highp float var_7cf8f;
        if (int(ShaderType.x) == 2)
        {
            highp float var_1a928 = length(v_screenPosition.xy - v_additional.xy);
            var_7cf8f = clamp(0.5 - (var_1a928 - (var_ebbd5.z + (var_ebbd5.w * 0.5))), 0.0, 1.0) * (1.0 - clamp(0.5 - (var_1a928 - (var_ebbd5.z - (var_ebbd5.w * 0.5))), 0.0, 1.0));
        }
        else
        {
            highp float var_6c060;
            if (int(ShaderType.x) == 4)
            {
                highp vec2 var_1ef6d = (v_screenPosition.xy - v_additional.xy) / v_additional.zw;
                highp vec2 var_54443 = var_1ef6d;
                highp vec2 var_deda4 = dFdx(var_1ef6d);
                highp vec2 var_bf046 = dFdy(var_1ef6d);
                highp vec2 var_c8c88 = vec2(((2.0 * var_54443.x) * var_deda4.x) + ((2.0 * var_54443.y) * var_deda4.y), ((2.0 * var_54443.x) * var_bf046.x) + ((2.0 * var_54443.y) * var_bf046.y));
                var_6c060 = clamp(0.5 - ((dot(var_1ef6d, var_1ef6d) - 1.0) * inversesqrt(max(dot(var_c8c88, var_c8c88), 9.9999997473787516355514526367188e-05))), 0.0, 1.0);
            }
            else
            {
                highp float var_694ba;
                if (int(ShaderType.x) == 5)
                {
                    highp vec2 var_25f7e = (v_screenPosition.xy - v_additional.xy) / (v_additional.zw + vec2(PrimProps0.x * 0.5));
                    highp vec2 var_63ffa = var_25f7e;
                    highp vec2 var_99e23 = dFdx(var_25f7e);
                    highp vec2 var_ee45b = dFdy(var_25f7e);
                    highp vec2 var_5cc16 = vec2(((2.0 * var_63ffa.x) * var_99e23.x) + ((2.0 * var_63ffa.y) * var_99e23.y), ((2.0 * var_63ffa.x) * var_ee45b.x) + ((2.0 * var_63ffa.y) * var_ee45b.y));
                    highp vec2 var_1bae6 = (v_screenPosition.xy - v_additional.xy) / (v_additional.zw - vec2(PrimProps0.x * 0.5));
                    highp vec2 var_80f0e = var_1bae6;
                    highp vec2 var_676ed = dFdx(var_1bae6);
                    highp vec2 var_2c3da = dFdy(var_1bae6);
                    highp vec2 var_c2fe3 = vec2(((2.0 * var_80f0e.x) * var_676ed.x) + ((2.0 * var_80f0e.y) * var_676ed.y), ((2.0 * var_80f0e.x) * var_2c3da.x) + ((2.0 * var_80f0e.y) * var_2c3da.y));
                    var_694ba = clamp(0.5 - ((dot(var_25f7e, var_25f7e) - 1.0) * inversesqrt(max(dot(var_5cc16, var_5cc16), 9.9999997473787516355514526367188e-05))), 0.0, 1.0) * clamp(0.5 + ((dot(var_1bae6, var_1bae6) - 1.0) * inversesqrt(max(dot(var_c2fe3, var_c2fe3), 9.9999997473787516355514526367188e-05))), 0.0, 1.0);
                }
                else
                {
                    highp float var_ddde2;
                    if (int(ShaderType.x) == 6)
                    {
                        var_a6719 = vec4(0.0);
                        int var_1bbba = int(PrimProps0.x);
                        highp vec2 var_b0bd2;
                        for (int var_e0188 = 0; var_e0188 < var_1bbba; var_e0188++)
                        {
                            var_b0bd2.x = PixelOffsets[(var_e0188 * 2) / 4][int(mod(float(var_e0188 * 2), 4.0))];
                            var_b0bd2.y = PixelOffsets[((var_e0188 * 2) + 1) / 4][int(mod(float((var_e0188 * 2) + 1), 4.0))];
                            var_a6719 += ((texture(s_Texture0, v_additional.xy + var_b0bd2) + texture(s_Texture0, v_additional.xy - var_b0bd2)) * Coefficients[var_e0188 / 4][int(mod(float(var_e0188), 4.0))]);
                        }
                        var_ddde2 = var_f86b9.w;
                    }
                    else
                    {
                        highp float var_c7867;
                        if (int(ShaderType.x) == 7)
                        {
                            highp vec4 var_5ca43 = texture(s_Texture0, v_additional.xy);
                            highp vec4 var_e7cba = var_5ca43;
                            highp float var_6215c = var_e7cba.w;
                            highp float var_598f3 = max(var_6215c, 9.9999997473787516355514526367188e-06);
                            highp vec4 var_b17d8 = vec4(var_5ca43.xyz / vec3(var_598f3), var_598f3);
                            var_e7cba = var_b17d8;
                            var_a6719.x = dot(var_b17d8, Coefficients[0]);
                            var_a6719.y = dot(var_b17d8, Coefficients[1]);
                            var_a6719.z = dot(var_b17d8, Coefficients[2]);
                            var_a6719.w = dot(var_b17d8, PixelOffsets[0]);
                            var_a6719 += PixelOffsets[1];
                            highp float var_87604 = var_a6719.w;
                            var_a6719.w = 1.0;
                            var_c7867 = var_87604 * var_f86b9.w;
                        }
                        else
                        {
                            bool var_95a6d = int(ShaderType.x) == 9;
                            bool var_e1f3d;
                            if (!var_95a6d)
                            {
                                var_e1f3d = int(ShaderType.x) == 12;
                            }
                            else
                            {
                                var_e1f3d = var_95a6d;
                            }
                            highp float var_97871;
                            if (var_e1f3d)
                            {
                                highp vec3 var_dada2;
                                var_dada2.x = texture(s_Texture0, v_additional.xy).x;
                                var_dada2.y = texture(s_Texture1, v_additional.xy).x;
                                var_dada2.z = texture(s_Texture2, v_additional.xy).x;
                                highp vec3 var_0a617 = var_dada2;
                                highp vec3 var_2ed72 = var_0a617 - vec3(0.0625, 0.5, 0.5);
                                var_dada2 = var_2ed72;
                                var_a6719 = vec4(transpose(mat3(vec3(1.164000034332275390625, 0.0, 1.5959999561309814453125), vec3(1.164000034332275390625, -0.3910000026226043701171875, -0.813000023365020751953125), vec3(1.164000034332275390625, 2.0179998874664306640625, 0.0))) * var_2ed72, 1.0);
                                highp float var_57162;
                                if (int(ShaderType.x) == 12)
                                {
                                    var_57162 = var_f86b9.w * texture(s_Texture3, v_additional.xy).x;
                                }
                                else
                                {
                                    var_57162 = var_f86b9.w;
                                }
                                var_97871 = var_57162;
                            }
                            else
                            {
                                highp float var_cd829;
                                if (int(ShaderType.x) == 11)
                                {
                                    var_cd829 = 1.0 - clamp(abs(dot(v_additional.xyz, vec3(v_screenPosition.xy, 1.0))), 0.0, 1.0);
                                }
                                else
                                {
                                    if (int(ShaderType.x) == 19)
                                    {
                                        highp float var_74503 = sqrt(PrimProps0.y * 0.5);
                                        highp float var_75ea4 = (0.5 * var_74503) - 0.89999997615814208984375;
                                        highp float var_3311a = ((PrimProps0.z / PrimProps0.y) * 0.5) * var_74503;
                                        highp float var_74c46 = texture(s_Texture0, v_additional.xy).x * var_74503;
                                        var_a6719 = mix(PrimProps1, v_color, vec4(clamp(var_74c46 - (var_75ea4 + var_3311a), 0.0, 1.0))) * clamp(var_74c46 - max(0.0, var_75ea4 - var_3311a), 0.0, 1.0);
                                    }
                                    var_cd829 = 1.0;
                                }
                                var_97871 = var_cd829;
                            }
                            var_c7867 = var_97871;
                        }
                        var_ddde2 = var_c7867;
                    }
                    var_694ba = var_ddde2;
                }
                var_6c060 = var_694ba;
            }
            var_7cf8f = var_6c060;
        }
        var_8a542 = var_7cf8f;
    }
    var_dba13 = var_a6719;
    highp float var_49df2;
    if (int(ShaderType.x) == 3)
    {
        var_49df2 = var_dba13.w;
    }
    else
    {
        var_49df2 = var_8a542;
    }
    if (var_49df2 < 0.00390625)
    {
        discard;
    }
    bgfx_FragColor = vec4(1.0);
}
