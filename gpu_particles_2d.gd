extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.cameraPanFinished.connect(onCampanF)
	SignalManager.cameraPanStart.connect(onCampanS)
	process_material.collision_mode=1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func onCampanF():
	process_material.collision_mode=1
func onCampanS():
	process_material.collision_mode=0
	#print("collision ignored")
	
