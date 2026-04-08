shader_type canvas_item;

uniform sampler2D cone_gradient : source_color;
uniform float rotation : hint_range(0.0, 1.0);

void fragment() {
	float angle = atan(UV.y - 0.5, UV.x - 0.5);
	float angle_normalized = fract((angle / PI) + (rotation * -1.0));
	
	COLOR = texture(cone_gradient, vec2(angle_normalized, 0.5));
}