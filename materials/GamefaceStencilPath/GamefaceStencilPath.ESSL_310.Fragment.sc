/*
* Available Macros:
*
* Passes:
* - TRANSPARENT_PASS (not used)
*/

$input v_extraParams
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

uniform vec4 PrimProps0;
uniform vec4 ShaderType;
uniform vec4 PrimProps1;
uniform mat4 Transform;
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
    vec4 additional;
    vec4 color;
    vec4 position;
};

struct VertexOutput {
    vec4 position;
    vec2 extraParams;
};

struct FragmentInput {
    vec2 extraParams;
};

struct FragmentOutput {
    vec4 Color0;
};

void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    if (int(ShaderType.x) == 15) {
        vec2 uvs = abs(fragInput.extraParams);
        vec2 px = dFdx(uvs);
        vec2 py = dFdy(uvs);
        float fx = (2.0 * uvs.x) * px.x - px.y;
        float fy = (2.0 * uvs.x) * py.x - py.y;
        float edgeAlpha = (uvs.x * uvs.x - uvs.y);
        float sd = sqrt((edgeAlpha * edgeAlpha) / (fx * fx + fy * fy));
        float alpha = clamp(0.0 - sd, 0.0, 1.0);
        if (alpha < 0.00390625) {
            discard;
        }
    } else if (int(ShaderType.x) == 16) {
    } else if (fragInput.extraParams.y < 0.00390625) {
        discard;
    }
    fragOutput.Color0 = vec4(1.0, 1.0, 1.0, 1.0);
}
void main() {
    FragmentInput fragmentInput;
    FragmentOutput fragmentOutput;
    fragmentInput.extraParams = v_extraParams;
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
    Frag(fragmentInput, fragmentOutput);
    gl_FragColor = fragmentOutput.Color0;
}

