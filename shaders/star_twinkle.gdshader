shader_type spatial;
render_mode blend_mix, depth_draw_never, unshaded;

uniform sampler2D albedo_texture : source_color;
uniform sampler2D emission_texture : source_color;
uniform float twinkle_speed = 2.0;
uniform float twinkle_amount = 0.5;
uniform float base_alpha = 1.0;
uniform float emission_energy = 1.0;

void fragment() {
	vec4 albedo_tex = texture(albedo_texture, UV);
	vec4 emission_tex = texture(emission_texture, UV);

	float twinkle = sin(TIME * twinkle_speed + (UV.x * 50.0) + (UV.y * 70.0));
	
	// Convert sine wave from [-1, 1] to [0, 1]
	twinkle = (twinkle + 1.0) / 2.0;
	
	float glow_multiplier = mix(1.0 - twinkle_amount, 1.0 + twinkle_amount, twinkle);

	ALBEDO = albedo_tex.rgb;
	ALPHA = albedo_tex.a * base_alpha;
	EMISSION = emission_tex.rgb * emission_energy * glow_multiplier;
}