#version 310 es

/*
* Available Macros:
*
* Passes:
* - CUBEMAP_TO_OFFSCREEN_PASS (not used)
* - FALLBACK_PASS (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp samplerCube s_SrcTextureCube;
*
* Uniforms:
* - uniform vec4 CurrentFace;
* - uniform vec4 CurrentMip;
*/

precision mediump float;
precision highp int;
uniform highp samplerCube s_SrcTextureCube;
uniform highp vec4 CurrentFace;
uniform highp vec4 CurrentMip;
in highp vec2 v_texCoord;
layout(location = 0) out highp vec4 bgfx_FragData0;
void main() {
    highp vec2 var_f95e1 = v_texCoord;
    var_f95e1 = (var_f95e1 * 2.0) - vec2(1.0);
    highp vec3 var_62f41;
    switch (int(CurrentFace.x))
    {
        case 0:
        {
            var_62f41 = vec3(1.0, -var_f95e1.y, -var_f95e1.x);
            break;
        }
        case 1:
        {
            var_62f41 = vec3(-1.0, -var_f95e1.y, var_f95e1.x);
            break;
        }
        case 2:
        {
            var_62f41 = vec3(var_f95e1.x, 1.0, var_f95e1.y);
            break;
        }
        case 3:
        {
            var_62f41 = vec3(var_f95e1.x, -1.0, -var_f95e1.y);
            break;
        }
        case 4:
        {
            var_62f41 = vec3(var_f95e1.x, -var_f95e1.y, 1.0);
            break;
        }
        case 5:
        {
            var_62f41 = vec3(-var_f95e1.x, -var_f95e1.y, -1.0);
            break;
        }
        default:
        {
            var_62f41 = vec3(0.0);
            break;
        }
    }
    bgfx_FragData0 = textureLod(s_SrcTextureCube, var_62f41, CurrentMip.x - 1.0);
}
