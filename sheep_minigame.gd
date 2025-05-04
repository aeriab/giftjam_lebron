extends Node2D

@onready var shap = preload("res://shap.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.populate_sheep.connect(sheepBirth)
	# SPAWNS 10 SHAPS INITIALLY
	for i in range(0,10):
		var new_shap = shap.instantiate()
		new_shap.global_position.x = (randf_range($"Pen Markers/topleft".position.x,$"Pen Markers/topright".position.x))
		new_shap.global_position.y = (randf_range($"Pen Markers/topleft".position.y,$"Pen Markers/bottomleft".position.y))
		#print(new_shap.global_position)
		$ShapHolder.add_child(new_shap)

func sheepBirth(coordinates):
	var new_shap = shap.instantiate()
	
	# Place it one of 4 random locations around the initial shap
	if randi_range(0,1)==0:
		if randi_range(0,1)==1:
			new_shap.position.x = coordinates.x
			new_shap.position.y = coordinates.y - 10
		else:
			new_shap.position.x = coordinates.x
			new_shap.position.y = coordinates.y + 10
	else:
		if randi_range(0,1)==1:
			new_shap.position.x = coordinates.x - 10
			new_shap.position.y = coordinates.y
		else:
			new_shap.position.x = coordinates.x + 10
			new_shap.position.y = coordinates.y
	
	# Add to scene tree
	$ShapHolder.add_child(new_shap)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
