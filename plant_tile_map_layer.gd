extends TileMapLayer

# Preload the scene you want to instantiate. Preloading is efficient.
@onready var flower_instance: PackedScene = preload("res://flower/flower_scene.tscn")

var flower_instances: Dictionary = {}

func _ready():
	flower_instances.clear()
	for x in range(0,7):
		for y in range(0,7):
			var tile_coords = Vector2i(x, y)
			spawn_scene_at_tile(tile_coords)

# Function to handle the instantiation
func spawn_scene_at_tile(tile_coords: Vector2i):
	# Optional: You could even check if the tile_coords are valid for your map layer
	var local_world_position: Vector2 = map_to_local(tile_coords)
	var instance = flower_instance.instantiate()
	instance.position = local_world_position
	add_child(instance)
	
	flower_instances[tile_coords] = instance

func _process(delta):
	pass
	#var specific_coords = Vector2i(3, 4)
	#if flower_instances.has(specific_coords):
		#flower_instances[specific_coords].glow()
