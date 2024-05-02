/*
* Available Macros:
*
* Passes:
* - CLUSTER_LIGHTS_PASS
* - CLUSTER_LIGHTS_MANHATTAN_PASS
* - FALLBACK_PASS (not used)
*
* ChangeMaxLightPerCluster:
* - CHANGE_MAX_LIGHT_PER_CLUSTER__HIGHER
* - CHANGE_MAX_LIGHT_PER_CLUSTER__LOWER
* - CHANGE_MAX_LIGHT_PER_CLUSTER__OFF
*/

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
uniform vec4 CameraClusterWeight;
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

BUFFER_RW_AUTOREG(s_Extends, LightExtends);
BUFFER_RW_AUTOREG(s_LightLookupArray, LightData);
#ifdef CLUSTER_LIGHTS_PASS
float getViewSpaceCoordByRatio(float clusterIndex, float clusterSize, float screenDim, float farPlaneDim, float planeRatio) {
    return ((clusterIndex * clusterSize - screenDim / 2.0f) / screenDim) * (farPlaneDim * planeRatio); // Attention!
}
#endif
#ifdef CLUSTER_LIGHTS_MANHATTAN_PASS
float clusterIndexToScreenCoord(float index, float clusterSize, float dimension) {
    return (min(index * clusterSize, dimension) - dimension / 2.0f) / dimension;
}
#endif
float getClusterDepthByIndex(float index, float maxSlices, vec2 clusterNearFar) {
    float zNear = clusterNearFar.x;
    float zFar = clusterNearFar.y;
    if (index == 0.0f) {
        return zNear;
    }
    if (index == 1.0f) {
        return 1.0f;
    }
    float nearFarLog = log2(zFar / 1.5f);
    float logDepth = nearFarLog * (index - 2.0f) / (maxSlices - 2.0f);
    return pow(2.0f, logDepth);
}
#ifdef CLUSTER_LIGHTS_MANHATTAN_PASS

