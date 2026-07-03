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
void main() {
    highp vec4 var_56c51 = v_additional;
    highp vec4 var_ddac5 = v_color;
    highp vec4 var_56356 = v_color;
    int var_f6929 = int(v_shaderType);
    highp float var_b97bc;
    if (var_f6929 == 0)
    {
        var_b97bc = min(1.0, var_56c51.x * var_56c51.y);
    }
    else
    {
        highp float var_f4dd1;
        if (var_f6929 == 3)
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
            var_56356 = texture(s_Texture0, var_8f1e9);
            var_56356.w = mix(1.0 - var_56356.w, var_56356.w, var_ddac5.x);
            highp vec3 var_0beb9 = var_56356.xyz;
            var_56356.w = mix(((0.2125999927520751953125 * var_0beb9.x) + (0.715200006961822509765625 * var_0beb9.y)) + (0.072200000286102294921875 * var_0beb9.z), var_56356.w, var_ddac5.z);
            var_f4dd1 = var_ddac5.w * clamp(var_56c51.z, 0.0, 1.0);
        }
        else
        {
            if (var_f6929 == 17)
            {
                highp vec2 var_38988 = vec2(var_56c51.x, var_56c51.y);
                highp vec2 var_a9c9d = floor(vec2(var_38988.x * TextureSize1.x, var_38988.y * TextureSize1.y)) + vec2(0.5);
                highp vec3 var_36e72 = v_color.xyz;
                var_56356 = v_color * pow(abs(texture(s_Texture1, vec2(var_a9c9d.x / TextureSize1.x, var_a9c9d.y / TextureSize1.y)).x), 1.4500000476837158203125 - (((0.2125999927520751953125 * var_36e72.x) + (0.715200006961822509765625 * var_36e72.y)) + (0.072200000286102294921875 * var_36e72.z)));
            }
            else
            {
                if (var_f6929 == 18)
                {
                    highp vec3 var_2f797 = v_color.xyz;
                    var_56356 = v_color * pow(smoothstep((-0.501960813999176025390625) / var_56c51.z, 0.501960813999176025390625 / var_56c51.z, (texture(s_Texture2, v_additional.xy).x * 7.96875) - 3.984375), 1.4500000476837158203125 - (((0.2125999927520751953125 * var_2f797.x) + (0.715200006961822509765625 * var_2f797.y)) + (0.072200000286102294921875 * var_2f797.z)));
                }
            }
            var_f4dd1 = 1.0;
        }
        var_b97bc = var_f4dd1;
    }
    bgfx_FragColor = var_56356 * var_b97bc;
}
