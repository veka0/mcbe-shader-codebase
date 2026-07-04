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
* - uniform vec4 TextureSize1;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_Texture0;
uniform highp sampler2D s_Texture1;
uniform highp sampler2D s_Texture2;
uniform highp vec4 PrimProps1;
uniform highp vec4 TextureSize1;
in highp vec4 v_additional;
in highp vec4 v_color;
in highp float v_shaderType;
layout(location = 0) out highp vec4 bgfx_FragColor;
#ifdef SHOW_DF__ON
void func_0a721(inout highp vec4 arg_1c42e, inout highp vec4 arg_3524b, inout highp vec4 arg_6cc22, inout highp float arg_e811a) {
    int loc_23498 = int(v_shaderType);
    highp float loc_838bb;
    if (0.0 == float(loc_23498))
    {
        loc_838bb = min(1.0, arg_1c42e.x * arg_1c42e.y);
    }
    else
    {
        highp float loc_f4dd1;
        if (3.0 == float(loc_23498))
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
            arg_3524b = texture(s_Texture0, loc_8f1e9);
            arg_3524b.w = mix(1.0 - arg_3524b.w, arg_3524b.w, arg_6cc22.x);
            arg_3524b.w = mix(((0.2125999927520751953125 * arg_3524b.x) + (0.715200006961822509765625 * arg_3524b.y)) + (0.072200000286102294921875 * arg_3524b.z), arg_3524b.w, arg_6cc22.z);
            loc_f4dd1 = arg_6cc22.w * clamp(arg_1c42e.z, 0.0, 1.0);
        }
        else
        {
            if (17.0 == float(loc_23498))
            {
                highp vec2 loc_a0815 = vec2(arg_1c42e.x, arg_1c42e.y);
                highp vec2 loc_f41d2 = floor(vec2(loc_a0815.x * TextureSize1.x, loc_a0815.y * TextureSize1.y)) + vec2(0.5);
                arg_3524b = v_color * pow(abs(texture(s_Texture1, vec2(loc_f41d2.x / TextureSize1.x, loc_f41d2.y / TextureSize1.y)).x), 1.4500000476837158203125 - (((0.2125999927520751953125 * v_color.x) + (0.715200006961822509765625 * v_color.y)) + (0.072200000286102294921875 * v_color.z)));
            }
            else
            {
                if (18.0 == float(loc_23498))
                {
                    arg_3524b = vec4(texture(s_Texture2, v_additional.xy).xxx, 1.0);
                    arg_e811a = 1.0;
                    return;
                }
            }
            loc_f4dd1 = 1.0;
        }
        loc_838bb = loc_f4dd1;
    }
    arg_e811a = loc_838bb;
}
#endif
void main() {
    highp vec4 var_1f0ae = v_additional;
    highp vec4 var_178af = v_color;
    highp vec4 var_d1af8 = v_color;
#ifdef SHOW_DF__OFF
    int var_23498 = int(v_shaderType);
#endif
    highp float var_94361;
#ifdef SHOW_DF__OFF
    if (0.0 == float(var_23498))
    {
        var_94361 = min(1.0, var_1f0ae.x * var_1f0ae.y);
    }
    else
    {
        highp float var_f4dd1;
        if (3.0 == float(var_23498))
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
            var_d1af8 = texture(s_Texture0, var_8f1e9);
            var_d1af8.w = mix(1.0 - var_d1af8.w, var_d1af8.w, var_178af.x);
            var_d1af8.w = mix(((0.2125999927520751953125 * var_d1af8.x) + (0.715200006961822509765625 * var_d1af8.y)) + (0.072200000286102294921875 * var_d1af8.z), var_d1af8.w, var_178af.z);
            var_f4dd1 = var_178af.w * clamp(var_1f0ae.z, 0.0, 1.0);
        }
        else
        {
            if (17.0 == float(var_23498))
            {
                highp vec2 var_38988 = vec2(var_1f0ae.x, var_1f0ae.y);
                highp vec2 var_d692e = floor(vec2(var_38988.x * TextureSize1.x, var_38988.y * TextureSize1.y)) + vec2(0.5);
                var_d1af8 = v_color * pow(abs(texture(s_Texture1, vec2(var_d692e.x / TextureSize1.x, var_d692e.y / TextureSize1.y)).x), 1.4500000476837158203125 - (((0.2125999927520751953125 * v_color.x) + (0.715200006961822509765625 * v_color.y)) + (0.072200000286102294921875 * v_color.z)));
            }
            else
            {
                if (18.0 == float(var_23498))
                {
                    var_d1af8 = v_color * pow(smoothstep((-0.501960813999176025390625) / var_1f0ae.z, 0.501960813999176025390625 / var_1f0ae.z, (texture(s_Texture2, v_additional.xy).x * 7.96875) - 3.984375), 1.4500000476837158203125 - (((0.2125999927520751953125 * v_color.x) + (0.715200006961822509765625 * v_color.y)) + (0.072200000286102294921875 * v_color.z)));
                }
            }
            var_f4dd1 = 1.0;
        }
        var_94361 = var_f4dd1;
    }
#endif
#ifdef SHOW_DF__ON
    func_0a721(var_1f0ae, var_d1af8, var_178af, var_94361);
#endif
    bgfx_FragColor = var_d1af8 * var_94361;
}
