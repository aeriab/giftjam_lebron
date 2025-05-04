extends Node2D

@onready var shap = preload("res://shap.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0,9):
		var new_shap = shap.instantiate()
		$ShapHolder.add_child(new_shap)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
