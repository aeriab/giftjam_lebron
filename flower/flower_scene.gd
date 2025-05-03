extends Node2D

@onready var interactive_color_rect = $interactive_color_rect

func glow():
	interactive_color_rect.glow()
