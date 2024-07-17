#version 310 es

/*
* Available Macros:
*
* Passes:
* - ALPHA_TEST_PASS (not used)
* - DEPTH_ONLY_PASS (not used)
* - OPAQUE_PASS (not used)
* - RASTERIZED_ALPHA_TEST_PASS (not used)
* - RASTERIZED_OPAQUE_PASS (not used)
* - RASTERIZED_TRANSPARENT_PASS (not used)
* - TRANSPARENT_PASS (not used)
*
* AlphaTest:
* - ALPHA_TEST__OFF (not used)
* - ALPHA_TEST__ON_DISCARD_VALUE_BASED (not used)
* - ALPHA_TEST__ON_VERTEX_TINT_MASK_BASED (not used)
*
* Lit:
* - LIT__OFF (not used)
* - LIT__ON (not used)
*
* MultiColorTint:
* - MULTI_COLOR_TINT__OFF (not used)
* - MULTI_COLOR_TINT__ON (not used)
*
* UseTextures:
* - USE_TEXTURES__OFF (not used)
* - USE_TEXTURES__ON (not used)
*/

#if GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define attribute in
#define varying in
out vec4 bgfx_FragColor;
varying vec4 v_color;
varying vec4 v_fog;
varying vec4 v_light;
centroid varying vec2 v_texCoords;
struct NoopSampler {
    int noop;
};

struct NoopImage2D {
    int noop;
};

struct NoopImage3D {
    int noop;
};

struct rayQueryKHR {
    int noop;
};

struct accelerationStructureKHR {
    int noop;
};

struct FragmentOutput {
    vec4 Color0;
};

void main() {
    FragmentOutput fragmentOutput;
    fragmentOutput.Color0 = vec4(0, 0, 0, 0);
    bgfx_FragColor = fragmentOutput.Color0;
}

