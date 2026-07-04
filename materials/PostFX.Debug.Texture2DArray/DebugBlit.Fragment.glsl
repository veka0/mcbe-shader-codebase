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
* - uniform highp sampler2DArray s_RasterColor;
*
* Uniforms:
* - uniform vec4 ClipPlanes;
* - uniform vec4 DebugMode;
* - uniform vec4 TextureArrayIndex;
*/

precision mediump float;
precision highp int;
const vec3 var_56486[8] = vec3[](vec3(0.0), vec3(0.0, 0.0, 1.0), vec3(0.0, 1.0, 1.0), vec3(0.0, 1.0, 0.0), vec3(1.0, 1.0, 0.0), vec3(1.0, 0.0, 0.0), vec3(1.0, 0.0, 1.0), vec3(1.0));
uniform highp sampler2DArray s_RasterColor;
uniform highp vec4 ClipPlanes;
uniform highp vec4 DebugMode;
uniform highp vec4 TextureArrayIndex;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec4 var_edeae = texture(s_RasterColor, vec3(v_texcoord0, TextureArrayIndex.x));
    highp vec4 var_84c0b = var_edeae;
    bool var_4379b;
    highp vec3 var_8e7a3;
    switch (uint(DebugMode.x))
    {
        case 1u:
        {
            var_8e7a3 = var_edeae.www;
            var_4379b = false;
            break;
        }
        case 2u:
        {
            highp vec2 var_7bee0 = (var_edeae.xy * 2.0) - vec2(1.0);
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
            var_8e7a3 = (normalize(vec3(var_b9f5e.x, var_b9f5e.y, var_b5290.z)) * 0.5) + vec3(0.5);
            var_4379b = false;
            break;
        }
        case 3u:
        {
            highp vec2 var_3b7a3 = var_edeae.xy;
            highp vec3 var_4ad52 = vec3(var_edeae.xy, (1.0 - abs(var_3b7a3.x)) - abs(var_3b7a3.y));
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
            var_8e7a3 = (normalize(vec3(var_c1b70.x, var_c1b70.y, var_de3b3.z)) * 0.5) + vec3(0.5);
            var_4379b = false;
            break;
        }
        case 4u:
        {
            var_8e7a3 = vec3(((clamp(var_edeae.xy, vec2(-1.0), vec2(1.0)) * 10.0) * 0.5) + vec2(0.5), 0.0);
            var_4379b = false;
            break;
        }
        case 5u:
        {
            var_8e7a3 = vec3(((clamp(var_edeae.zw, vec2(-1.0), vec2(1.0)) * 10.0) * 0.5) + vec2(0.5), 0.0);
            var_4379b = false;
            break;
        }
        case 6u:
        {
            var_8e7a3 = vec3(var_edeae.xy, 0.0);
            var_4379b = false;
            break;
        }
        case 7u:
        {
            var_8e7a3 = (var_edeae.xyz * 0.0500000007450580596923828125) + vec3(0.5);
            var_4379b = false;
            break;
        }
        case 8u:
        {
            var_8e7a3 = var_edeae.xyz;
            var_4379b = false;
            break;
        }
        case 9u:
        {
            var_8e7a3 = var_edeae.xxx;
            var_4379b = false;
            break;
        }
        case 10u:
        {
            var_8e7a3 = var_edeae.yyy;
            var_4379b = false;
            break;
        }
        case 11u:
        {
            var_8e7a3 = var_edeae.zzz;
            var_4379b = false;
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
            var_8e7a3 = var_8a3e9;
            var_4379b = false;
            break;
        }
        case 13u:
        {
            highp float var_eda2e = clamp((log2(dot(var_edeae.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) * 8.0) + 4.0) * 0.5, 0.0, 8.0);
            int var_1a569 = clamp(int(var_eda2e), 0, 6);
            var_8e7a3 = mix(var_56486[var_1a569], var_56486[var_1a569 + 1], vec3(fract(var_eda2e)));
            var_4379b = true;
            break;
        }
        case 14u:
        {
            var_8e7a3 = vec3(var_edeae.yz, 0.0);
            var_4379b = false;
            break;
        }
        case 15u:
        {
            var_8e7a3 = vec3((((ClipPlanes.x * ClipPlanes.y) / (ClipPlanes.y + (var_84c0b.x * (ClipPlanes.x - ClipPlanes.y)))) - ClipPlanes.x) / (ClipPlanes.y - ClipPlanes.x), 0.0, 0.0);
            var_4379b = true;
            break;
        }
        case 16u:
        {
            var_8e7a3 = vec3(clamp(2.007874011993408203125 * (var_84c0b.w - 0.501960813999176025390625), 0.0, 1.0));
            var_4379b = false;
            break;
        }
        case 17u:
        {
            var_8e7a3 = vec3(clamp(2.007874011993408203125 * (0.4980392158031463623046875 - var_84c0b.w), 0.0, 1.0));
            var_4379b = false;
            break;
        }
        default:
        {
            var_8e7a3 = var_edeae.xyz;
            var_4379b = true;
            break;
        }
    }
    highp vec3 var_913bc;
    if (var_4379b)
    {
        var_913bc = pow(var_8e7a3, vec3(0.4545454680919647216796875));
    }
    else
    {
        var_913bc = var_8e7a3;
    }
    bgfx_FragColor = vec4(var_913bc, 1.0);
}
