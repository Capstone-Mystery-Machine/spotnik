shader_type spatial;
render_mode blend_mix, depth_draw_never, cull_back;

uniform vec4 albedo : source_color;
uniform vec4 emission : source_color;
uniform float emission_energy : hint_range(0.0, 100.0, 0.0001);

uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D texture_emission : source_color, hint_default_black, filter_linear_mipmap, repeat_enable;

void fragment() {
	vec4 albedo_texture = texture(texture_albedo, UV);
	vec3 emission_texture = texture(texture_emission, UV).rgb;

	ALBEDO = albedo.rgb * albedo_texture.rgb;
	EMISSION = (emission.rgb + emission_texture) * emission_energy;
	ALPHA *= albedo.a * albedo_texture.a;
}