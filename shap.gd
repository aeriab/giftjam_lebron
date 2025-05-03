extends Node2D

@onready var anim = $Sprite/AnimationPlayer


var mouse_inside : bool

# STATE STUFF
enum States {IDLE, WALK, FLEE, DEATH}
var state: States

func _ready():
	# SETS SHEEP TO SPAWN IN WITH 
	if randi_range(0,1)==0:
		set_state("IDLE")
	else:
		set_state("WALK")

func _process(delta: float):
	pass

func set_state(new_phase):
	# Stops any existing timers in case state was set through action not via time out
	$"State Durations/IDLE".stop()
	$"State Durations/WALK".stop()
	
	# Sets new state
	if new_phase == "IDLE":
		state = States.IDLE
		anim.play("Eating")
		$"State Durations/IDLE".wait_time = randi_range(1,2)*3
		$"State Durations/IDLE".start()
	elif new_phase == "WALK":
		state = States.WALK
		anim.play("Walk")
		$"State Durations/WALK".wait_time = randi_range(1,3)*3
		$"State Durations/WALK".start()
	elif new_phase == "FLEE":
		state = States.FLEE
		anim.play("RESET")
		anim.play("Run")
	elif new_phase == "DEATH":
		state = States.DEATH
		anim.play("RESET")
		#self.modulate = "red"
		SignalManager.sheep_killed.emit()
		mouse_inside = false # don't return to flee after death
		$GPUParticles2D.emitting = true
		$"State Durations/DEATH".start()
	else: 
		print("ERROR: oopsie you made a typo lmao")
	print(state)

# SEES WHETHER OR NOT MOUSE CURSOR IS INSIDE OF THE SHEEP
func _on_mouse_entered():
	mouse_inside = true
	set_state("FLEE")
func _on_mouse_exited():
	mouse_inside = false
	set_state("WALK")

# SEES MOUSE CLICKS TO ALLOW DEATH
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and mouse_inside:
		set_state("DEATH")

func _on_idle_timeout():
	set_state("WALK")
func _on_walk_timeout():
	set_state("IDLE")
func _on_death_timeout():
	queue_free()
