shader_type canvas_item;
//uniform float BRIGHTNESS = 0.5;
//uniform float TIME_SPEED = 2.5;
uniform float cur_opacity = 0.0;

void fragment() {
	//float time_scaled = TIME * TIME_SPEED;
	//float red   = BRIGHTNESS + (sin(time_scaled) + 1.0) / 2.0;
	//float green = BRIGHTNESS + (sin(time_scaled + 2.0) + 1.0) / 2.0; // Phase shift for green
	//float blue  = BRIGHTNESS + (sin(time_scaled + 4.0) + 1.0) / 2.0; // Phase shift for blue
	COLOR.a = cur_opacity;
}
