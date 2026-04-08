shader_type canvas_item;

uniform float traveler_cone_sharpness;
uniform vec4 traveler_color_left: source_color;
uniform vec4 traveler_color_right: source_color;
uniform float traveler_speed;

void fragment() {
	float angle = atan(UV.y - 0.5, UV.x - 0.5) + (TIME * traveler_speed * -1.0);

	float cos_a = cos(angle);
	float beam_mask = pow(abs(cos_a), traveler_cone_sharpness);

	float side = sin(angle) * sign(cos_a);
	float color_mix = side * 0.5 + 0.5;

	vec4 mixed_color = mix(traveler_color_left, traveler_color_right, color_mix);
	
	COLOR = vec4(mixed_color.rgb, mixed_color.a * beam_mask);
}