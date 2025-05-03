shader_type canvas_item;
render_mode blend_mix;
uniform float BRIGHTNESS = 0.5;
uniform float TIME_SPEED = 2.5;
void fragment() {
	float time_scaled = TIME * TIME_SPEED;
	float red   = BRIGHTNESS + (sin(time_scaled) + 1.0) / 2.0;
	float green = BRIGHTNESS + (sin(time_scaled + 2.0) + 1.0) / 2.0; // Phase shift for green
	float blue  = BRIGHTNESS + (sin(time_scaled + 4.0) + 1.0) / 2.0; // Phase shift for blue
	float current_alpha = 1.0; // Default to fully opaque
	COLOR = vec4(red, green, blue, current_alpha);

	// Optional: If you want to combine with a texture:
	 vec4 tex_color = texture(TEXTURE, UV); // Get texture color
	 COLOR = vec4(red, green, blue, tex_color.a) * tex_color; // Multiply color by texture, preserving texture alpha
}
