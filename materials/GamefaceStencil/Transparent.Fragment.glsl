#version 310 es

/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*
* showDF:
* - SHOW_DF__OFF
* - SHOW_DF__ON
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_Texture0;
* - uniform lowp sampler2D s_Texture1;
* - uniform lowp sampler2D s_Texture2;
*
* Uniforms:
* - uniform vec4 PrimProps0;
* - uniform vec4 PrimProps1;
* - uniform vec4 ShaderType;
* - uniform mat4 Transform;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_Texture0;
uniform highp sampler2D s_Texture1;
uniform highp sampler2D s_Texture2;
#ifdef SHOW_DF__OFF
uniform highp vec4 PrimProps0;
#endif
uniform highp vec4 PrimProps1;
uniform highp vec4 ShaderType;
in highp vec4 v_additional;
in highp vec4 v_color;
layout(location = 0) out highp vec4 bgfx_FragColor;
#ifdef SHOW_DF__ON
void func_38d1f(inout highp vec4 arg_d26a2, inout highp vec4 arg_42967, inout highp vec4 arg_3993f, inout highp float arg_e811a) {
    highp float loc_1f5c6;
    if (0.0 == ShaderType.x)
    {
        loc_1f5c6 = min(1.0, arg_d26a2.z * arg_d26a2.w);
    }
    else
    {
        if (3.0 == ShaderType.x)
        {
            highp vec2 loc_e517a = v_additional.xy;
            bool loc_7ea7b = PrimProps1.z != (-1.0);
            bool loc_eb95b;
            if (!loc_7ea7b)
            {
                loc_eb95b = PrimProps1.w != (-1.0);
            }
            else
            {
                loc_eb95b = loc_7ea7b;
            }
            if (loc_eb95b)
            {
                loc_e517a.x = clamp(arg_d26a2.x, PrimProps1.x, PrimProps1.x + PrimProps1.z);
                loc_e517a.y = clamp(arg_d26a2.y, PrimProps1.y, PrimProps1.y + PrimProps1.w);
            }
            arg_42967 = texture(s_Texture0, loc_e517a);
            arg_42967.w = mix(1.0 - arg_42967.w, arg_42967.w, arg_3993f.x);
        }
        else
        {
            if (17.0 == ShaderType.x)
            {
                arg_42967 = v_color * pow(abs(texture(s_Texture1, v_additional.xy).x), 1.4500000476837158203125 - (((0.2125999927520751953125 * v_color.x) + (0.715200006961822509765625 * v_color.y)) + (0.072200000286102294921875 * v_color.z)));
            }
            else
            {
                if (18.0 == ShaderType.x)
                {
                    arg_42967 = vec4(texture(s_Texture2, v_additional.xy).xxx, 1.0);
                    arg_e811a = 1.0;
                    return;
                }
            }
        }
        loc_1f5c6 = 1.0;
    }
    arg_e811a = loc_1f5c6;
}
#endif
void main() {
    highp vec4 var_dba13 = v_color;
    highp vec4 var_485f0 = v_additional;
    highp vec4 var_5ea8a = v_color;
    highp vec4 var_97e81 = v_color;
    highp float var_42517;
#ifdef SHOW_DF__OFF
    if (0.0 == ShaderType.x)
    {
        var_42517 = min(1.0, var_485f0.z * var_485f0.w);
    }
    else
    {
        if (3.0 == ShaderType.x)
        {
            highp vec2 var_e517a = v_additional.xy;
            bool var_7ea7b = PrimProps1.z != (-1.0);
            bool var_eb95b;
            if (!var_7ea7b)
            {
                var_eb95b = PrimProps1.w != (-1.0);
            }
            else
            {
                var_eb95b = var_7ea7b;
            }
            if (var_eb95b)
            {
                var_e517a.x = clamp(var_485f0.x, PrimProps1.x, PrimProps1.x + PrimProps1.z);
                var_e517a.y = clamp(var_485f0.y, PrimProps1.y, PrimProps1.y + PrimProps1.w);
            }
            var_97e81 = texture(s_Texture0, var_e517a);
            var_97e81.w = mix(1.0 - var_97e81.w, var_97e81.w, var_5ea8a.x);
        }
        else
        {
            if (17.0 == ShaderType.x)
            {
                var_97e81 = v_color * pow(abs(texture(s_Texture1, v_additional.xy).x), 1.4500000476837158203125 - (((0.2125999927520751953125 * v_color.x) + (0.715200006961822509765625 * v_color.y)) + (0.072200000286102294921875 * v_color.z)));
            }
            else
            {
                if (18.0 == ShaderType.x)
                {
                    var_97e81 = v_color * pow(abs(smoothstep((-0.501960813999176025390625) / PrimProps0.x, 0.501960813999176025390625 / PrimProps0.x, (texture(s_Texture2, v_additional.xy).x * 7.96875) - 3.984375)), 1.4500000476837158203125 - (((0.2125999927520751953125 * v_color.x) + (0.715200006961822509765625 * v_color.y)) + (0.072200000286102294921875 * v_color.z)));
                }
            }
        }
        var_42517 = 1.0;
    }
#endif
#ifdef SHOW_DF__ON
    func_38d1f(var_485f0, var_97e81, var_5ea8a, var_42517);
#endif
    var_dba13 = var_97e81;
    highp float var_49df2;
    if (3.0 == ShaderType.x)
    {
        var_49df2 = var_dba13.w;
    }
    else
    {
        var_49df2 = var_42517;
    }
    if (var_49df2 < 0.00390625)
    {
        discard;
    }
    bgfx_FragColor = vec4(1.0);
}
