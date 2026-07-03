#version 310 es

/*
* Available Macros:
*
* Passes:
* - CUSTOM_PASS_BASED_ON_OPAQUE_PASS (not used)
* - DEPTH_ONLY_PASS (not used)
* - OPAQUE_PASS (not used)
*
* Instancing:
* - INSTANCING__OFF (not used)
* - INSTANCING__ON (not used)
*
* Available Resources:
*
* Buffers:
* - uniform lowp sampler2D s_MatTexture;
* - uniform lowp sampler2D s_ShadowTexture;
*
* Uniforms:
* - uniform vec4 Ambient;
* - uniform vec4 LightAmbientColorAndIntensity;
* - uniform vec4 LightDiffuseColorAndIlluminance;
* - uniform vec4 LightWorldSpaceDirection;
* - uniform vec4 MaterialID;
* - uniform vec4 ShadowFilterSize;
* - uniform vec4 ShadowTexel;
* - uniform mat4 ShadowTransform;
*/

precision mediump float;
precision highp int;
uniform highp mat4 ShadowTransform;
uniform highp mat4 u_view;
uniform highp sampler2D s_MatTexture;
uniform highp sampler2D s_ShadowTexture;
uniform highp vec4 LightAmbientColorAndIntensity;
uniform highp vec4 LightDiffuseColorAndIlluminance;
uniform highp vec4 LightWorldSpaceDirection;
uniform highp vec4 ShadowFilterSize;
uniform highp vec4 ShadowTexel;
in highp vec2 v_texcoord0;
in highp vec3 v_viewSpaceNormal;
in highp vec4 v_viewSpacePosition;
in highp vec3 v_worldPos;
layout(location = 0) out highp vec4 bgfx_FragColor;
void main() {
    highp vec3 var_164ee = texture(s_MatTexture, v_texcoord0).xyz;
    highp vec3 var_1221a = LightDiffuseColorAndIlluminance.xyz * LightDiffuseColorAndIlluminance.w;
    highp vec3 var_69510 = normalize(v_viewSpaceNormal);
    highp vec3 var_20363 = normalize(-(u_view * vec4(LightWorldSpaceDirection.xyz, 0.0)).xyz);
    highp vec4 var_d67eb = ShadowTransform * vec4(v_worldPos, 1.0);
    var_d67eb.z = (var_d67eb.z * 0.5) + 0.5;
    highp float var_a9306 = (var_d67eb.z / var_d67eb.w) - 0.00025000001187436282634735107421875;
    highp vec2 var_0387e = ((var_d67eb.xy / vec2(var_d67eb.w)) * 0.5) + vec2(0.5);
    var_0387e.y = 1.0 - var_0387e.y;
    var_0387e = vec2(var_0387e.x, 1.0 - var_0387e.y);
    int var_227ca = min(2, int(ShadowFilterSize.x));
    int var_d5743 = -var_227ca;
    highp float var_970ab;
    var_970ab = 0.0;
    highp float var_d2f4a;
    for (int var_58f79 = var_d5743; var_58f79 <= var_227ca; var_970ab = var_d2f4a, var_58f79++)
    {
        int var_99729 = -var_227ca;
        var_d2f4a = var_970ab;
        highp float var_dd37c;
        for (int var_a7db3 = var_99729; var_a7db3 <= var_227ca; var_d2f4a = var_dd37c, var_a7db3++)
        {
            var_dd37c = var_d2f4a + float((var_a9306 - texture(s_ShadowTexture, var_0387e + (vec2(float(var_a7db3), float(var_58f79)) * ShadowTexel.xy)).x) > 0.0);
        }
    }
    highp float var_70ce5 = (float(var_227ca) * 2.0) + 1.0;
    highp vec2 var_82501 = ShadowTexel.xy * 16.0;
    highp vec2 var_c7b22 = smoothstep(vec2(0.0), var_82501, var_0387e) * (vec2(1.0) - smoothstep(vec2(1.0) - var_82501, vec2(1.0), var_0387e));
    highp float var_7fff1 = ((var_970ab / (var_70ce5 * var_70ce5)) * var_c7b22.x) * var_c7b22.y;
    bgfx_FragColor = vec4((((LightAmbientColorAndIntensity.xyz * LightAmbientColorAndIntensity.w) * var_164ee) + (((var_1221a * clamp(dot(var_69510, var_20363), 0.0, 1.0)) * var_164ee) * (1.0 - var_7fff1))) + ((var_1221a * clamp(0.17050252854824066162109375 * pow(clamp(dot(var_69510, normalize(var_20363 + normalize(-v_viewSpacePosition.xyz))), 0.0, 1.0), 0.455475330352783203125), 0.0, 1.0)) * (1.0 - var_7fff1)), 1.0);
}
