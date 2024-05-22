/*
* Available Macros:
*
* Passes:
* - SSR_FILL_GAPS_PASS
* - SSR_GET_REFLECTED_COLOR_PASS
* - SSR_RAY_MARCH_PASS
*
* ExtendedGapFill:
* - EXTENDED_GAP_FILL__OFF
* - EXTENDED_GAP_FILL__ON
*/

#ifdef SSR_RAY_MARCH_PASS
$input v_projPosition
#endif
$input v_texcoord0
struct NoopSampler {
    int noop;
};

vec4 textureSample(mediump sampler2D _sampler, vec2 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump sampler3D _sampler, vec3 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump samplerCube _sampler, vec3 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump sampler2D _sampler, vec2 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
vec4 textureSample(mediump sampler3D _sampler, vec3 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
vec4 textureSample(mediump sampler2DArray _sampler, vec3 _coord) {
    return texture(_sampler, _coord);
}
vec4 textureSample(mediump sampler2DArray _sampler, vec3 _coord, float _lod) {
    return textureLod(_sampler, _coord, _lod);
}
vec4 textureSample(NoopSampler noopsampler, vec2 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec3 _coord) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec2 _coord, float _lod) {
    return vec4(0, 0, 0, 0);
}
vec4 textureSample(NoopSampler noopsampler, vec3 _coord, float _lod) {
    return vec4(0, 0, 0, 0);
}
#ifdef SSR_RAY_MARCH_PASS
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

uniform vec4 SSRRoughnessCutoffParams;
uniform vec4 CameraData;
uniform vec4 RenderMode;
uniform vec4 SSRFadingParams;
uniform vec4 SSRRayMarchingParams;
uniform vec4 ScreenSize;
uniform vec4 UnitPlaneExtents;
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
    vec4 position;
    vec2 texcoord0;
};

struct VertexOutput {
    vec4 position;
    #ifdef SSR_RAY_MARCH_PASS
    vec4 projPosition;
    #endif
    vec2 texcoord0;
};

struct FragmentInput {
    #ifdef SSR_RAY_MARCH_PASS
    vec4 projPosition;
    #endif
    vec2 texcoord0;
};

struct FragmentOutput {
    vec4 Color0;
};

