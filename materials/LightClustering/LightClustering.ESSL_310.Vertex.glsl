#version 310 es

/*
* Available Macros:
*
* Passes:
* - CLUSTER_LIGHTS_PASS (not used)
* - CLUSTER_LIGHTS_MANHATTAN_PASS (not used)
* - FALLBACK_PASS (not used)
*
* ChangeMaxLightPerCluster:
* - CHANGE_MAX_LIGHT_PER_CLUSTER__HIGHER (not used)
* - CHANGE_MAX_LIGHT_PER_CLUSTER__LOWER (not used)
* - CHANGE_MAX_LIGHT_PER_CLUSTER__OFF (not used)
*/

#define attribute in
#define varying out
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

uniform vec4 u_viewRect;
uniform mat4 u_proj;
uniform mat4 u_view;
uniform vec4 u_viewTexel;
uniform mat4 u_invView;
uniform mat4 u_invProj;
uniform mat4 u_viewProj;
uniform mat4 u_invViewProj;
uniform mat4 u_prevViewProj;
uniform mat4 u_model[4];
uniform vec4 CameraFarPlane;
uniform mat4 u_modelView;
uniform mat4 u_modelViewProj;
uniform mat4 InvViewMat;
uniform vec4 u_prevWorldPosOffset;
uniform vec4 u_alphaRef4;
uniform vec4 CameraClusterWeight;
uniform vec4 ClusterDimensions;
uniform vec4 ClusterNearFarWidthHeight;
uniform vec4 ClusterSize;
uniform vec4 LightsPerCluster;
uniform mat4 ProjMat;
uniform mat4 ViewMat;
uniform vec4 WorldOrigin;
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
struct LightData {
    float lookup;
};

struct LightCluster {
    int count;
};

struct LightContribution {
    float contribution;
    int indexInLookUp;
};

struct LightExtends {
    vec4 min;
    vec4 max;
    vec4 pos;
    int index;
    float radius;
    int pad1;
    int pad2;
};

struct VertexInput {
    float dummy;
};

struct VertexOutput {
    vec4 position;
};

struct FragmentInput {
    float dummy;
};

struct FragmentOutput {
    vec4 Color0;
};

void Vert(VertexInput vertInput, inout VertexOutput vertOutput) {
}
void main() {
    VertexInput vertexInput;
    VertexOutput vertexOutput;
    vertexOutput.position = vec4(0, 0, 0, 0);
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
    Vert(vertexInput, vertexOutput);
    gl_Position = vertexOutput.position;
}

