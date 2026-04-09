shader_type canvas_item;

uniform sampler2D cone_gradient : source_color;
uniform vec4 corner_radius;
uniform float rotation : hint_range(0.0, 1.0);
uniform vec2 size;

void fragment() {
	vec2 uv = UV - 0.5;

	float angle = atan(uv.y, uv.x);
	float gradient_x = fract((angle / PI) - rotation);
	vec4 sampled_color = texture(cone_gradient, vec2(gradient_x, 0.5));

	vec2 quadrant_mask = step(0.0, uv);
	float active_radius = mix(
		mix(corner_radius.x, corner_radius.y, quadrant_mask.x),
		mix(corner_radius.w, corner_radius.z, quadrant_mask.x),
		quadrant_mask.y
	);

	vec2 distance_from_center = abs(uv * size);
	vec2 inner_bounds = (size * 0.5) - active_radius;
	vec2 corner_offset = distance_from_center - inner_bounds;

	float distance_to_edge = length(max(corner_offset, 0.0)) - active_radius;
	COLOR = sampled_color * smoothstep(0.5, -0.5, distance_to_edge);
}