extends Node

var blood: int = 0
var seed: int = 3

var evil_mode: bool = false

func color_distance(color1: Color, color2: Color) -> float:
	# Calculate the Euclidean distance between the two colors in RGB space.
	var r_diff = color1.r - color2.r
	var g_diff = color1.g - color2.g
	var b_diff = color1.b - color2.b
	return sqrt(r_diff * r_diff + g_diff * g_diff + b_diff * b_diff)
