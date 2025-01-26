#version 300 es

precision highp float;
precision highp sampler2D;

in vec2 uv;
out vec4 out_color;

uniform vec2 u_resolution;
uniform float u_time;
uniform vec4 u_mouse;
uniform sampler2D u_textures[16];

float uImageAspect = 1.;
vec3 uOverlayColor = vec3(0.,0.,0.);
vec3 uOverlayColorWhite = vec3(1.,1.,1.);
float uRotation = 0.;
float uSegments = 20.;
float uOverlayOpacity = 0.;
float amplitude = 0.03; // The amplitude of the sine wave
float PI = 3.14159265;

float wave_distortion = 0.5;
float glass_thickness = 1.0;
float refraction = 0.5;

void main() {
    // Movement
    float uMotionValue = u_time/1.2;
    
    float canvasAspect = u_resolution.x / u_resolution.y;
    float rotationRadians = uRotation * (3.14159265 / 180.0); // Convert rotation to radians

    // Adjust the UV coordinates for aspect ratio
    vec2 scaledUV = uv;
    if (uImageAspect > canvasAspect) {
        float scale = canvasAspect / uImageAspect;
        scaledUV.x = (uv.x - 0.5) * scale + 0.5;
    } else {
        float scale = uImageAspect / canvasAspect;
        scaledUV.y = (uv.y - 0.5) * scale + 0.5;
    }

    // Moving UV
    scaledUV.x += uMotionValue / 10.;

    // Rotate the texture to align it with the warping axis
    scaledUV = vec2(
        cos(rotationRadians) * (scaledUV.x - 0.5) - sin(rotationRadians) * (scaledUV.y - 0.5) + 0.5,
        sin(rotationRadians) * (scaledUV.x - 0.5) + cos(rotationRadians) * (scaledUV.y - 0.5) + 0.5
    );

    // Apply the warping effect along the aligned axis (now horizontal after rotation)
    // Moving slice in the opposite direction of UV
    float sliceProgress = fract(scaledUV.x * uSegments - uMotionValue * 2.);
    
    scaledUV.x += amplitude * sin(sliceProgress * PI * wave_distortion) * (glass_thickness - refraction * abs(sliceProgress - refraction));


    // Rotate the UVs back to the original orientation
    scaledUV = vec2(
        cos(-rotationRadians) * (scaledUV.x - 0.5) - sin(-rotationRadians) * (scaledUV.y - 0.5) + 0.5,
        sin(-rotationRadians) * (scaledUV.x - 0.5) + cos(-rotationRadians) * (scaledUV.y - 0.5) + 0.5
    );

    // Tile texture on edges using the final UVs
    // vec2 tileIndex = floor(finalUV);
    // vec2 oddTile = mod(tileIndex, 2.0);
    // vec2 mirroredUV = mix(fract(finalUV), 1.0 - fract(finalUV), oddTile);


    vec4 color = texture(u_textures[0], scaledUV);


    if (uOverlayOpacity > 0.0) {
        // Apply overlays with the specified opacity
        float blackOverlayAlpha = 0.05 * (1.0 - abs(sin(sliceProgress * 3.14159265 * 0.5 + 1.57))) * (uOverlayOpacity / 100.0);
        color.rgb *= (1.0 - blackOverlayAlpha);

        float whiteOverlayAlpha = 0.15 * (1.0 - abs(sin(sliceProgress * 3.14159265 * 0.7 - 0.7))) * (uOverlayOpacity / 100.0);
        color.rgb = mix(color.rgb, uOverlayColorWhite, whiteOverlayAlpha);
    }

    out_color = color;
}