SAMPLER2D_AUTOREG(s_GbufferDepth);
SAMPLER2D_AUTOREG(s_GbufferNormal);
SAMPLER2D_AUTOREG(s_GbufferRoughness);
SAMPLER2D_AUTOREG(s_InputTexture);
SAMPLER2D_AUTOREG(s_RasterColor);
#ifndef SSR_RAY_MARCH_PASS
bool isRayHit(float value) {
    return (value >= 0.0f);
}
#endif
#ifdef EXTENDED_GAP_FILL__ON
vec4 getSample(vec2 uv, vec2 offset) {
    vec4 result = textureSample(s_InputTexture, uv + offset);
    if (!isRayHit(result.a)) {
        result = textureSample(s_InputTexture, uv + (offset * 2.0));
    }
    return result;
}
#endif
#ifdef SSR_RAY_MARCH_PASS
vec2 octWrap(vec2 v) {
    return (1.0 - abs(v.yx)) * ((2.0 * step(0.0, v)) - 1.0); // Attention!
}
vec3 octToNdirSnorm(vec2 p) {
    vec3 n = vec3(p.xy, 1.0 - abs(p.x) - abs(p.y));
    n.xy = (n.z < 0.0) ? octWrap(n.xy) : n.xy;
    return normalize(n);
}
float ProjDepthToViewDepth(float z, float n, float f) {
    return (2.0f * f * n) / (z * (f - n) - f - n);
}
float ViewDepthToLinearDepth(float z, float n, float f) {
    return (- z - n) / (f - n);
}
float ProjDepthToLinearDepth(float z, float n, float f) {
    float viewDepth = ProjDepthToViewDepth(z, n, f);
    return ViewDepthToLinearDepth(viewDepth, n, f);
}
float GetWorldDepth(float linearDepth, float nearPlane, float farPlane) {
    return mix(nearPlane, farPlane, linearDepth);
}
vec4 uvToViewSpacePosWithDepth(vec2 uv, vec2 unitPlaneExtents, float d) {
    vec3 ray = vec3((vec2(uv.x, 1.0 - uv.y) * 2.0 - 1.0) * unitPlaneExtents.xy, - 1.0);
    return vec4(ray * d, 1.0);
}
vec4 projToView(vec4 p, mat4 inverseProj) {
    p = vec4(
        p.x * inverseProj[0][0], // Attention!
        p.y * inverseProj[1][1], // Attention!
        p.w * inverseProj[3][2], // Attention!
        p.z * inverseProj[2][3] + p.w * inverseProj[3][3]// Attention!
    );
    p /= p.w;
    return p;
}
vec3 viewSpaceToUV(vec3 viewPosition) {
    vec4 clipSpacePosition = ((Proj) * (vec4(viewPosition, 1.0))); // Attention!
    vec3 ndcPosition = (clipSpacePosition.xyz / clipSpacePosition.w);
    vec2 uv = (ndcPosition.xy + 1.0) * 0.5;
    return vec3((vec2((uv).x, 1.0 - (uv).y)), ndcPosition.z);
}
bool isDepthInCameraBounds(float depth, float nearPlane, float farPlane) {
    if (nearPlane < farPlane) {
        return (nearPlane < depth && depth < farPlane);
    }
    else {
        return (nearPlane > depth && depth > farPlane);
    }
}
float getFadingValue(vec2 uv, float roughness, float rayPercentage, float fadingPowerHorizontal, float fadingPowerVertical, float fadeDistance, float roughnessCutoff, float roughnessFadeStart, float aspectRatio) {
    uv = (uv * 2.0) - 1.0;
    uv.x = pow(abs(uv.x), fadingPowerHorizontal * aspectRatio);
    uv.y = pow(abs(uv.y), fadingPowerVertical);
    float fadeValueUV = (1.0 - uv.x) * (1.0 - uv.y); // Attention!
    float fadeValueRayPercentage = 1.0 - smoothstep(fadeDistance, 1.0, rayPercentage);
    float roughnessFadeDuration = roughnessCutoff - roughnessFadeStart;
    float roughnessLerpAlpha = (max(roughness, roughnessFadeStart) - roughnessFadeStart) / roughnessFadeDuration;
    float fadeValueRoughness = mix(1.0f, 0.0f, roughnessLerpAlpha);
    float fadeValue = min(fadeValueUV, fadeValueRayPercentage);
    fadeValue = min(fadeValue, fadeValueRoughness);
    return fadeValue;
}
int getStepsCount(vec3 rayStartScreenSpace, vec3 rayStepScreenSpace, int maxStepsCount) {
    vec3 stepsCountTopLeftNearCorner = rayStartScreenSpace / rayStepScreenSpace;
    vec3 stepsCountBottomRightFarCorner = (vec3(1.0, 1.0, 1.0) - rayStartScreenSpace) / rayStepScreenSpace;
    vec3 lowestStepCounts3 = vec3(rayStepScreenSpace.x < 0.0 ? abs(stepsCountTopLeftNearCorner.x) : stepsCountBottomRightFarCorner.x,
    rayStepScreenSpace.y < 0.0 ? abs(stepsCountTopLeftNearCorner.y) : stepsCountBottomRightFarCorner.y,
    rayStepScreenSpace.z < 0.0 ? abs(stepsCountTopLeftNearCorner.z) : stepsCountBottomRightFarCorner.z);
    float stepsCountF = min(min(lowestStepCounts3.x, lowestStepCounts3.y), lowestStepCounts3.z);
    int stepsCount = min(int(stepsCountF), maxStepsCount);
    return stepsCount;
}
int PerformLinearSearch(vec3 rayStartScreenSpace, vec3 rayStepScreenSpace, int stepsCount, float nearPlane, float farPlane, vec4 screenSize, sampler2D depthBuffer, out vec3 foundPosition) {
    foundPosition = vec3_splat(0.0);
    int foundIteration = -1;
    float prevRayZ = ProjDepthToLinearDepth(rayStartScreenSpace.z, nearPlane, farPlane);
    float sceneLinearDepth = 0.0;
    for(int i = 1; i <= stepsCount; i ++ ) {
        vec3 positionScreenSpace = rayStartScreenSpace + (rayStepScreenSpace * float(i));
        float rayLinearZ = ProjDepthToLinearDepth(positionScreenSpace.z, nearPlane, farPlane);
        sceneLinearDepth = ProjDepthToLinearDepth(textureSample(depthBuffer, positionScreenSpace.xy).x, nearPlane, farPlane);
        bool wasRayInFrontOfTexel = prevRayZ < sceneLinearDepth;
        bool isRayPastTheTexel = rayLinearZ > sceneLinearDepth;
        if (isRayPastTheTexel) {
            if (wasRayInFrontOfTexel) {
                foundIteration = i;
                foundPosition = positionScreenSpace;
                break;
            }
            else {
                break;
            }
        }
        prevRayZ = rayLinearZ;
    }
    return foundIteration;
}
float PerformBinarySearch(int foundIteration, vec3 rayStartScreenSpace, vec3 rayStepScreenSpace, int binarySearchStepsCount, float nearPlane, float farPlane, vec4 screenSize, sampler2D depthBuffer, inout vec3 foundPosition) {
    float searchIterationBeforeHit = float(foundIteration - 1);
    float searchIterationAfterHit = float(foundIteration);
    float refinedFoundIteration = searchIterationAfterHit;
    for(int i = 0; i < binarySearchStepsCount; i ++ ) {
        float searchIterationMidPoint = (searchIterationBeforeHit + searchIterationAfterHit) * 0.5f;
        vec3 positionScreenSpaceMidPoint = rayStartScreenSpace + (rayStepScreenSpace * searchIterationMidPoint);
        float sceneLinearDepth = ProjDepthToLinearDepth(textureSample(depthBuffer, positionScreenSpaceMidPoint.xy).x, nearPlane, farPlane);
        float rayLinearZ = ProjDepthToLinearDepth(positionScreenSpaceMidPoint.z, nearPlane, farPlane);
        bool isRayPastTheTexel = (rayLinearZ > sceneLinearDepth);
        if (isRayPastTheTexel) {
            searchIterationAfterHit = searchIterationMidPoint;
            refinedFoundIteration = searchIterationMidPoint;
            foundPosition = positionScreenSpaceMidPoint;
        }
        else {
            searchIterationBeforeHit = searchIterationMidPoint;
        }
    }
    return refinedFoundIteration;
}
vec4 CalculateSSRHitPoint(vec3 viewPosition, vec3 viewNormal, float roughness, int maxStepsCount, float rayStepLength, float offset, int binarySearchStepsCount, float fadingPowerHorizontal, float fadingPowerVertical, float fadingDistance, float roughnessCutoff, float roughnessFadeStart, float nearPlane, float farPlane, float aspectRatio, vec2 unitPlaneExtents, vec4 screenSize, sampler2D depthBuffer) {
    vec3 viewDir = normalize(viewPosition);
    vec3 reflectionDir = reflect(viewDir, viewNormal);
    vec3 rayStartView = viewPosition + (reflectionDir * offset);
    vec3 rayEndView = rayStartView + reflectionDir;
    if (!isDepthInCameraBounds(rayEndView.z, nearPlane, farPlane)|| ! isDepthInCameraBounds(rayStartView.z, nearPlane, farPlane)) {
        return vec4(0.0, 0.0, 0.0, - 1.0);
    }
    vec3 rayStartScreenSpace = viewSpaceToUV(rayStartView);
    vec3 rayEndScreenSpace = viewSpaceToUV(rayEndView);
    vec3 rayScreenSpace = rayEndScreenSpace - rayStartScreenSpace;
    vec2 rayInPixels = (rayScreenSpace.xy * screenSize.xy);
    float maxPixelsStepsCount = max(abs(rayInPixels.x), abs(rayInPixels.y));
    vec3 normalizedRayScreenSpace = (rayScreenSpace / maxPixelsStepsCount);
    vec3 rayStepScreenSpace = rayStepLength * normalizedRayScreenSpace;
    int stepsCount = getStepsCount(rayStartScreenSpace, rayStepScreenSpace, maxStepsCount);
    vec3 foundPosition = vec3_splat(0.0);
    int foundIteration = PerformLinearSearch(
        rayStartScreenSpace,
        rayStepScreenSpace,
        stepsCount,
        nearPlane,
        farPlane,
        screenSize,
        depthBuffer,
    foundPosition);
    if (foundIteration < 0) {
        return vec4(0.0, 0.0, 0.0, - 1.0);
    }
    float refinedFoundIteration = PerformBinarySearch(
        foundIteration,
        rayStartScreenSpace,
        rayStepScreenSpace,
        binarySearchStepsCount,
        nearPlane,
        farPlane,
        screenSize,
        depthBuffer,
    foundPosition);
    float rayPercentage = refinedFoundIteration / float(stepsCount);
    float fadingValue = getFadingValue(
        foundPosition.xy,
        roughness,
        rayPercentage,
        fadingPowerHorizontal,
        fadingPowerVertical,
        fadingDistance,
        roughnessCutoff,
        roughnessFadeStart,
    aspectRatio);
    float linearDepth = ProjDepthToLinearDepth(foundPosition.z, nearPlane, farPlane);
    float rayDepth = GetWorldDepth(linearDepth, nearPlane, farPlane);
    vec4 viewFoundPosition = uvToViewSpacePosWithDepth(foundPosition.xy, unitPlaneExtents.xy, rayDepth);
    float rayLength = distance(viewPosition, viewFoundPosition.xyz);
    return vec4(foundPosition.xy, rayLength, fadingValue);
}
vec4 RayMarch(vec2 uv, vec2 projPos, float roughness, int maxStepsCount, float rayStepLength, float offset, int binarySearchStepCount, float fadingPowerHorizontal, float fadingPowerVertical, float fadingDistance, float roughnessCutoff, float roughnessFadeStart, float nearPlane, float farPlane, float aspectRatio, vec2 unitPlaneExtents, vec4 screenSize, sampler2D depthBuffer, sampler2D normalVelocityBuffer) {
    vec4 color = vec4(0.0, 0.0, 0.0, - 1.0);
    float d = textureSample(depthBuffer, uv).x;
    vec3 viewPos = projToView(vec4(projPos, d, 1.0), InvProj).xyz;
    vec3 worldNorm = normalize(octToNdirSnorm(textureSample(normalVelocityBuffer, uv).xy));
    vec3 viewNormal = normalize(((View) * (vec4(worldNorm, 0.0))).xyz); // Attention!
    color = CalculateSSRHitPoint(
        viewPos,
        viewNormal,
        roughness,
        maxStepsCount,
        rayStepLength,
        offset,
        binarySearchStepCount,
        fadingPowerHorizontal,
        fadingPowerVertical,
        fadingDistance,
        roughnessCutoff,
        roughnessFadeStart,
        nearPlane,
        farPlane,
        aspectRatio,
        unitPlaneExtents,
        screenSize,
    depthBuffer);
    return color;
}
#endif
void Frag(FragmentInput fragInput, inout FragmentOutput fragOutput) {
    #ifdef SSR_FILL_GAPS_PASS
    vec2 uv = fragInput.texcoord0.xy;
    vec2 pixelSize = ScreenSize.zw;
    vec4 data = textureSample(s_InputTexture, uv);
    if (!isRayHit(data.a)) {
        #endif
        #ifdef EXTENDED_GAP_FILL__OFF
        vec4 up = textureSample(s_InputTexture, uv + vec2(0.0, + pixelSize.y));
        vec4 dn = textureSample(s_InputTexture, uv + vec2(0.0, - pixelSize.y));
        #endif
        #ifdef EXTENDED_GAP_FILL__ON
        vec4 up = getSample(uv, vec2(0.0, + pixelSize.y));
        vec4 dn = getSample(uv, vec2(0.0, - pixelSize.y));
        #endif
        #ifdef SSR_FILL_GAPS_PASS
        if (isRayHit(up.a)&& isRayHit(dn.a)) {
            data = (up + dn) * 0.5;
            #endif
            #ifdef SSR_GET_REFLECTED_COLOR_PASS
            vec4 data = textureSample(s_InputTexture, fragInput.texcoord0.xy);
            vec4 color0 = vec4(0.0, 0.0, 0.0, 0.0);
            if (isRayHit(data.a)) {
                vec2 uv = data.xy;
                color0 = vec4(textureSample(s_RasterColor, uv).rgb, data.a);
                #endif
                #ifdef SSR_RAY_MARCH_PASS
                float roughness = textureSample(s_GbufferRoughness, fragInput.texcoord0.xy).a;
                if (roughness > SSRRoughnessCutoffParams.x) {
                    fragOutput.Color0 = vec4(0.0f, 0.0f, 0.0f, - 1.0);
                    #endif
                }
                #ifdef SSR_RAY_MARCH_PASS
                else {
                    fragOutput.Color0 = RayMarch(
                        fragInput.texcoord0.xy,
                        fragInput.projPosition.xy,
                        roughness,
                        int(SSRRayMarchingParams.x),
                        SSRRayMarchingParams.y,
                        SSRRayMarchingParams.z,
                        int(SSRRayMarchingParams.w),
                        SSRFadingParams.x,
                        SSRFadingParams.y,
                        SSRFadingParams.z,
                        SSRRoughnessCutoffParams.x,
                        SSRRoughnessCutoffParams.y,
                        CameraData.x,
                        CameraData.y,
                        CameraData.z,
                        UnitPlaneExtents.xy,
                        ScreenSize,
                        s_GbufferDepth,
                    s_GbufferNormal);
                    #endif
                    #ifndef SSR_GET_REFLECTED_COLOR_PASS
                }
                #endif
                #ifdef SSR_FILL_GAPS_PASS
                fragOutput.Color0 = data;
                #endif
                #ifdef SSR_GET_REFLECTED_COLOR_PASS
                fragOutput.Color0 = color0;
                #endif
            }
            void main() {
                FragmentInput fragmentInput;
                FragmentOutput fragmentOutput;
                #ifdef SSR_RAY_MARCH_PASS
                fragmentInput.projPosition = v_projPosition;
                #endif
                fragmentInput.texcoord0 = v_texcoord0;
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
                #ifndef SSR_GET_REFLECTED_COLOR_PASS
                gl_FragColor = fragmentOutput.Color0;
                #endif
                #ifdef SSR_GET_REFLECTED_COLOR_PASS
                gl_FragData[0] = fragmentOutput.Color0; ;
                #endif
            }
            
            