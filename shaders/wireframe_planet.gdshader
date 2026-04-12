shader_type spatial;
render_mode blend_mix, depth_draw_always, cull_back, unshaded;

group_uniforms Colors;
uniform vec3 planet_color : source_color;
uniform vec3 grid_color : source_color;
uniform float intersection_color_blend : hint_range(0.0, 1.0);
uniform vec3 glow_color : source_color;

group_uniforms Grid;
uniform float grid_density : hint_range(1.0, 100.0);
uniform float intersection_cross_length : hint_range(0.01, 0.5);
uniform float intersection_cross_thickness : hint_range(0.001, 0.1);

group_uniforms CometShape;
uniform float comet_radius : hint_range(0.001, 2.0);
uniform float comet_length : hint_range(0.0, 20.0);
uniform float comet_pinch : hint_range(0.0, 10.0);
uniform float glow_falloff : hint_range(0.1, 10.0);

group_uniforms Internal;
varying vec3 local_unit_position;
uniform vec3 surface_direction;
uniform vec3 surface_velocity;

void vertex() {
	local_unit_position = normalize(VERTEX);
}

void fragment() {
	vec2 grid_uv = fract(UV * grid_density);
	vec2 distance_to_edge = min(grid_uv, 1.0 - grid_uv);

	vec2 cross_thickness = step(distance_to_edge, vec2(intersection_cross_thickness));
	vec2 cross_length = step(distance_to_edge, vec2(intersection_cross_length));
	float intersections = max(
		cross_thickness.y * cross_length.x,
		cross_thickness.x * cross_length.y
	);

	vec3 tangent_velocity = normalize(
		surface_velocity - surface_direction
		* dot(surface_velocity, surface_direction) + vec3(1e-5)
	);
	vec3 side_direction = normalize(cross(surface_direction, tangent_velocity));
	
	float trail_axis = dot(local_unit_position, tangent_velocity);
	float side_axis = dot(local_unit_position, side_direction);
	float alignment = dot(local_unit_position, surface_direction);

	float safe_radius = max(comet_radius, 0.0001);
	
	float normalized_trail = max(-trail_axis, 0.0) / safe_radius;
	float normalized_side = abs(side_axis) / safe_radius;

	float pinch_factor = normalized_trail * comet_pinch;
	float taper = 1.0 + (pinch_factor * pinch_factor); 
	float stretch = 1.0 + (normalized_trail * comet_length);
	float side_compression = 1.0 + (normalized_side * comet_pinch * taper);
	
	float distance = (1.0 - alignment) * side_compression / stretch;
	
	float is_active = step(0.01, dot(surface_direction, surface_direction)); 
	float core_ratio = clamp(1.0 - (distance / safe_radius), 0.0, 1.0) * is_active;
	float mask_base = smoothstep(0.0, 0.5, core_ratio);

	vec2 thickness = mix(vec2(0.04), vec2(0.005), distance_to_edge * 2.0);
	vec2 organic_shape = smoothstep(thickness.yx, thickness.yx - vec2(0.005), distance_to_edge);
	
	float connection_reach = mask_base * 0.7; 
	vec2 bloom = smoothstep(vec2(connection_reach), vec2(connection_reach - 0.1), distance_to_edge);
	float organic_lines = max(organic_shape.x * bloom.y, organic_shape.y * bloom.x);

	float intensity_falloff = pow(core_ratio, glow_falloff); 
	float pulse = 1.0 + (sin(TIME * 15.0) * 0.5 + 0.5);

	vec3 base_grid_color = mix(grid_color, glow_color, intersections * intersection_color_blend);
	float grid_alpha = clamp((intersections * 0.6) + (organic_lines * 0.4), 0.0, 1.0);
	vec3 grid_layer = base_grid_color * grid_alpha;

	float glow_mask = clamp(
		((intersections * pulse) + organic_lines) * intensity_falloff,
		0.0, 1.0
	);

	ALBEDO = mix(planet_color + grid_layer, glow_color, glow_mask);
}