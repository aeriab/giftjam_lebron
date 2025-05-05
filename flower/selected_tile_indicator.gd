extends Sprite2D

@export var MAX_OPACITY: float 
@export var MIN_OPACITY: float 
@export var FADE_IN_SPEED: float
@export var FADE_OUT_SPEED: float


@export var emitEvententer := "dflt"
@export var emitEventexit := "dflt"

var being_hovered: bool = false
var mouse_pressed: bool = false
var target_opacity: float = 0.0

var current_opacity: float = 0.0

func _ready():
	pass

func _process(delta):
	if being_hovered:
		target_opacity = MAX_OPACITY
		current_opacity = lerpf(current_opacity,target_opacity,FADE_IN_SPEED * delta)
	else:
		current_opacity = lerpf(current_opacity,target_opacity,FADE_OUT_SPEED * delta)
	
	
	
	modulate.a = current_opacity


func _on_interactive_color_rect_mouse_entered():
	SignalManager.mouseover.emit(emitEvententer)
	being_hovered = true


func _on_interactive_color_rect_mouse_exited():
	SignalManager.mouseover.emit(emitEventexit)
	target_opacity = MIN_OPACITY
	being_hovered = false


func _input(event: InputEvent) -> void:
	pass
