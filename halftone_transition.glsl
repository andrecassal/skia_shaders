// https://www.shadertoy.com/view/MctSWj
const float SPEED = 15.;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float frag_size = 32.;
    vec2 size = vec2(640., 360.);
    float actual_speed = SPEED * 50.;
    vec2 uv = mod(fragCoord / iResolution.xy * size, frag_size) / frag_size;
    float func = sin((fragCoord.y / iResolution.y * size.y + (iTime - 2.) * actual_speed) / iResolution.y);
    uv = vec2(step(func, length(uv - 0.5)));
    
    // Output to screen
    fragColor = vec4(uv.x);
}
