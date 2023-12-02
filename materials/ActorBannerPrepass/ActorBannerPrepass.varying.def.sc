int  a_indices   : BLENDINDICES;
vec4 a_color0    : COLOR0;
vec4 a_normal    : NORMAL;
vec3 a_position  : POSITION;
vec4 a_tangent   : TANGENT;
vec2 a_texcoord0 : TEXCOORD0;

vec4 i_data1 : TEXCOORD7;
vec4 i_data2 : TEXCOORD6;
vec4 i_data3 : TEXCOORD5;

vec3          v_bitangent    : BITANGENT;
vec4          v_color0       : COLOR0;
vec4          v_fog          : COLOR2;
vec4          v_light        : COLOR3;
vec3          v_normal       : NORMAL;
vec3          v_prevWorldPos : TEXCOORD4;
vec3          v_tangent      : TANGENT;
centroid vec2 v_texcoord0    : TEXCOORD0;
centroid vec4 v_texcoords    : TEXCOORD2;
vec3          v_worldPos     : TEXCOORD3;
