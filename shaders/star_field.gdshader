shader_type spatial;
render_mode blend_mix, depth_draw_never, cull_back;

uniform vec4 albedo : source_color;
uniform vec4 emission : source_color;
uniform float emission_energy : hint_range(0.0, 100.0, 0.0001);

uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D texture_emission : source_color, hint_default_black, filter_linear_mipmap, repeat_enable;

uniform vec3 background_color_tint : source_color = vec3(0.8, 0.8, 1.0);
uniform float background_dimming : hint_range(0.0, 1.0) = 0.15;
uniform float background_horizontal_shift : hint_range(0.0, 1.0) = 0.33;

void fragment() {
	vec4 base_albedo_texture = texture(texture_albedo, UV);
	vec3 base_emission_texture = texture(texture_emission, UV).rgb;

	vec2 uv2 = fract(UV + vec2(background_horizontal_shift, 0.0));
	vec4 shifted_albedo_texture = texture(texture_albedo, uv2);
	vec3 shifted_emission_texture = texture(texture_emission, uv2).rgb;

	shifted_albedo_texture.a *= background_dimming;
	shifted_emission_texture *= background_dimming * background_color_tint;

	vec4 combined_albedo = clamp(base_albedo_texture + shifted_albedo_texture, 0.0, 1.0);
	vec3 combined_emission = base_emission_texture + shifted_emission_texture;

	ALBEDO = albedo.rgb * combined_albedo.rgb;
	EMISSION = (emission.rgb + combined_emission) * emission_energy;
	ALPHA *= clamp(albedo.a * combined_albedo.a, 0.0, 1.0);
}