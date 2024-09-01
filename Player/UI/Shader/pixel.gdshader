shader_type canvas_item;

// texture to be used as "pixels"
uniform sampler2D tiledtexture: repeat_enable, filter_linear_mipmap;
// how much of the tiled texture to show (1 recommended) 
uniform float opacity : hint_range(0.0, 1.0);
// size of pixelation effect
uniform float pixel_size = 0.01;
// whether to greyscale the image or not before applying tiletexture
uniform bool greyscale = true;
// whether to greyscale the image or not before applying tiletexture
uniform float contrast;
// grab the camera's view
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap; 
// the overriding color of the tiled texture, white by default
uniform vec3 pixel_colors : source_color;
// the overriding color of the background, black by default
uniform vec3 background_color : source_color;

// Convert to Greyscale using luminosity method if aplicable
vec4 to_grayscale(vec4 color) {
	float luminance = 0.21 * color.r + 0.72 * color.g + 0.07 * color.b;
	return vec4(luminance, luminance, luminance, color.a);
}

// Adjust contrast of the greyscale image
vec4 adjust_contrast(vec4 color) {
	color.rgb = (color.rgb - 0.5) * max(contrast, 0.0) + 0.5;
	return color;
}

// Applies the tiled texture on top of the original texture imitating 
// photoshop's HARD MIX blending mode
vec4 hard_mix(vec4 color1, vec4 color2) {
    vec4 result; // The resulting texture
    for (int i = 0; i < 4; i++) { // loop through the four channels
        float value = color1[i] + color2[i]; // add the values of the two colors
        if (value >= 1.0) { // if the value is greater than or equal to 1.0, set it to 1.0
            result[i] = 1.0;
        } else { // otherwise, set it to 0.0
            result[i] = 0.0;
        }
    }
    return result; // return the result color
}


// main fragment func

void fragment() {
	
	vec2 uv = SCREEN_UV;
	vec2 uv2 = SCREEN_UV;
	
	// apply pixelation on the base texture
	uv = floor(uv / pixel_size) * pixel_size;
	vec4 color1 = texture(screen_texture, uv);
	
	// apply greyscale adjustments if applicable
	if (greyscale) {
		color1 = to_grayscale(color1);
		color1 = adjust_contrast(color1);
	}
	
	// apply hard mix blending
	vec4 color2 = texture(tiledtexture, uv2 / pixel_size);
	vec4 final_result = mix(color1, hard_mix(color1, color2), opacity);
	
	// replace default white with desired color
	if (final_result == vec4(1.0, 1.0, 1.0, 1.0)) {
		final_result = vec4(pixel_colors, 1.0);
		// replace default black background with desired color
	} else {
		if (final_result == vec4(0.0, 0.0, 0.0, 1.0)) {
			final_result = vec4(background_color, 1.0);
		}
	}
	
	// assign final texture
	COLOR = final_result;
}
