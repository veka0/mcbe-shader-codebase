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
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    int var_a9bf2 = int(CurrentFace.x);
    highp vec2 var_51b71 = (v_texCoord * 2.0) - vec2(1.0);
    highp vec3 var_79863;
    if (var_a9bf2 == 0)
    {
        var_79863 = vec3(1.0, -var_51b71.y, -var_51b71.x);
    }
    else
    {
        highp vec3 var_4c2c6;
        if (var_a9bf2 == 1)
        {
            var_4c2c6 = vec3(-1.0, -var_51b71.y, var_51b71.x);
        }
        else
        {
            highp vec3 var_5c2b4;
            if (var_a9bf2 == 2)
            {
                var_5c2b4 = vec3(var_51b71.x, 1.0, var_51b71.y);
            }
            else
            {
                highp vec3 var_34e6b;
                if (var_a9bf2 == 3)
                {
                    var_34e6b = vec3(var_51b71.x, -1.0, -var_51b71.y);
                }
                else
                {
                    highp vec3 var_48d9d;
                    if (var_a9bf2 == 4)
                    {
                        var_48d9d = vec3(var_51b71.x, -var_51b71.y, 1.0);
                    }
                    else
                    {
                        highp vec3 var_f340e;
                        if (var_a9bf2 == 5)
                        {
                            var_f340e = vec3(-var_51b71.x, -var_51b71.y, -1.0);
                        }
                        else
                        {
                            var_f340e = vec3(0.0);
                        }
                        var_48d9d = var_f340e;
                    }
                    var_34e6b = var_48d9d;
                }
                var_5c2b4 = var_34e6b;
            }
            var_4c2c6 = var_5c2b4;
        }
        var_79863 = var_4c2c6;
    }
    bgfx_FragColor = textureLod(s_SrcTextureCube, var_79863, CurrentMip.x - 1.0);
}
