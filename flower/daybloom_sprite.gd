extends Sprite2D

@export var MAX_OPACITY: float
@export var MIN_OPACITY: float
@export var FADE_IN_SPEED: float
@export var FADE_OUT_SPEED: float

var planted_tile: bool = false
var being_hovered: bool = false
var target_opacity: float = 0.0

var current_opacity: float = 0.0

func _ready():
	if not material is ShaderMaterial:
		print("Material is missing or not a ShaderMaterial!")
	elif not material.has_meta("cur_opacity"):
		print("ShaderMaterial does not have the 'cur_opacity' parameter!")

var time_ellapsed: float = 0.0

func _process(delta):
	if !planted_tile:
		if being_hovered:
			current_opacity = lerpf(current_opacity,target_opacity,FADE_IN_SPEED * delta)
		else:
			current_opacity = lerpf(current_opacity,target_opacity,FADE_OUT_SPEED * delta)
	else:
		current_opacity = lerpf(current_opacity,target_opacity,FADE_IN_SPEED * delta)
	
	modulate.a = current_opacity


func _on_interactive_color_rect_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if !planted_tile:
			target_opacity = MAX_OPACITY + randf_range(0.1, 0.2)
			planted_tile = true
			SignalManager.blood_watered.emit()
	
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		#if planted_tile:
			#target_opacity = 0.0
			#planted_tile = false
			#target_color = COLOR_BLANK


func _on_interactive_color_rect_mouse_entered():
	if !planted_tile:
		target_opacity = MAX_OPACITY
	being_hovered = true


func _on_interactive_color_rect_mouse_exited():
	if !planted_tile:
		target_opacity = MIN_OPACITY
	being_hovered = false
