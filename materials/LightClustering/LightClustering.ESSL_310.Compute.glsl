#version 310 es

/*
* Available Macros:
*
* Passes:
* - CLUSTER_LIGHTS_PASS
* - CLUSTER_LIGHTS_MANHATTAN_PASS
* - FALLBACK_PASS (not used)
*/

#define shadow2D(_sampler, _coord)texture(_sampler, _coord)
#define shadow2DArray(_sampler, _coord)texture(_sampler, _coord)
#define shadow2DProj(_sampler, _coord)textureProj(_sampler, _coord)
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

uniform vec4 ClusterNearFarWidthHeight;
uniform vec4 CameraFarPlane;
uniform vec4 LightsPerCluster;
uniform vec4 ClusterDimensions;
uniform vec4 ClusterSize;
uniform mat4 InvViewMat;
uniform mat4 ProjMat;
uniform mat4 ViewMat;
uniform vec4 WorldOrigin;
uvec3 LocalInvocationID;
uint LocalInvocationIndex;
uvec3 GlobalInvocationID;
uvec3 WorkGroupID;
struct LightData {
    float lookup;
};

struct LightCluster {
    int count;
};

struct LightDistance {
    float distance;
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

layout(std430, binding = 1)buffer s_Extends { LightExtends Extends[]; };
layout(std430, binding = 0)buffer s_LightLookupArray { LightData LightLookupArray[]; };
#ifdef CLUSTER_LIGHTS_PASS
float getViewSpaceCoordByRatio(float clusterIndex, float clusterSize, float screenDim, float farPlaneDim, float planeRatio) {
    return ((clusterIndex * clusterSize - screenDim / 2.0f) / screenDim) * (farPlaneDim * planeRatio);
}
#endif
float getClusterDepthByIndex(float index, float maxSlices, vec2 clusterNearFar) {
    float zNear = clusterNearFar.x;
    float zFar = clusterNearFar.y;
    float nearFarLog = log(zFar / zNear);
    float logDepth = nearFarLog * index / maxSlices + log(zNear);
    return exp(logDepth);
}
void ClusterLights() {
    float x = float(GlobalInvocationID.x);
    float y = float(GlobalInvocationID.y);
    float z = float(GlobalInvocationID.z);
    int lightCount = int(ClusterDimensions.w);
    int maxLights = int(LightsPerCluster.x);
    if (x >= ClusterDimensions.x || y >= ClusterDimensions.y || z >= ClusterDimensions.z) {
        return;
    }
    highp int idx = int(x + y * ClusterDimensions.x + z * ClusterDimensions.x * ClusterDimensions.y);
    highp int rangeStart = int(idx * maxLights);
    highp int rangeEnd = int(rangeStart + maxLights);
    #ifdef CLUSTER_LIGHTS_PASS
    float viewDepth = getClusterDepthByIndex(z + 0.5f, ClusterDimensions.z, ClusterNearFarWidthHeight.xy);
    float planeRatio = viewDepth / CameraFarPlane.z;
    float centerX = getViewSpaceCoordByRatio(x + 0.5f, ClusterSize.x, ClusterNearFarWidthHeight.z, CameraFarPlane.x, planeRatio);
    float centerY = getViewSpaceCoordByRatio(y + 0.5f, ClusterSize.y, ClusterNearFarWidthHeight.w, CameraFarPlane.y, planeRatio);
    vec3 center = vec3(centerX, centerY, - viewDepth);
    LightDistance distanceToCenter[64];
    #endif
    #ifdef CLUSTER_LIGHTS_MANHATTAN_PASS
    LightDistance distanceToCamera[64];
    vec2 corners[7];
    corners[0] = vec2(1.0f, 0.0f);
    corners[1] = vec2(0.0f, 1.0f);
    corners[2] = vec2(1.0f, 1.0f);
    corners[3] = vec2(0.0f, 0.0f);
    corners[4] = vec2(1.0f, 0.0f);
    corners[5] = vec2(0.0f, 1.0f);
    corners[6] = vec2(1.0f, 1.0f);
    #endif
    int countResult = 0;
    for(int l = 0; l < lightCount; l ++ ) {
        LightExtends bound = Extends[l];
        #ifdef CLUSTER_LIGHTS_PASS
        if (z < bound.min.z || z > bound.max.z)continue;
        if (y < bound.min.y || y > bound.max.y)continue;
        if (x < bound.min.x || x > bound.max.x)continue;
        float curDistance = length(bound.pos.xyz - center);
        if (countResult >= maxLights && curDistance >= distanceToCenter[countResult - 1].distance) {
            #endif
            #ifdef CLUSTER_LIGHTS_MANHATTAN_PASS
            if (z < bound.min.z || z > bound.max.z)
            #endif
            continue;
            #ifdef CLUSTER_LIGHTS_MANHATTAN_PASS
            if (y < bound.min.y || y > bound.max.y)
            continue;
            if (x < bound.min.x || x > bound.max.x)
            continue;
            float curDistance = length(((ViewMat) * (vec4(bound.pos.xyz, 1.0f))).xyz);
            if (countResult >= maxLights && curDistance >= distanceToCamera[countResult - 1].distance) {
                continue;
                #endif
            }
            #ifdef CLUSTER_LIGHTS_MANHATTAN_PASS
            vec3 lightWorldGrid = floor(bound.pos.xyz - WorldOrigin.xyz);
            float cornerViewZ = getClusterDepthByIndex(z, ClusterDimensions.z, ClusterNearFarWidthHeight.xy);
            float cornerScreenX = (max(x * ClusterSize.x, ClusterNearFarWidthHeight.z) - ClusterNearFarWidthHeight.z / 2.0f) / ClusterNearFarWidthHeight.z;
            float cornerScreenY = (max(y * ClusterSize.y, ClusterNearFarWidthHeight.w) - ClusterNearFarWidthHeight.w / 2.0f) / ClusterNearFarWidthHeight.w;
            float cornerViewX = cornerViewZ * cornerScreenX / ProjMat[0][0];
            float cornerViewY = cornerViewZ * cornerScreenY / ProjMat[1][1];
            vec3 clusterWorld = ((InvViewMat) * (vec4(cornerViewX, cornerViewY, - cornerViewZ, 1.0f))).xyz;
            vec3 clusterWorldGrid = floor(clusterWorld - WorldOrigin.xyz);
            vec3 clusterWorldGridMin = clusterWorldGrid;
            vec3 clusterWorldGridMax = clusterWorldGrid;
            for(int cf = 0; cf < 3; cf ++ ) {
                cornerScreenX = ((x + corners[cf].x) * ClusterSize.x - ClusterNearFarWidthHeight.z / 2.0f) / ClusterNearFarWidthHeight.z;
                cornerScreenY = ((y + corners[cf].y) * ClusterSize.y - ClusterNearFarWidthHeight.w / 2.0f) / ClusterNearFarWidthHeight.w;
                cornerViewX = cornerViewZ * cornerScreenX / ProjMat[0][0];
                cornerViewY = cornerViewZ * cornerScreenY / ProjMat[1][1];
                clusterWorld = ((InvViewMat) * (vec4(cornerViewX, cornerViewY, - cornerViewZ, 1.0f))).xyz;
                clusterWorldGrid = floor(clusterWorld - WorldOrigin.xyz);
                clusterWorldGridMin = min(clusterWorldGrid, clusterWorldGridMin);
                clusterWorldGridMax = max(clusterWorldGrid, clusterWorldGridMax);
            }
            cornerViewZ = getClusterDepthByIndex(z + 1.0f, ClusterDimensions.z, ClusterNearFarWidthHeight.xy);
            for(int cb = 3; cb < 7; cb ++ ) {
                cornerScreenX = ((x + corners[cb].x) * ClusterSize.x - ClusterNearFarWidthHeight.z / 2.0f) / ClusterNearFarWidthHeight.z;
                cornerScreenY = ((y + corners[cb].y) * ClusterSize.y - ClusterNearFarWidthHeight.w / 2.0f) / ClusterNearFarWidthHeight.w;
                cornerViewX = cornerViewZ * cornerScreenX / ProjMat[0][0];
                cornerViewY = cornerViewZ * cornerScreenY / ProjMat[1][1];
                clusterWorld = ((InvViewMat) * (vec4(cornerViewX, cornerViewY, - cornerViewZ, 1.0f))).xyz;
                clusterWorldGrid = floor(clusterWorld - WorldOrigin.xyz);
                clusterWorldGridMin = min(clusterWorldGrid, clusterWorldGridMin);
                clusterWorldGridMax = max(clusterWorldGrid, clusterWorldGridMax);
            }
            bool lightInCluster = true;
            for(int gridX = int(clusterWorldGridMin.x); gridX <= int(clusterWorldGridMax.x); gridX ++ ) {
                for(int gridY = int(clusterWorldGridMin.y); gridY <= int(clusterWorldGridMax.y); gridY ++ ) {
                    for(int gridZ = int(clusterWorldGridMin.z); gridZ <= int(clusterWorldGridMax.z); gridZ ++ ) {
                        vec3 curWorldGrid = vec3(float(gridX), float(gridY), float(gridZ));
                        vec3 dir = curWorldGrid - lightWorldGrid;
                        float manhattan = abs(dir.x) + abs(dir.y) + abs(dir.z);
                        if (manhattan <= bound.radius) {
                            lightInCluster = true;
                            break;
                        }
                    }
                }
            }
            if (lightInCluster) {
                #endif
                int low = 0;
                int high = countResult;
                #ifdef CLUSTER_LIGHTS_PASS
                while(low < high) {
                    #endif
                    #ifdef CLUSTER_LIGHTS_MANHATTAN_PASS
                    while(low < high) {
                        #endif
                        int mid = (low + high) / 2;
                        #ifdef CLUSTER_LIGHTS_PASS
                        if (distanceToCenter[mid].distance < curDistance) {
                            #endif
                            #ifdef CLUSTER_LIGHTS_MANHATTAN_PASS
                            if (distanceToCamera[mid].distance < curDistance) {
                                #endif
                                low = mid + 1;
                            }
                            else {
                                high = mid;
                            }
                        }
                        #ifdef CLUSTER_LIGHTS_PASS
                        if (countResult < maxLights) {
                            for(int j = countResult - 1; j >= low; j -- ) {
                                distanceToCenter[j + 1] = distanceToCenter[j];
                                #endif
                                #ifdef CLUSTER_LIGHTS_MANHATTAN_PASS
                                if (countResult < maxLights) {
                                    for(int j = countResult - 1; j >= low; j -- ) {
                                        distanceToCamera[j + 1] = distanceToCamera[j];
                                        #endif
                                    }
                                    #ifdef CLUSTER_LIGHTS_PASS
                                    distanceToCenter[low].distance = curDistance;
                                    distanceToCenter[low].indexInLookUp = countResult;
                                    #endif
                                    #ifdef CLUSTER_LIGHTS_MANHATTAN_PASS
                                    distanceToCamera[low].distance = curDistance;
                                    distanceToCamera[low].indexInLookUp = countResult;
                                    #endif
                                    LightLookupArray[idx * maxLights + countResult].lookup = float(bound.index);
                                    countResult ++ ;
                                }
                                else {
                                    #ifdef CLUSTER_LIGHTS_PASS
                                    int insertPos = distanceToCenter[maxLights - 1].indexInLookUp;
                                    for(int j = maxLights - 2; j >= low; j -- ) {
                                        distanceToCenter[j + 1] = distanceToCenter[j];
                                        #endif
                                        #ifdef CLUSTER_LIGHTS_MANHATTAN_PASS
                                        int insertPos = distanceToCamera[maxLights - 1].indexInLookUp;
                                        for(int j = maxLights - 2; j >= low; j -- ) {
                                            distanceToCamera[j + 1] = distanceToCamera[j];
                                            #endif
                                        }
                                        #ifdef CLUSTER_LIGHTS_PASS
                                        distanceToCenter[low].distance = curDistance;
                                        distanceToCenter[low].indexInLookUp = insertPos;
                                        #endif
                                        #ifdef CLUSTER_LIGHTS_MANHATTAN_PASS
                                        distanceToCamera[low].distance = curDistance;
                                        distanceToCamera[low].indexInLookUp = insertPos;
                                        #endif
                                        LightLookupArray[idx * maxLights + insertPos].lookup = float(bound.index);
                                    }
                                }
                                #ifdef CLUSTER_LIGHTS_MANHATTAN_PASS
                            }
                            #endif
                            if (countResult < maxLights) {
                                LightLookupArray[rangeStart + countResult].lookup = -1.0;
                            }
                        }
                        
                        layout(local_size_x = 4, local_size_y = 4, local_size_z = 4)in;
                        void main() {
                            LocalInvocationID = gl_LocalInvocationID;
                            LocalInvocationIndex = gl_LocalInvocationIndex;
                            GlobalInvocationID = gl_GlobalInvocationID;
                            WorkGroupID = gl_WorkGroupID;
                            ClusterLights();
                        }
                        
                        