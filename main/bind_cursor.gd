extends Marker2D


@onready var sprite : Sprite2D = $CustomCursor
@onready var anim = $AnimationPlayer
@onready var slashSFX = $slash

@onready var pointer = preload("res://assets/pointer.png")
@onready var watercan = preload("res://assets/wateringCan.png")
@onready var dagger = preload("res://assets/dagger.png")

var mouse = "dflt"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position =  get_global_mouse_position()
	current_mouse()
	match mouse:
		"dflt":
			sprite.texture = null
			pass
			#anim.play("pointer")
			#sprite.texture = pointer
			#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		"water":
			#position += 
			sprite.texture = watercan
			print("HIDE")
			#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		"murder":
			sprite.texture = dagger
			await anim.animation_finished
			anim.play("dagger")


func _input(event):
	current_mouse()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			match mouse:
				"dflt":
					pass
				"water":
					print("WATERING")
					anim.play("water")
				"murder":
					slashSFX.play()
					anim.play("kill")
		if event.is_released():
			match mouse:
				"water":
					anim.play("RESET")
					pass


func current_mouse():
	if !Global.evil_mode:
		if Global.in_plant_scene:
			mouse = "plant"
		else:
			mouse = "feed"
	else:
		if Global.in_plant_scene:
			mouse = "water"
		else:
			mouse = "murder"


func _on_arrow_to_shap_pressed() -> void:
	Global.in_plant_scene = false
	anim.play("dagger")


func _on_arrow_to_plants_pressed() -> void:
	Global.in_plant_scene = true
