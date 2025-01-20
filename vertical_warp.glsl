//https://www.shadertoy.com/view/Wdf3DX


#define PI 3.14159265359
mat2 scale(vec2 _scale){
    return mat2(_scale.x,0.0,
                0.0,_scale.y);
}

// vec2 scaled = scale(vec2(1. + sin(fract(trans) * PI) )) * uv;
// vec2 scaled = scale(vec2(1. + sin(fract(trans) * PI) * 0.5 +0.5 )) * uv;
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    float trans = smoothstep(0.,0.75,sin(uv.x + iTime));
    
    
    vec2 scaled = scale(vec2(1. + sin(fract(trans) * PI) )) * uv;
    uv.x = scaled.x;
    
    // Also transition Y the same way to get a really cool diagonal effect
    // float trans2 = smoothstep(0.,0.75,sin(uv.y + iTime));
	// vec2 scaled = scale(vec2(1. + sin(fract(trans) * PI) , 1. + sin(fract(trans2) * PI) )) * uv;
    // uv.y = scaled.y;
    // Time varying pixel color
    vec3 img1= vec3(texture(iChannel0,uv,0.));
    
    vec3 img2=  vec3(texture(iChannel1,uv,0.));
    vec3 col = img1 * trans + img2 * (1.-trans);

    
    // Output to screen
    fragColor = vec4(col,1.0);
}
