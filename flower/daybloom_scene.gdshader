shader_type canvas_item;
render_mode blend_mix;
uniform float cur_opacity : hint_range(0.0, 1.0);

void fragment() {
	//float time_scaled = TIME * TIME_SPEED;

	// Optional: If you want to combine with a texture:
	 vec4 tex_color = texture(TEXTURE, UV); // Get texture color
	 COLOR = vec4(1.0, 1.0, 1.0, cur_opacity) * tex_color; // Multiply color by texture, preserving texture alpha
}
