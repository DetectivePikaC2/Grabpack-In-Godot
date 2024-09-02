shader_type canvas_item;

uniform float radius;
uniform bool weighted = true;	// Determines whether to use normal or weighted averages

void fragment() {
	COLOR.rgb = mix(vec3((COLOR.r + COLOR.g + COLOR.b) / 3.0),  vec3(0.299 * COLOR.r + 0.587 * COLOR.g + 0.114 * COLOR.b), float(weighted));
	vec2 center = vec2(0.5, 0.5);
	vec2 local_coords = (UV - center);
	float distance = length(local_coords);
	
	float circleRadius = radius / float(2);
	
	if (distance > circleRadius) {
		discard;
	}
}
