extends Node2D

@onready var shap = preload("res://shap.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0,10):
		var new_shap = shap.instantiate()
		new_shap.global_position.x = (randf_range($"Pen Markers/topleft".position.x,$"Pen Markers/topright".position.x))
		new_shap.global_position.y = (randf_range($"Pen Markers/topleft".position.y,$"Pen Markers/bottomleft".position.y))
		#print(new_shap.global_position)
		$ShapHolder.add_child(new_shap)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
