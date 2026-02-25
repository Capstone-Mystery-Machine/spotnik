shader_type spatial;
render_mode blend_add, depth_draw_never, cull_back, unshaded, ambient_light_disabled, fog_disabled, shadows_disabled;

uniform vec4 albedo : source_color;
uniform vec4 emission : source_color;
uniform float emission_energy : hint_range(0.0, 100.0, 0.0001);

uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;

uniform sampler2D color_palette : source_color;

uniform float twinkle_frequency;
uniform float twinkle_intensity;
uniform float twinkle_speed;

void fragment() {
	vec4 albedo_texture = texture(texture_albedo, UV);

	float color_zone = (sin(UV.x * 20.0) + cos(UV.y * 15.0) + 2.0) / 4.0;
	vec3 star_tint = texture(color_palette, vec2(color_zone, 0.5)).rgb;

	float twinkle = sin(TIME * twinkle_speed + (UV.x * twinkle_frequency) + (UV.y * twinkle_frequency * 1.3));
	twinkle = (twinkle + 1.0) / 2.0;

	float glow_multiplier = mix(1.0 - twinkle_intensity, 1.0 + twinkle_intensity, twinkle);

	ALBEDO = (emission.rgb + albedo_texture.rgb) * star_tint * emission_energy * glow_multiplier;
	ALPHA *= albedo.a * albedo_texture.a;
}