shader_type spatial;

render_mode unshaded, cull_disabled;

uniform sampler2D lightningNoise1;
uniform sampler2D lightningNoise2;
uniform vec3 tint : source_color;

// vertex uniforms
uniform float distortionVertex : hint_range(0.0, 0.3, 0.005) = 0.03;
uniform float speedVertex : hint_range(0.0, 1.0, 0.005) = 0.5;
uniform sampler2D noiseVertex;

void vertex()
{
	float noiseVal = (texture(noiseVertex, UV + (TIME * speedVertex)).r * 2.0) - 1.0; // Range: -1.0 to 1.0
	vec3 displacement = NORMAL * noiseVal * distortionVertex;
	VERTEX = VERTEX + displacement;
}

void fragment()
{
	float layer1 = texture(lightningNoise1, UV + (TIME * 0.1)).r * sin(TIME * 5.0);
	float layer2 = texture(lightningNoise2, UV - (TIME * 0.1)).r * cos(TIME * 5.0);
	ALBEDO = vec3(layer1 + layer2) * tint;
	ALPHA = layer1 + layer2;
}