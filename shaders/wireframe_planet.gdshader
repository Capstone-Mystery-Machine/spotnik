shader_type spatial;
render_mode blend_add, depth_draw_never, cull_back, unshaded;

uniform vec3 grid_line_color : source_color;
uniform float grid_line_density : hint_range(1.0, 100.0);
uniform vec3 ping_glow_color : source_color;
uniform float ping_max_radius : hint_range(0.0, 2.0);
uniform float ping_width : hint_range(0.001, 0.5);
uniform vec3 planet_color : source_color;
uniform float intersection_blend : hint_range(0.0, 1.0);

varying vec3 local_unit_position;
uniform vec4 ping_data;

void vertex() {
	local_unit_position = normalize(VERTEX);
}

void fragment() {
	vec2 grid_uv_step = step(0.98, fract(UV * grid_line_density));
	float grid_line_mask = max(grid_uv_step.x, grid_uv_step.y);

	float intersection_mask = grid_uv_step.x * grid_uv_step.y;
	float grid_line_intensity = grid_line_mask * 0.5 + (intersection_mask * 0.5);

	float ping_ring_intensity = 0.0;
	vec3 ping_center_direction = ping_data.xyz;
	float ping_progress = ping_data.w;

	if (ping_progress > 0.0) {
		float surface_alignment = dot(local_unit_position, ping_center_direction);
		float current_ring_threshold = 1.0 - (ping_progress * ping_max_radius);

		float ring_mask = smoothstep(
			ping_width,
			0.0,
			abs(surface_alignment - current_ring_threshold)
		);

		float opacity_falloff = 1.0 - ping_progress;
		ping_ring_intensity = ring_mask * opacity_falloff;
	}

	vec3 active_grid_color = mix(grid_line_color, ping_glow_color, intersection_mask * intersection_blend);
	vec3 grid_layer = active_grid_color * grid_line_intensity;
	
	float line_traversal_glow = ping_ring_intensity * grid_line_mask;
	vec3 ping_layer = ping_glow_color * line_traversal_glow;

	ALBEDO = planet_color + grid_layer + ping_layer;
}