shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float inverse_gamma;

void fragment() {
	vec4 screen_color = texture(screen_texture, SCREEN_UV);

	COLOR.rgb = pow(screen_color.rgb, vec3(inverse_gamma));
}