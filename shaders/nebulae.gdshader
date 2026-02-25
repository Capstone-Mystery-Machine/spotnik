shader_type spatial;
render_mode blend_mix, depth_draw_never, cull_back, unshaded, ambient_light_disabled, fog_disabled, shadows_disabled;

uniform vec4 albedo : source_color;
uniform vec4 emission : source_color;
uniform float emission_energy : hint_range(0.0, 100.0, 0.0001);

uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D texture_emission : source_color, hint_default_black, filter_linear_mipmap, repeat_enable;

uniform sampler3D carving_noise_texture : filter_linear, repeat_enable;
uniform float carving_speed = 0.08;
uniform float carving_scale = 2.5; 
uniform float carving_intensity : hint_range(0.0, 1.0) = 0.65;

uniform float flow_speed = 0.02;
uniform float flow_intensity = 0.04;

varying vec3 local_position;

void vertex() {
	local_position = VERTEX;
}

void fragment() {
	float pole_fade = sin(UV.y * PI);

	vec2 flow_offset = vec2(
		sin(TIME * flow_speed + UV.y * 10.0) * flow_intensity * pole_fade, 
		0.0
	);
	
	vec2 distorted_uv = UV + flow_offset;

	vec4 base_albedo_texture = texture(texture_albedo, distorted_uv);
	vec3 base_emission_texture = texture(texture_emission, distorted_uv).rgb;

	vec3 noise_uv = (local_position * carving_scale) + vec3(TIME * carving_speed);
	float carving_noise = texture(carving_noise_texture, noise_uv).r;
	float carving_multiplier = mix(1.0 - carving_intensity, 1.0, carving_noise);

	ALBEDO = (albedo.rgb * base_albedo_texture.rgb) + ((emission.rgb + base_emission_texture) * emission_energy);
	ALPHA *= clamp(albedo.a * base_albedo_texture.a * carving_multiplier, 0.0, 1.0);
}