#endif
#if defined(CHANGE_MAX_LIGHT_PER_CLUSTER__HIGHER)&& defined(CLUSTER_LIGHTS_MANHATTAN_PASS)
shared LightContribution contributionArray[64][64]; // Attention!
#endif
#if defined(CHANGE_MAX_LIGHT_PER_CLUSTER__LOWER)&& defined(CLUSTER_LIGHTS_MANHATTAN_PASS)
shared LightContribution contributionArray[64][16]; // Attention!
#endif
#if defined(CHANGE_MAX_LIGHT_PER_CLUSTER__OFF)&& defined(CLUSTER_LIGHTS_MANHATTAN_PASS)
shared LightContribution contributionArray[64][32]; // Attention!
#endif
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
    LightContribution distanceToCenter[32];
    #endif
    #ifdef CLUSTER_LIGHTS_MANHATTAN_PASS
    vec2 corners[7];
    corners[0] = vec2(1.0f, 0.0f);
    corners[1] = vec2(0.0f, 1.0f);
    corners[2] = vec2(1.0f, 1.0f);
    corners[3] = vec2(1.0f, 1.0f);
    corners[4] = vec2(0.0f, 1.0f);
    corners[5] = vec2(1.0f, 0.0f);
    corners[6] = vec2(0.0f, 0.0f);
    int closestCornerToCameraIndex = 3;
    float left = x;
    float right = x + 1.0f;
    float bottom = y;
    float top = y + 1.0f;
    if (right < ClusterDimensions.x / 2.0f && top < ClusterDimensions.y / 2.0f) {
        closestCornerToCameraIndex = 2;
    }
    else if (left > ClusterDimensions.x / 2.0f && top < ClusterDimensions.y / 2.0f) {
        closestCornerToCameraIndex = 1;
    }
    else if (right < ClusterDimensions.x / 2.0f && bottom > ClusterDimensions.y / 2.0f) {
        closestCornerToCameraIndex = 0;
    }
    else if (left > ClusterDimensions.x / 2.0f && bottom > ClusterDimensions.y / 2.0f) {
        closestCornerToCameraIndex = -1;
    }
    int oppositeCornerIndex = 4 + closestCornerToCameraIndex;
    #endif
    int countResult = 0;
    for(int l = 0; l < lightCount; l ++ ) {
        LightExtends bound = Extends[l];
        #ifdef CLUSTER_LIGHTS_PASS
        if (z < bound.min.z || z > bound.max.z)continue;
        if (y < bound.min.y || y > bound.max.y)continue;
        if (x < bound.min.x || x > bound.max.x)continue;
        float curDistance = length(bound.pos.xyz - center);
        if (countResult >= maxLights && curDistance >= distanceToCenter[countResult - 1].contribution) {
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
            vec3 closestCornerToCameraView = vec3(0.0f, 0.0f, 0.0f);
            vec3 oppositeCornerView = vec3(0.0f, 0.0f, 0.0f);
            vec3 lightWorldGrid = floor(bound.pos.xyz - WorldOrigin.xyz);
            float cornerViewZ = getClusterDepthByIndex(z, ClusterDimensions.z, ClusterNearFarWidthHeight.xy);
            float cornerScreenX = clusterIndexToScreenCoord(x, ClusterSize.x, ClusterNearFarWidthHeight.z);
            float cornerScreenY = clusterIndexToScreenCoord(y, ClusterSize.y, ClusterNearFarWidthHeight.w);
            float cornerViewX = cornerViewZ * cornerScreenX / ProjMat[0][0]; // Attention!
            float cornerViewY = cornerViewZ * cornerScreenY / ProjMat[1][1]; // Attention!
            vec3 clusterWorld = ((InvViewMat) * (vec4(cornerViewX, cornerViewY, - cornerViewZ, 1.0f))).xyz; // Attention!
            vec3 clusterWorldGrid = floor(clusterWorld - WorldOrigin.xyz);
            vec3 clusterWorldGridMin = clusterWorldGrid;
            vec3 clusterWorldGridMax = clusterWorldGrid;
            if (closestCornerToCameraIndex == -1) {
                closestCornerToCameraView = vec3(cornerViewX, cornerViewY, - cornerViewZ);
                #endif
            }
            #ifdef CLUSTER_LIGHTS_MANHATTAN_PASS
            if (closestCornerToCameraIndex == 3) {
                cornerScreenX = clusterIndexToScreenCoord(x + 0.5f, ClusterSize.x, ClusterNearFarWidthHeight.z);
                cornerScreenY = clusterIndexToScreenCoord(y + 0.5f, ClusterSize.y, ClusterNearFarWidthHeight.w);
                cornerViewX = cornerViewZ * cornerScreenX / ProjMat[0][0]; // Attention!
                cornerViewY = cornerViewZ * cornerScreenY / ProjMat[1][1]; // Attention!
                closestCornerToCameraView = vec3(cornerViewX, cornerViewY, - cornerViewZ);
            }
            for(int cf = 0; cf < 3; cf ++ ) {
                cornerScreenX = clusterIndexToScreenCoord(x + corners[cf].x, ClusterSize.x, ClusterNearFarWidthHeight.z);
                cornerScreenY = clusterIndexToScreenCoord(y + corners[cf].y, ClusterSize.y, ClusterNearFarWidthHeight.w);
                cornerViewX = cornerViewZ * cornerScreenX / ProjMat[0][0]; // Attention!
                cornerViewY = cornerViewZ * cornerScreenY / ProjMat[1][1]; // Attention!
                clusterWorld = ((InvViewMat) * (vec4(cornerViewX, cornerViewY, - cornerViewZ, 1.0f))).xyz; // Attention!
                clusterWorldGrid = floor(clusterWorld - WorldOrigin.xyz);
                clusterWorldGridMin = min(clusterWorldGrid, clusterWorldGridMin);
                clusterWorldGridMax = max(clusterWorldGrid, clusterWorldGridMax);
                if (closestCornerToCameraIndex == cf) {
                    closestCornerToCameraView = vec3(cornerViewX, cornerViewY, - cornerViewZ);
                }
            }
            cornerViewZ = getClusterDepthByIndex(z + 1.0f, ClusterDimensions.z, ClusterNearFarWidthHeight.xy);
            for(int cb = 3; cb < 7; cb ++ ) {
                cornerScreenX = clusterIndexToScreenCoord(x + corners[cb].x, ClusterSize.x, ClusterNearFarWidthHeight.z);
                cornerScreenY = clusterIndexToScreenCoord(y + corners[cb].y, ClusterSize.y, ClusterNearFarWidthHeight.w);
                cornerViewX = cornerViewZ * cornerScreenX / ProjMat[0][0]; // Attention!
                cornerViewY = cornerViewZ * cornerScreenY / ProjMat[1][1]; // Attention!
                clusterWorld = ((InvViewMat) * (vec4(cornerViewX, cornerViewY, - cornerViewZ, 1.0f))).xyz; // Attention!
                clusterWorldGrid = floor(clusterWorld - WorldOrigin.xyz);
                clusterWorldGridMin = min(clusterWorldGrid, clusterWorldGridMin);
                clusterWorldGridMax = max(clusterWorldGrid, clusterWorldGridMax);
                if (oppositeCornerIndex == cb) {
                    oppositeCornerView = vec3(cornerViewX, cornerViewY, - cornerViewZ);
                }
            }
            if (oppositeCornerIndex == 7) {
                cornerScreenX = clusterIndexToScreenCoord(x + 0.5f, ClusterSize.x, ClusterNearFarWidthHeight.z);
                cornerScreenY = clusterIndexToScreenCoord(y + 0.5f, ClusterSize.y, ClusterNearFarWidthHeight.w);
                cornerViewX = cornerViewZ * cornerScreenX / ProjMat[0][0]; // Attention!
                cornerViewY = cornerViewZ * cornerScreenY / ProjMat[1][1]; // Attention!
                oppositeCornerView = vec3(cornerViewX, cornerViewY, - cornerViewZ);
            }
            cornerViewZ = getClusterDepthByIndex(z + 0.5f, ClusterDimensions.z, ClusterNearFarWidthHeight.xy);
            cornerScreenX = clusterIndexToScreenCoord(x + 0.5f, ClusterSize.x, ClusterNearFarWidthHeight.z);
            cornerScreenY = clusterIndexToScreenCoord(y + 0.5f, ClusterSize.y, ClusterNearFarWidthHeight.w);
            cornerViewX = cornerViewZ * cornerScreenX / ProjMat[0][0]; // Attention!
            cornerViewY = cornerViewZ * cornerScreenY / ProjMat[1][1]; // Attention!
            vec3 centerView = vec3(cornerViewX, cornerViewY, - cornerViewZ);
            vec3 lightView = ((ViewMat) * (vec4(bound.pos.xyz, 1.0f))).xyz; // Attention!
            float lightDistance = length(lightView);
            float cameraDistanceContribution = max(1.0f - lightDistance / length(oppositeCornerView), 0.0f);
            float clusterContribution = max(1.0f - length(lightView - centerView) / (length(oppositeCornerView - closestCornerToCameraView) / 2.0f), 0.0f);
            float curContribution = CameraClusterWeight.x * cameraDistanceContribution + CameraClusterWeight.y * clusterContribution;
            if (countResult >= maxLights && curContribution <= contributionArray[LocalInvocationIndex][countResult - 1].contribution) { // Attention!
                continue;
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
                        if (distanceToCenter[mid].contribution < curDistance) {
                            #endif
                            #ifdef CLUSTER_LIGHTS_MANHATTAN_PASS
                            if (contributionArray[LocalInvocationIndex][mid].contribution >= curContribution) { // Attention!
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
                                        contributionArray[LocalInvocationIndex][j + 1] = contributionArray[LocalInvocationIndex][j]; // Attention!
                                        #endif
                                    }
                                    #ifdef CLUSTER_LIGHTS_PASS
                                    distanceToCenter[low].contribution = curDistance;
                                    distanceToCenter[low].indexInLookUp = countResult;
                                    #endif
                                    #ifdef CLUSTER_LIGHTS_MANHATTAN_PASS
                                    contributionArray[LocalInvocationIndex][low].contribution = curContribution; // Attention!
                                    contributionArray[LocalInvocationIndex][low].indexInLookUp = countResult; // Attention!
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
                                        int insertPos = contributionArray[LocalInvocationIndex][maxLights - 1].indexInLookUp; // Attention!
                                        for(int j = maxLights - 2; j >= low; j -- ) {
                                            contributionArray[LocalInvocationIndex][j + 1] = contributionArray[LocalInvocationIndex][j]; // Attention!
                                            #endif
                                        }
                                        #ifdef CLUSTER_LIGHTS_PASS
                                        distanceToCenter[low].contribution = curDistance;
                                        distanceToCenter[low].indexInLookUp = insertPos;
                                        #endif
                                        #ifdef CLUSTER_LIGHTS_MANHATTAN_PASS
                                        contributionArray[LocalInvocationIndex][low].contribution = curContribution; // Attention!
                                        contributionArray[LocalInvocationIndex][low].indexInLookUp = insertPos; // Attention!
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
                        
                        NUM_THREADS(4, 4, 4)
                        void main() {
                            LocalInvocationID = gl_LocalInvocationID;
                            LocalInvocationIndex = gl_LocalInvocationIndex;
                            GlobalInvocationID = gl_GlobalInvocationID;
                            WorkGroupID = gl_WorkGroupID;
                            ClusterLights();
                        }
                        
                        