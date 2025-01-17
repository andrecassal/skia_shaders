#define HALF_PI 1.5707963267948966

// colors used
vec4 colors[3] = vec4[3](
    vec4(0.3372, 0.8901, 0.8078, 1.0),
    vec4(0.8156, 0.9019, 0.6470, 1.0),
    vec4(1.0));

// delay until the bubble animation start (first bubble starts at second 1.0 of the effect)
float delays[3] = float[3](1.0, 1.2, 1.5);

// center of the animation in UV coordinates
vec2 center = vec2(0.5, 0.5);

// time that it takes each for a bubble to completely fill the screen
float duration = 0.4;

// method to use for bubble expansion
float easing(float t) {
  	// cuadOut
  	return -t * (t - 2.0);
    // sine
    // return sin(t * HALF_PI);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // time is recalculated here so that it spans from 0 to the max duration of the transition
    // which is calculated using the last delay + the effect duration (in this case is 2.0 seconds)
    float time = mod(iTime, delays[2] + duration);
    // center in px coordinates
    vec2 centerPx = iResolution.xy * center;
    float dist = length(fragCoord - centerPx) / length(centerPx);
    // we'll stack the calculations on top of the fragColor, starting with full white
    fragColor = vec4(1.0);
    for(int i = 0; i < 3; i+=1) {
        float progress = easing(clamp((time - delays[i]) / duration, 0.0, 1.0));
        float mixRatio = step(dist, progress);
    	fragColor = mix(fragColor, colors[i], mixRatio);
    }
}
