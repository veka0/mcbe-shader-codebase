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
* - uniform lowp sampler2D s_GlintTexture;
* - uniform lowp sampler2D s_MatTexture;
*
* Uniforms:
* - uniform vec4 GlintColor;
* - uniform vec4 HudOpacity;
* - uniform vec4 TintColor;
* - uniform vec4 UVOffset;
* - uniform vec4 UVRotation;
* - uniform vec4 UVScale;
*/

uniform mat4 u_modelViewProj;
uniform vec4 UVOffset;
uniform vec4 UVRotation;
uniform vec4 UVScale;
in vec4 a_color0;
in vec3 a_position;
in vec2 a_texcoord0;
out vec4 v_color;
out vec2 v_layer1UV;
out vec2 v_layer2UV;
out vec2 v_texcoord0;
void main() {
    float var_1a867 = sin(UVRotation.x);
    float var_fcf94 = cos(UVRotation.x);
    vec2 var_1be5a = (a_texcoord0 - vec2(0.5)) * mat2(vec2(var_fcf94, -var_1a867), vec2(var_1a867, var_fcf94));
    var_1be5a.x += UVOffset.x;
    vec2 var_eb807 = var_1be5a;
    vec2 var_013e0 = var_eb807 + vec2(0.5);
    var_1be5a = var_013e0;
    float var_cb0f8 = sin(UVRotation.y);
    float var_83484 = cos(UVRotation.y);
    vec2 var_104d9 = (a_texcoord0 - vec2(0.5)) * mat2(vec2(var_83484, -var_cb0f8), vec2(var_cb0f8, var_83484));
    var_104d9.x += UVOffset.y;
    vec2 var_0ef75 = var_104d9;
    vec2 var_3a0c9 = var_0ef75 + vec2(0.5);
    var_104d9 = var_3a0c9;
    v_color = a_color0;
    v_layer1UV = var_013e0 * UVScale.xy;
    v_layer2UV = var_3a0c9 * UVScale.xy;
    v_texcoord0 = a_texcoord0;
    gl_Position = u_modelViewProj * vec4(a_position, 1.0);
}
