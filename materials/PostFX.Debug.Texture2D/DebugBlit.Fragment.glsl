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
const vec3 var_56486[8] = vec3[](vec3(0.0), vec3(0.0, 0.0, 1.0), vec3(0.0, 1.0, 1.0), vec3(0.0, 1.0, 0.0), vec3(1.0, 1.0, 0.0), vec3(1.0, 0.0, 0.0), vec3(1.0, 0.0, 1.0), vec3(1.0));
uniform highp sampler2D s_RasterColor;
uniform highp vec4 ClipPlanes;
uniform highp vec4 DebugMode;
uniform highp vec4 MipLevel;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_40fe3 = textureLod(s_RasterColor, v_texcoord0, MipLevel.x);
    highp vec4 var_84c0b = var_40fe3;
    bool var_fedba;
    highp vec3 var_14810;
    switch (uint(DebugMode.x))
    {
        case 1u:
        {
            var_14810 = var_40fe3.www;
            var_fedba = false;
            break;
        }
        case 2u:
        {
            highp vec2 var_7bee0 = (var_40fe3.xy * 2.0) - vec2(1.0);
            highp vec2 var_5e4f9 = var_7bee0;
            highp vec3 var_2af73 = vec3(var_7bee0, (1.0 - abs(var_5e4f9.x)) - abs(var_5e4f9.y));
            highp vec2 var_b9f5e;
            if (var_2af73.z < 0.0)
            {
                var_b9f5e = (vec2(1.0) - abs(var_2af73.yx)) * ((step(vec2(0.0), var_2af73.xy) * 2.0) - vec2(1.0));
            }
            else
            {
                var_b9f5e = var_2af73.xy;
            }
            highp vec3 var_b5290 = var_2af73;
            var_2af73 = vec3(var_b9f5e.x, var_b9f5e.y, var_b5290.z);
            var_14810 = (normalize(vec3(var_b9f5e.x, var_b9f5e.y, var_b5290.z)) * 0.5) + vec3(0.5);
            var_fedba = false;
            break;
        }
        case 3u:
        {
            highp vec2 var_3b7a3 = var_40fe3.xy;
            highp vec3 var_4ad52 = vec3(var_40fe3.xy, (1.0 - abs(var_3b7a3.x)) - abs(var_3b7a3.y));
            highp vec2 var_c1b70;
            if (var_4ad52.z < 0.0)
            {
                var_c1b70 = (vec2(1.0) - abs(var_4ad52.yx)) * ((step(vec2(0.0), var_4ad52.xy) * 2.0) - vec2(1.0));
            }
            else
            {
                var_c1b70 = var_4ad52.xy;
            }
            highp vec3 var_de3b3 = var_4ad52;
            var_4ad52 = vec3(var_c1b70.x, var_c1b70.y, var_de3b3.z);
            var_14810 = (normalize(vec3(var_c1b70.x, var_c1b70.y, var_de3b3.z)) * 0.5) + vec3(0.5);
            var_fedba = false;
            break;
        }
        case 4u:
        {
            var_14810 = vec3(((clamp(var_40fe3.xy, vec2(-1.0), vec2(1.0)) * 10.0) * 0.5) + vec2(0.5), 0.0);
            var_fedba = false;
            break;
        }
        case 5u:
        {
            var_14810 = vec3(((clamp(var_40fe3.zw, vec2(-1.0), vec2(1.0)) * 10.0) * 0.5) + vec2(0.5), 0.0);
            var_fedba = false;
            break;
        }
        case 6u:
        {
            var_14810 = vec3(var_40fe3.xy, 0.0);
            var_fedba = false;
            break;
        }
        case 7u:
        {
            var_14810 = (var_40fe3.xyz * 0.0500000007450580596923828125) + vec3(0.5);
            var_fedba = false;
            break;
        }
        case 8u:
        {
            var_14810 = var_40fe3.xyz;
            var_fedba = false;
            break;
        }
        case 9u:
        {
            var_14810 = var_40fe3.xxx;
            var_fedba = false;
            break;
        }
        case 10u:
        {
            var_14810 = var_40fe3.yyy;
            var_fedba = false;
            break;
        }
        case 11u:
        {
            var_14810 = var_40fe3.zzz;
            var_fedba = false;
            break;
        }
        case 12u:
        {
            highp vec3 var_8a3e9;
            if (var_84c0b.x < 0.0)
            {
                var_8a3e9 = vec3(-var_84c0b.x, 0.0, 0.0);
            }
            else
            {
                var_8a3e9 = vec3(0.0, var_84c0b.x, 0.0);
            }
            var_14810 = var_8a3e9;
            var_fedba = false;
            break;
        }
        case 13u:
        {
            highp float var_eda2e = clamp((log2(dot(var_40fe3.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) * 8.0) + 4.0) * 0.5, 0.0, 8.0);
            int var_1a569 = clamp(int(var_eda2e), 0, 6);
            var_14810 = mix(var_56486[var_1a569], var_56486[var_1a569 + 1], vec3(fract(var_eda2e)));
            var_fedba = true;
            break;
        }
        case 15u:
        {
            var_14810 = vec3((((ClipPlanes.x * ClipPlanes.y) / (ClipPlanes.y + (var_84c0b.x * (ClipPlanes.x - ClipPlanes.y)))) - ClipPlanes.x) / (ClipPlanes.y - ClipPlanes.x), 0.0, 0.0);
            var_fedba = true;
            break;
        }
        case 16u:
        {
            var_14810 = vec3(clamp(2.007874011993408203125 * (var_84c0b.w - 0.501960813999176025390625), 0.0, 1.0));
            var_fedba = false;
            break;
        }
        case 17u:
        {
            var_14810 = vec3(clamp(2.007874011993408203125 * (0.4980392158031463623046875 - var_84c0b.w), 0.0, 1.0));
            var_fedba = false;
            break;
        }
        case 21u:
        {
            var_14810 = vec3(((vec2(ClipPlanes.x * ClipPlanes.y) / (vec2(ClipPlanes.y) + (var_40fe3.xy * (ClipPlanes.x - ClipPlanes.y)))) - vec2(ClipPlanes.x)) / vec2(ClipPlanes.y - ClipPlanes.x), 0.0);
            var_fedba = true;
            break;
        }
        default:
        {
            var_14810 = var_40fe3.xyz;
            var_fedba = true;
            break;
        }
    }
    highp vec3 var_913bc;
    if (var_fedba)
    {
        var_913bc = pow(var_14810, vec3(0.4545454680919647216796875));
    }
    else
    {
        var_913bc = var_14810;
    }
    bgfx_FragColor = vec4(var_913bc, 1.0);
}
