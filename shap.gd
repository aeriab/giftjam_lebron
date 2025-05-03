extends Node2D


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
	if mouse_inside==true:
		set_state("FLEE")
	#print(state)

func set_state(new_phase):
	if new_phase == "IDLE":
		state = States.IDLE
		$"State Durations/IDLE".start()
	elif new_phase == "WALK":
		state = States.WALK
		$"State Durations/WALK".start()
	elif new_phase == "FLEE":
		state = States.FLEE
		$"State Durations/FLEE".start()
	elif new_phase == "DEATH":
		state = States.DEATH
		$"State Durations/DEATH".start()
	else: 
		print("ERROR: oopsie you made a typo lmao")

# SEES WHETHER OR NOT MOUSE CURSOR IS INSIDE OF THE SHEEP
func _on_mouse_entered():
	mouse_inside = true
func _on_mouse_exited():
	mouse_inside = false

# SEES MOUSE CLICKS TO ALLOW DEATH
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and mouse_inside:
		set_state("DEATH")

func _on_idle_timeout():
	set_state("WALK")
func _on_walk_timeout():
	set_state("IDLE")
func _on_flee_timeout():
	set_state("WALK")
func _on_death_timeout():
	queue_free()
