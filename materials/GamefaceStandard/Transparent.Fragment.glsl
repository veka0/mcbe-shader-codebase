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
* - uniform vec4 TextureSize1;
* - uniform mat4 Transform;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_Texture0;
uniform highp sampler2D s_Texture1;
uniform highp sampler2D s_Texture2;
uniform highp vec4 PrimProps1;
uniform highp vec4 ShaderType;
uniform highp vec4 TextureSize1;
in highp vec4 v_additional;
in highp vec4 v_color;
layout(location = 0) out highp vec4 bgfx_FragColor;
#ifdef SHOW_DF__ON
void func_f9079(inout highp vec4 arg_44c6a, inout highp vec4 arg_6cb6d, inout highp vec4 arg_6cc22, inout highp float arg_e811a) {
    highp float loc_e6bc5;
    if (0.0 == ShaderType.x)
    {
        loc_e6bc5 = min(1.0, arg_44c6a.z * arg_44c6a.w);
    }
    else
    {
        highp float loc_f4dd1;
        if (3.0 == ShaderType.x)
        {
            highp vec2 loc_0c488 = v_additional.xy;
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
                loc_0c488 = clamp(loc_0c488, PrimProps1.xy, PrimProps1.xy + PrimProps1.zw);
            }
            highp float loc_74cec = loc_0c488.x;
            highp float loc_83bc9 = loc_0c488.y;
            highp vec2 loc_8f1e9 = vec2(loc_74cec, 1.0 - loc_83bc9);
            loc_0c488 = loc_8f1e9;
            arg_6cb6d = texture(s_Texture0, loc_8f1e9);
            arg_6cb6d.w = mix(1.0 - arg_6cb6d.w, arg_6cb6d.w, arg_6cc22.x);
            arg_6cb6d.w = mix(((0.2125999927520751953125 * arg_6cb6d.x) + (0.715200006961822509765625 * arg_6cb6d.y)) + (0.072200000286102294921875 * arg_6cb6d.z), arg_6cb6d.w, arg_6cc22.z);
            loc_f4dd1 = arg_6cc22.w * clamp(arg_44c6a.z, 0.0, 1.0);
        }
        else
        {
            if (17.0 == ShaderType.x)
            {
                highp vec2 loc_a0815 = vec2(arg_44c6a.x, arg_44c6a.y);
                highp vec2 loc_f41d2 = floor(vec2(loc_a0815.x * TextureSize1.x, loc_a0815.y * TextureSize1.y)) + vec2(0.5);
                arg_6cb6d = v_color * pow(abs(texture(s_Texture1, vec2(loc_f41d2.x / TextureSize1.x, loc_f41d2.y / TextureSize1.y)).x), 1.4500000476837158203125 - (((0.2125999927520751953125 * v_color.x) + (0.715200006961822509765625 * v_color.y)) + (0.072200000286102294921875 * v_color.z)));
            }
            else
            {
                if (18.0 == ShaderType.x)
                {
                    arg_6cb6d = vec4(texture(s_Texture2, vec2(arg_44c6a.x, arg_44c6a.y)).xxx, 1.0);
                    arg_e811a = 1.0;
                    return;
                }
            }
            loc_f4dd1 = 1.0;
        }
        loc_e6bc5 = loc_f4dd1;
    }
    arg_e811a = loc_e6bc5;
}
#endif
void main() {
    highp vec4 var_b641f = v_additional;
    highp vec4 var_178af = v_color;
    highp vec4 var_95961 = v_color;
    highp float var_0eaaa;
#ifdef SHOW_DF__OFF
    if (0.0 == ShaderType.x)
    {
        var_0eaaa = min(1.0, var_b641f.z * var_b641f.w);
    }
    else
    {
        highp float var_f4dd1;
        if (3.0 == ShaderType.x)
        {
            highp vec2 var_9ff7d = v_additional.xy;
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
                var_9ff7d = clamp(var_9ff7d, PrimProps1.xy, PrimProps1.xy + PrimProps1.zw);
            }
            highp float var_74cec = var_9ff7d.x;
            highp float var_83bc9 = var_9ff7d.y;
            highp vec2 var_8f1e9 = vec2(var_74cec, 1.0 - var_83bc9);
            var_9ff7d = var_8f1e9;
            var_95961 = texture(s_Texture0, var_8f1e9);
            var_95961.w = mix(1.0 - var_95961.w, var_95961.w, var_178af.x);
            var_95961.w = mix(((0.2125999927520751953125 * var_95961.x) + (0.715200006961822509765625 * var_95961.y)) + (0.072200000286102294921875 * var_95961.z), var_95961.w, var_178af.z);
            var_f4dd1 = var_178af.w * clamp(var_b641f.z, 0.0, 1.0);
        }
        else
        {
            if (17.0 == ShaderType.x)
            {
                highp vec2 var_38988 = vec2(var_b641f.x, var_b641f.y);
                highp vec2 var_d692e = floor(vec2(var_38988.x * TextureSize1.x, var_38988.y * TextureSize1.y)) + vec2(0.5);
                var_95961 = v_color * pow(abs(texture(s_Texture1, vec2(var_d692e.x / TextureSize1.x, var_d692e.y / TextureSize1.y)).x), 1.4500000476837158203125 - (((0.2125999927520751953125 * v_color.x) + (0.715200006961822509765625 * v_color.y)) + (0.072200000286102294921875 * v_color.z)));
            }
            else
            {
                if (18.0 == ShaderType.x)
                {
                    var_95961 = v_color * pow(smoothstep((-0.501960813999176025390625) / var_b641f.z, 0.501960813999176025390625 / var_b641f.z, (texture(s_Texture2, vec2(var_b641f.x, var_b641f.y)).x * 7.96875) - 3.984375), 1.4500000476837158203125 - (((0.2125999927520751953125 * v_color.x) + (0.715200006961822509765625 * v_color.y)) + (0.072200000286102294921875 * v_color.z)));
                }
            }
            var_f4dd1 = 1.0;
        }
        var_0eaaa = var_f4dd1;
    }
#endif
#ifdef SHOW_DF__ON
    func_f9079(var_b641f, var_95961, var_178af, var_0eaaa);
#endif
    bgfx_FragColor = var_95961 * var_0eaaa;
}
