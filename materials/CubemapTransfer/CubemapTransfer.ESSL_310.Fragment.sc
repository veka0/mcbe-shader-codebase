/*
* Available Macros:
*
* Passes:
* - CUBEMAP_TO_OFFSCREEN_PASS
* - FALLBACK_PASS
*/

#ifdef CUBEMAP_TO_OFFSCREEN_PASS
$input v_texCoord
#endif
struct NoopSampler {
    int noop;
};

#ifdef CUBEMAP_TO_OFFSCREEN_PASS
vec3 vec3_splat(float _x) {
    return vec3(_x, _x, _x);
}
#endif
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

uniform vec4 CurrentFace;
uniform vec4 CurrentMip;
vec4 ViewRect;
mat4 Proj;
mat4 View;
vec4 ViewTexel;
mat4 InvView;
mat4 InvProj;
mat4 ViewProj;
mat4 InvViewProj;
mat4 PrevViewProj;
mat4 WorldArray[4];
mat4 World;
mat4 WorldView;
mat4 WorldViewProj;
vec4 PrevWorldPosOffset;
vec4 AlphaRef4;
float AlphaRef;
struct VertexInput {
    #ifdef CUBEMAP_TO_OFFSCREEN_PASS
    vec4 position;
    vec2 texcoord0;
    #endif
    #ifdef FALLBACK_PASS
    float dummy;
    #endif
};

struct VertexOutput {
    vec4 position;
    #ifdef CUBEMAP_TO_OFFSCREEN_PASS
    vec2 texCoord;
    #endif
};

struct FragmentInput {
    #ifdef CUBEMAP_TO_OFFSCREEN_PASS
    vec2 texCoord;
    #endif
    #ifdef FALLBACK_PASS
    float dummy;
    #endif
};

struct FragmentOutput {
    vec4 Color0;
};

SAMPLERCUBE_AUTOREG(s_SrcTextureCube);
#ifdef CUBEMAP_TO_OFFSCREEN_PASS
vec3 convertQuadToCube(vec2 inCoords, int face) {
    inCoords = inCoords * 2.0 - 1.0;
    vec3 uv = vec3_splat(0.0);
    if (face == 0) {
        uv = vec3(1.0, - inCoords.y, - inCoords.x);
    }
    else if (face == 1) {
        uv = vec3(-1.0, - inCoords.y, inCoords.x);
    }
    else if (face == 2) {
        uv = vec3(inCoords.x, 1.0, inCoords.y);
    }
    else if (face == 3) {
        uv = vec3(inCoords.x, - 1.0, - inCoords.y);
    }
    else if (face == 4) {
        uv = vec3(inCoords.x, - inCoords.y, 1.0);
    }
    else if (face == 5) {
        uv = vec3(-inCoords.x, - inCoords.y, - 1.0);
    }
    return uv;
}
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    vec3 uv = convertQuadToCube(fragInput.texCoord, int(CurrentFace.x));
    vec4 color = textureCubeLod(s_SrcTextureCube, uv, CurrentMip.x - 1.0);
    color.r = isnan(color.r)|| isinf(color.r) ? 65503.0 : color.r;
    color.g = isnan(color.r)|| isinf(color.g) ? 65503.0 : color.g;
    color.b = isnan(color.r)|| isinf(color.b) ? 65503.0 : color.b;
    fragOutput.Color0 = color;
}
#endif
#ifdef FALLBACK_PASS
void FallbackFrag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    fragOutput.Color0 = vec4(0.0, 0.0, 0.0, 0.0);
}
#endif
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    #ifdef CUBEMAP_TO_OFFSCREEN_PASS
    fragmentInput.texCoord = v_texCoord;
    #endif
    fragmentOutput.Color0 = vec4(0, 0, 0, 0);
    ViewRect = u_viewRect;
    Proj = u_proj;
    View = u_view;
    ViewTexel = u_viewTexel;
    InvView = u_invView;
    InvProj = u_invProj;
    ViewProj = u_viewProj;
    InvViewProj = u_invViewProj;
    PrevViewProj = u_prevViewProj;
    {
        WorldArray[0] = u_model[0];
        WorldArray[1] = u_model[1];
        WorldArray[2] = u_model[2];
        WorldArray[3] = u_model[3];
    }
    World = u_model[0];
    WorldView = u_modelView;
    WorldViewProj = u_modelViewProj;
    PrevWorldPosOffset = u_prevWorldPosOffset;
    AlphaRef4 = u_alphaRef4;
    AlphaRef = u_alphaRef4.x;
    #ifdef CUBEMAP_TO_OFFSCREEN_PASS
    Frag(fragmentInput, fragmentOutput);
    #endif
    #ifdef FALLBACK_PASS
    FallbackFrag(fragmentInput, fragmentOutput);
    #endif
    gl_FragColor = fragmentOutput.Color0;
}

