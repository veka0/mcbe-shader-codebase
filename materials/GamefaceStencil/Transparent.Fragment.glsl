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
* - uniform vec4 ShaderType;
* - uniform mat4 Transform;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_Texture0;
uniform highp sampler2D s_Texture1;
uniform highp sampler2D s_Texture2;
uniform highp vec4 PrimProps0;
uniform highp vec4 PrimProps1;
uniform highp vec4 ShaderType;
in highp vec4 v_additional;
in highp vec4 v_color;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_dba13 = v_color;
    highp vec4 var_c2133 = v_additional;
    highp vec4 var_8de51 = v_color;
    highp vec4 var_ef0ae = v_color;
    highp float var_8ffc0;
    if (int(ShaderType.x) == 0)
    {
        var_8ffc0 = min(1.0, var_c2133.z * var_c2133.w);
    }
    else
    {
        if (int(ShaderType.x) == 3)
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
                var_e517a.x = clamp(var_c2133.x, PrimProps1.x, PrimProps1.x + PrimProps1.z);
                var_e517a.y = clamp(var_c2133.y, PrimProps1.y, PrimProps1.y + PrimProps1.w);
            }
            var_ef0ae = texture(s_Texture0, var_e517a);
            var_ef0ae.w = mix(1.0 - var_ef0ae.w, var_ef0ae.w, var_8de51.x);
        }
        else
        {
            if (int(ShaderType.x) == 17)
            {
                highp vec3 var_9a01c = v_color.xyz;
                var_ef0ae = v_color * pow(abs(texture(s_Texture1, v_additional.xy).x), 1.4500000476837158203125 - (((0.2125999927520751953125 * var_9a01c.x) + (0.715200006961822509765625 * var_9a01c.y)) + (0.072200000286102294921875 * var_9a01c.z)));
            }
            else
            {
                if (int(ShaderType.x) == 18)
                {
                    highp vec3 var_80d73 = v_color.xyz;
                    var_ef0ae = v_color * pow(abs(smoothstep((-0.501960813999176025390625) / PrimProps0.x, 0.501960813999176025390625 / PrimProps0.x, (texture(s_Texture2, v_additional.xy).x * 7.96875) - 3.984375)), 1.4500000476837158203125 - (((0.2125999927520751953125 * var_80d73.x) + (0.715200006961822509765625 * var_80d73.y)) + (0.072200000286102294921875 * var_80d73.z)));
                }
            }
        }
        var_8ffc0 = 1.0;
    }
    var_dba13 = var_ef0ae;
    highp float var_49df2;
    if (int(ShaderType.x) == 3)
    {
        var_49df2 = var_dba13.w;
    }
    else
    {
        var_49df2 = var_8ffc0;
    }
    if (var_49df2 < 0.00390625)
    {
        discard;
    }
    bgfx_FragColor = vec4(1.0);
}
