extends Camera2D


@export var lerpspeed: float = 10
@onready var cameralerptarget: String = "EvilPlants"	
@onready var evil: Node2D = $"../EvilPlants"
@onready var murder: Node2D = $"../Murder"
var cameraTargetDict
# Called when the node enters the scene tree for the first time.


func _ready() -> void:
	#sets list of targets for camera to lerp to 
	cameraTargetDict = {
	"EvilPlants" = evil.position,
	"Murder" = murder.position
	}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#lerp camera to target
	global_position = global_position.lerp(cameraTargetDict[cameralerptarget], lerpspeed * delta)
	pass


#functions to swap out the targets
func _on_arrow_to_murder_pressed() -> void:
	cameralerptarget = "Murder"
	pass
func _on_arrow_to_evil_plants_pressed() -> void:
	cameralerptarget = "EvilPlants"
	pass # Replace with function body.
