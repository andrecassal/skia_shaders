
// https://www.shadertoy.com/view/MfjyRw

#define CELLS 50.0
#define STEPS 50.0
#define COLOR1 vec3(0.067,0.149,0.184)
#define COLOR2 vec3(0.161,0.263,0.349)
#define STROKE_WIDTH .05
#define STROKE_OPACITY .15

vec2 ratio(vec2 ps) {
	float x = ps.x;
	float y = ps.y;
	vec2 ratio = vec2(1, 1);
	if (x > y)
		ratio = vec2(1, y / x);
	else if (y > x)
		ratio = vec2(y / x, 1);
	return ratio;
}

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float cellSize = 1.0 / CELLS;
    
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    
    vec2 nUv = uv * vec2(iResolution.x / iResolution.y, 1.);
    
    vec4 tex = texture(iChannel0, nUv);
   
    
    float progress = (sin(iTime * 1.2) + 1. + (1. / CELLS)) * 0.5;
    
    vec2 sUv = fract(nUv * (1. / cellSize));

    float distToEdge = min(min(sUv.x, 1. - sUv.x), min(sUv.y, 1. - sUv.y));
		float strokeFactor = smoothstep(STROKE_WIDTH - 0.05 * STROKE_WIDTH, STROKE_WIDTH + 0.05 * STROKE_WIDTH, distToEdge);
    
    vec2 pUv = nUv;
    
    pUv -= mod(pUv, cellSize);
		
    float stepProgress = mod(progress, 1. / cellSize);
    float fadeProgress = abs(pUv.y - 0.5) + stepProgress;
    fadeProgress = pow(fadeProgress, 5.);
    float fadeProgress2 = pow(fadeProgress, 2.);
    float fadeProgress3 = pow(fadeProgress2, 2.);
    float fadeProgress4 = pow(fadeProgress3, 2.);

    // pattern
    float r = max(0.07, random(pUv));
    float p = 1. - step(fadeProgress, r);
    float p2 = 1. - step(fadeProgress2, r);
    float p3 = 1. - step(fadeProgress3, r);
    float p4 = 1. - step(fadeProgress4, r);
    
    float rt = mix(p2, p3, stepProgress);
    vec3 pColor = mix(COLOR2, COLOR1, p3);
    
    // Output to screen
    fragColor = vec4(mix(tex.rgb, pColor, p2), 1.0);
    fragColor.xyz += mix(vec3(1.), vec3(0.), strokeFactor) * (p) * (1. - p4) * STROKE_OPACITY;
}
