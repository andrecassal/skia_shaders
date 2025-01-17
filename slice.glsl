// https://www.shadertoy.com/view/md3czB
// MIT License

const float sliceAngleDefault = 160.0;
const float randSliceAngleVariation = 20.0;
const float sliceCount = 6.0;

float random (vec2 st) { 
    return fract(sin(dot(st.xy, vec2(12.9798,78.323))) * 43758.5453234);
}

float remap(float r, float minVal) { // remap value from [0, min] to [min,1]
    if (r < minVal) {
        r = (1.0 - minVal) / minVal * r + minVal;
    }
    return r;
}

vec2 rotate(vec2 p, float angle) {
    float r = radians(angle);
	float s = sin(r);
	float c = cos(r);
	return mat2(c, -s, s, c) * p;
}

vec2 sliceData(vec2 p, float count, float angle, float seed) {
	p = rotate(p, angle);
    float sliceId = floor(p.x * count);
	return vec2(remap(random(vec2(sliceId) + seed), 0.3), sliceId);
}

vec2 clampByAngle(vec2 offset, float angle) {
    angle = mod(angle, 360.0);
    vec2 ret = offset;
    if (0.0 <= angle && angle < 90.0) {
        ret.x = clamp(ret.x, 0.0, 1.0);
        ret.y = clamp(ret.y, -1.0, 0.0);
    } else if (90.0 <= angle && angle < 180.0) {
        ret.x = clamp(ret.x, 0.0, 1.0);
        ret.y = clamp(ret.y, 0.0, 1.0);
    } else if (180.0 <= angle && angle < 270.0) {
        ret.x = clamp(ret.x, -1.0, 0.0);
        ret.y = clamp(ret.y, 0.0, 1.0);
    } else if (270.0 <= angle && angle < 360.0) {
        ret.x = clamp(ret.x, -1.0, 0.0);
        ret.y = clamp(ret.y, -1.0, 0.0);
    }
    return ret;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
    float progress = mod(iTime*0.5, 1.0);
    float seed = floor(iTime*0.5);
    float sliceAngle = sliceAngleDefault + randSliceAngleVariation*random(vec2(seed,seed));
    
    vec2 data = sliceData(uv, sliceCount, sliceAngle, seed); 
    float r = data.x; // random value for each slice
    float id = data.y;
    
    progress = smoothstep(0.0, r, progress);
    vec2 dir = rotate(vec2(1.0), -45.0 - sliceAngle);
    vec2 offset = vec2(1.0 - progress);
    vec2 offset2 = -vec2(1.0) + offset;
    offset = rotate(offset, -45.0 - sliceAngle);
    offset2 = rotate(offset2, -45.0 - sliceAngle)+normalize(dir)*0.398;
    offset2 = clampByAngle(offset2, sliceAngle);
    
    
    uv += offset2*0.3;
    vec4 color = vec4(0.0);
    color = textureLod(iChannel0, uv, smoothstep(0.0, 1.0, progress)*7.0);
    color *= smoothstep(0.0, 1.0, 1.0-progress);
    uv += offset - offset2*0.3;
    if (0.0 <= uv.x && uv.x <= 1.0 && 0.0 <= uv.y && uv.y <= 1.0) {
        color = textureLod(iChannel1, uv, smoothstep(0.0, 1.0, (1.0-progress)*7.0));
        color *= clamp(smoothstep(0.3, 1.0, progress), 0.3, 1.0);
    }
    fragColor = color;
}
