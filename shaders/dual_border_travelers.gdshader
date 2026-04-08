shader_type canvas_item;

uniform sampler2D traveler_cone_gradient : source_color;
uniform float traveler_speed;

void fragment() {
	float angle = atan(UV.y - 0.5, UV.x - 0.5);
	float angle_normalized = fract((angle / PI) + (TIME * traveler_speed * -1.0));

	COLOR = texture(traveler_cone_gradient, vec2(angle_normalized, 0.5));
}