extends ColorRect

@export var MAX_OPACITY: float
@export var MIN_OPACITY: float
@export var FADE_IN_SPEED: float
@export var FADE_OUT_SPEED: float

@export var COLOR_PLANTED: Color
@export var COLOR_BLANK: Color

var planted_tile: bool = false
var being_hovered: bool = false
var target_opacity: float = 0.0
@onready var target_color: Color = COLOR_BLANK

var current_opacity: float = 0.0
@onready var current_color: Color = COLOR_BLANK

func _process(delta):
	if !planted_tile:
		if being_hovered:
			current_opacity = lerpf(current_opacity,target_opacity,FADE_IN_SPEED * delta)
		else:
			current_opacity = lerpf(current_opacity,target_opacity,FADE_OUT_SPEED * delta)
	else:
		current_opacity = lerpf(current_opacity,target_opacity,FADE_IN_SPEED * delta)
	
	current_color = current_color.lerp(target_color, FADE_IN_SPEED * delta)
	
	color = current_color
	color.a = current_opacity

func _on_mouse_entered():
	if !planted_tile:
		target_opacity = MAX_OPACITY
	being_hovered = true


func _on_mouse_exited():
	if !planted_tile:
		target_opacity = MIN_OPACITY
	being_hovered = false


func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if !planted_tile:
			target_opacity = MAX_OPACITY + randf_range(0.1, 0.2)
			planted_tile = true
			target_color = COLOR_PLANTED
			SignalManager.blood_watered.emit()
	
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		#if planted_tile:
			#target_opacity = 0.0
			#planted_tile = false
			#target_color = COLOR_BLANK
