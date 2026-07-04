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
    highp vec4 var_d9ef6 = texture(s_RasterColor, vec3(v_texcoord0, TextureArrayIndex.x));
    highp vec4 var_84c0b = var_d9ef6;
    bool var_9a6d8;
    highp vec3 var_b1b10;
    switch (uint(DebugMode.x))
    {
        case 1u:
        {
            var_b1b10 = var_d9ef6.www;
            var_9a6d8 = false;
            break;
        }
        case 2u:
        {
            highp vec2 var_7bee0 = (var_d9ef6.xy * 2.0) - vec2(1.0);
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
            var_b1b10 = (normalize(vec3(var_b9f5e.x, var_b9f5e.y, var_b5290.z)) * 0.5) + vec3(0.5);
            var_9a6d8 = false;
            break;
        }
        case 3u:
        {
            highp vec2 var_3b7a3 = var_d9ef6.xy;
            highp vec3 var_4ad52 = vec3(var_d9ef6.xy, (1.0 - abs(var_3b7a3.x)) - abs(var_3b7a3.y));
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
            var_b1b10 = (normalize(vec3(var_c1b70.x, var_c1b70.y, var_de3b3.z)) * 0.5) + vec3(0.5);
            var_9a6d8 = false;
            break;
        }
        case 4u:
        {
            var_b1b10 = vec3(((clamp(var_d9ef6.xy, vec2(-1.0), vec2(1.0)) * 10.0) * 0.5) + vec2(0.5), 0.0);
            var_9a6d8 = false;
            break;
        }
        case 5u:
        {
            var_b1b10 = vec3(((clamp(var_d9ef6.zw, vec2(-1.0), vec2(1.0)) * 10.0) * 0.5) + vec2(0.5), 0.0);
            var_9a6d8 = false;
            break;
        }
        case 6u:
        {
            var_b1b10 = vec3(var_d9ef6.xy, 0.0);
            var_9a6d8 = false;
            break;
        }
        case 7u:
        {
            var_b1b10 = (var_d9ef6.xyz * 0.0500000007450580596923828125) + vec3(0.5);
            var_9a6d8 = false;
            break;
        }
        case 8u:
        {
            var_b1b10 = var_d9ef6.xyz;
            var_9a6d8 = false;
            break;
        }
        case 9u:
        {
            var_b1b10 = var_d9ef6.xxx;
            var_9a6d8 = false;
            break;
        }
        case 10u:
        {
            var_b1b10 = var_d9ef6.yyy;
            var_9a6d8 = false;
            break;
        }
        case 11u:
        {
            var_b1b10 = var_d9ef6.zzz;
            var_9a6d8 = false;
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
            var_b1b10 = var_8a3e9;
            var_9a6d8 = false;
            break;
        }
        case 13u:
        {
            highp float var_eda2e = clamp((log2(dot(var_d9ef6.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125)) * 8.0) + 4.0) * 0.5, 0.0, 8.0);
            int var_1a569 = clamp(int(var_eda2e), 0, 6);
            var_b1b10 = mix(var_56486[var_1a569], var_56486[var_1a569 + 1], vec3(fract(var_eda2e)));
            var_9a6d8 = true;
            break;
        }
        case 15u:
        {
            var_b1b10 = vec3((((ClipPlanes.x * ClipPlanes.y) / (ClipPlanes.y + (var_84c0b.x * (ClipPlanes.x - ClipPlanes.y)))) - ClipPlanes.x) / (ClipPlanes.y - ClipPlanes.x), 0.0, 0.0);
            var_9a6d8 = true;
            break;
        }
        case 16u:
        {
            var_b1b10 = vec3(clamp(2.007874011993408203125 * (var_84c0b.w - 0.501960813999176025390625), 0.0, 1.0));
            var_9a6d8 = false;
            break;
        }
        case 17u:
        {
            var_b1b10 = vec3(clamp(2.007874011993408203125 * (0.4980392158031463623046875 - var_84c0b.w), 0.0, 1.0));
            var_9a6d8 = false;
            break;
        }
        default:
        {
            var_b1b10 = var_d9ef6.xyz;
            var_9a6d8 = true;
            break;
        }
    }
    highp vec3 var_913bc;
    if (var_9a6d8)
    {
        var_913bc = pow(var_b1b10, vec3(0.4545454680919647216796875));
    }
    else
    {
        var_913bc = var_b1b10;
    }
    bgfx_FragColor = vec4(var_913bc, 1.0);
}
