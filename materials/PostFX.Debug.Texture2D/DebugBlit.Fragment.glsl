#version 310 es

/*
* Available Macros:
*
* Passes:
* - DEBUG_BLIT_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_RasterColor;
*
* Uniforms:
* - uniform vec4 ClipPlanes;
* - uniform vec4 DebugMode;
* - uniform vec4 MipLevel;
*/

precision mediump float;
precision highp int;
uniform highp sampler2D s_RasterColor;
uniform highp vec4 ClipPlanes;
uniform highp vec4 DebugMode;
uniform highp vec4 MipLevel;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec4 var_caea7 = textureLod(s_RasterColor, v_texcoord0, MipLevel.x);
    highp vec4 var_72a58 = var_caea7;
    bool var_fedba;
    highp vec3 var_c6b6c;
    switch (uint(DebugMode.x))
    {
        case 1u:
        {
            var_c6b6c = var_caea7.www;
            var_fedba = false;
            break;
        }
        case 2u:
        {
            highp vec2 var_7bee0 = (var_caea7.xy * 2.0) - vec2(1.0);
            highp vec2 var_5e4f9 = var_7bee0;
            highp vec3 var_ebe44 = vec3(var_7bee0, (1.0 - abs(var_5e4f9.x)) - abs(var_5e4f9.y));
            highp vec2 var_de16b;
            if (var_ebe44.z < 0.0)
            {
                var_de16b = (vec2(1.0) - abs(var_ebe44.yx)) * ((step(vec2(0.0), var_ebe44.xy) * 2.0) - vec2(1.0));
            }
            else
            {
                var_de16b = var_ebe44.xy;
            }
            var_ebe44.x = var_de16b.x;
            var_ebe44.y = var_de16b.y;
            var_c6b6c = (normalize(var_ebe44) * 0.5) + vec3(0.5);
            var_fedba = false;
            break;
        }
        case 3u:
        {
            highp vec2 var_3b7a3 = var_caea7.xy;
            highp vec3 var_b8a8d = vec3(var_caea7.xy, (1.0 - abs(var_3b7a3.x)) - abs(var_3b7a3.y));
            highp vec2 var_241ef;
            if (var_b8a8d.z < 0.0)
            {
                var_241ef = (vec2(1.0) - abs(var_b8a8d.yx)) * ((step(vec2(0.0), var_b8a8d.xy) * 2.0) - vec2(1.0));
            }
            else
            {
                var_241ef = var_b8a8d.xy;
            }
            var_b8a8d.x = var_241ef.x;
            var_b8a8d.y = var_241ef.y;
            var_c6b6c = (normalize(var_b8a8d) * 0.5) + vec3(0.5);
            var_fedba = false;
            break;
        }
        case 4u:
        {
            var_c6b6c = vec3(((clamp(var_caea7.xy, vec2(-1.0), vec2(1.0)) * 10.0) * 0.5) + vec2(0.5), 0.0);
            var_fedba = false;
            break;
        }
        case 5u:
        {
            var_c6b6c = vec3(((clamp(var_caea7.zw, vec2(-1.0), vec2(1.0)) * 10.0) * 0.5) + vec2(0.5), 0.0);
            var_fedba = false;
            break;
        }
        case 6u:
        {
            var_c6b6c = vec3(var_caea7.xy, 0.0);
            var_fedba = false;
            break;
        }
        case 7u:
        {
            var_c6b6c = (var_caea7.xyz * 0.0500000007450580596923828125) + vec3(0.5);
            var_fedba = false;
            break;
        }
        case 8u:
        {
            var_c6b6c = var_caea7.xyz;
            var_fedba = false;
            break;
        }
        case 9u:
        {
            var_c6b6c = var_caea7.xxx;
            var_fedba = false;
            break;
        }
        case 10u:
        {
            var_c6b6c = var_caea7.yyy;
            var_fedba = false;
            break;
        }
        case 11u:
        {
            var_c6b6c = var_caea7.zzz;
            var_fedba = false;
            break;
        }
        case 12u:
        {
            highp vec3 var_8a3e9;
            if (var_72a58.x < 0.0)
            {
                var_8a3e9 = vec3(-var_72a58.x, 0.0, 0.0);
            }
            else
            {
                var_8a3e9 = vec3(0.0, var_72a58.x, 0.0);
            }
            var_c6b6c = var_8a3e9;
            var_fedba = false;
            break;
        }
        case 13u:
        {
            highp vec3 var_a8720[8];
            var_a8720[0] = vec3(0.0);
            var_a8720[1] = vec3(0.0, 0.0, 1.0);
            var_a8720[2] = vec3(0.0, 1.0, 1.0);
            var_a8720[3] = vec3(0.0, 1.0, 0.0);
            var_a8720[4] = vec3(1.0, 1.0, 0.0);
            var_a8720[5] = vec3(1.0, 0.0, 0.0);
            var_a8720[6] = vec3(1.0, 0.0, 1.0);
            var_a8720[7] = vec3(1.0);
            highp float var_eda2e = clamp((log2(dot(var_caea7.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) * 8.0) + 4.0) * 0.5, 0.0, 8.0);
            int var_1a569 = clamp(int(var_eda2e), 0, 6);
            var_c6b6c = mix(var_a8720[var_1a569], var_a8720[var_1a569 + 1], vec3(fract(var_eda2e)));
            var_fedba = true;
            break;
        }
        case 15u:
        {
            var_c6b6c = vec3((((ClipPlanes.x * ClipPlanes.y) / (ClipPlanes.y + (var_72a58.x * (ClipPlanes.x - ClipPlanes.y)))) - ClipPlanes.x) / (ClipPlanes.y - ClipPlanes.x), 0.0, 0.0);
            var_fedba = true;
            break;
        }
        case 16u:
        {
            var_c6b6c = vec3(clamp(2.007874011993408203125 * (var_72a58.w - 0.501960813999176025390625), 0.0, 1.0));
            var_fedba = false;
            break;
        }
        case 17u:
        {
            var_c6b6c = vec3(clamp(2.007874011993408203125 * (0.4980392158031463623046875 - var_72a58.w), 0.0, 1.0));
            var_fedba = false;
            break;
        }
        case 21u:
        {
            var_c6b6c = vec3(((vec2(ClipPlanes.x * ClipPlanes.y) / (vec2(ClipPlanes.y) + (vec2(1.0 - var_72a58.x, 1.0 - var_72a58.y) * (ClipPlanes.x - ClipPlanes.y)))) - vec2(ClipPlanes.x)) / vec2(ClipPlanes.y - ClipPlanes.x), 0.0);
            var_fedba = true;
            break;
        }
        default:
        {
            var_c6b6c = var_caea7.xyz;
            var_fedba = true;
            break;
        }
    }
    highp vec3 var_d1c50;
    if (var_fedba)
    {
        var_d1c50 = pow(var_c6b6c, vec3(0.4545454680919647216796875));
    }
    else
    {
        var_d1c50 = var_c6b6c;
    }
    bgfx_FragData0 = vec4(var_d1c50, 1.0);
}
