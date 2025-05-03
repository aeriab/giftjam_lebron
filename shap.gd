extends Node2D

var mouse_inside : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# SEES WHETHER OR NOT MOUSE CURSOR IS INSIDE OF THE SHEEP
func _on_mouse_entered():
	mouse_inside = true
func _on_mouse_exited():
	mouse_inside = false

# SEES MOUSE CLICKS TO ALLOW DEATH
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and mouse_inside:
			print("I am kill")
