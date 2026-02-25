shader_type spatial;
render_mode blend_mix, depth_draw_never, cull_back, unshaded, ambient_light_disabled, fog_disabled, shadows_disabled;

uniform vec4 albedo : source_color;
uniform vec4 emission : source_color;
uniform float emission_energy : hint_range(0.0, 100.0, 0.0001);

uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;

uniform float dissolve_intensity : hint_range(0.0, 1.0);
uniform sampler2D dissolve_noise_texture : hint_default_black, filter_linear_mipmap, repeat_enable;
uniform float dissolve_scale;
uniform vec2 dissolve_speed;
uniform float dissolve_warp_intensity;

uniform float flow_speed;
uniform float flow_intensity;

void fragment() {
	float pole_fade = sin(UV.y * PI);
	vec2 flow_offset = vec2(
		sin(TIME * flow_speed + UV.y * 10.0) * flow_intensity * pole_fade, 
		0.0
	);
	
	vec2 distorted_uv = UV + flow_offset;
	vec4 base_albedo_texture = texture(texture_albedo, distorted_uv);

	vec2 warp_uv = (UV * dissolve_scale) + (TIME * dissolve_speed * 0.5);
	vec2 warp_noise = texture(dissolve_noise_texture, warp_uv).rg - 0.5;
	vec2 warp_direction = warp_noise * dissolve_warp_intensity * pole_fade;

	vec2 dissolve_uv = (UV * dissolve_scale) + (TIME * dissolve_speed) + warp_direction;
	float dissolve_noise = texture(dissolve_noise_texture, dissolve_uv).r;
	float dissolve_multiplier = mix(1.0, dissolve_noise, dissolve_intensity);

	ALBEDO = (albedo.rgb * base_albedo_texture.rgb) + ((emission.rgb + base_albedo_texture.rgb) * emission_energy);
	ALPHA *= clamp(albedo.a * base_albedo_texture.a * dissolve_multiplier, 0.0, 1.0);
}