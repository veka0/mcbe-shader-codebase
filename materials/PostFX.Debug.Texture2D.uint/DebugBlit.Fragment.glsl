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
* - uniform lowp usampler2D s_RasterColor;
*
* Uniforms:
* - uniform vec4 ClipPlanes;
* - uniform vec4 DebugMode;
*/

precision mediump float;
precision highp int;
float var_9718b;
uniform highp usampler2D s_RasterColor;
uniform highp vec4 DebugMode;
in highp vec2 v_texcoord0;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    uvec4 var_26d79 = texelFetch(s_RasterColor, ivec2(vec2(textureSize(s_RasterColor, 0)) * v_texcoord0), 0);
    uvec4 var_dd031 = var_26d79;
    highp vec3 var_8a19f;
    switch (uint(DebugMode.x))
    {
        case 14u:
        {
            var_8a19f = vec3(0.0, float(var_dd031.w) * 0.0039215688593685626983642578125, 0.0);
            break;
        }
        case 18u:
        {
            uvec2 var_7e55c = var_26d79.yz;
            uint var_14b9a = var_7e55c.x & 65535u;
            uint var_b1dcb = var_7e55c.y & 65535u;
            highp vec4 var_79506 = vec4(uvec4(var_14b9a >> 8u, var_14b9a & 255u, var_b1dcb >> 8u, var_b1dcb & 255u)) * vec4(0.0039215688593685626983642578125);
            highp vec4 var_ea8ab = var_79506;
            var_8a19f = ((var_79506.xyz * var_ea8ab.w) * 6.0) * vec3(0.16666667163372039794921875);
            break;
        }
        case 19u:
        {
            uint var_b8419 = var_dd031.x & 65535u;
            uvec2 var_16036 = uvec2(var_b8419 >> 8u, var_b8419 & 255u);
            var_8a19f = (vec2(float(var_16036.x), var_9718b) * vec2(0.0039215688593685626983642578125)).xxx;
            break;
        }
        case 20u:
        {
            uint var_91e6c = var_dd031.x & 65535u;
            uvec2 var_75ad2 = uvec2(var_91e6c >> 8u, var_91e6c & 255u);
            var_8a19f = (vec2(var_9718b, float(var_75ad2.y)) * vec2(0.0039215688593685626983642578125)).yyy;
            break;
        }
        default:
        {
            var_8a19f = vec3(0.0);
            break;
        }
    }
    bgfx_FragData0 = vec4(var_8a19f, 1.0);
}
