extends CharacterBody2D

@onready var anim = $Sprite/AnimationPlayer

# Variables
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

func _physics_process(delta: float):
	move_and_slide()

func set_state(new_phase):
	# Stops any existing timers in case state was set through action not via time out
	$"State Durations/IDLE".stop()
	$"State Durations/WALK".stop()
	
	# Sets new state
	if new_phase == "IDLE":
		# set state and variables
		state = States.IDLE
		velocity = Vector2(0,0)
		
		# handle animations
		anim.play("Eating")
		
		# set duration of cycle and start timer
		$"State Durations/IDLE".wait_time = randi_range(1,2)*3
		$"State Durations/IDLE".start()
		
	elif new_phase == "WALK":
		# set state and variables
		state = States.WALK
		velocity = Vector2(randf_range(5,10)*[-1,1].pick_random(),randf_range(5,10)*[-1,1].pick_random())
		
		# handle animations
		anim.play("Walk")
		
		# set duration of cycle and start timer
		$"State Durations/WALK".wait_time = randi_range(1,3)*3
		$"State Durations/WALK".start()
		
	elif new_phase == "FLEE":
		# set state and variables
		state = States.FLEE
		velocity = Vector2(randf_range(10,20)*[-1,1].pick_random(),randf_range(10,20)*[-1,1].pick_random())
		
		# handle animations
		anim.play("RESET")
		anim.play("Run")
		
	elif new_phase == "DEATH":
		#set state and variables
		state = States.DEATH
		velocity = Vector2(0,0)
		
		# handle animations
		anim.stop()
		anim.play("Death")
		$GPUParticles2D.emitting = true
		#self.modulate = "red"
		
		# emit signal that sheep was killed 
		SignalManager.sheep_killed.emit()
		
		# start a timer before sheep despawns
		$"State Durations/DEATH".start()
	else: 
		print("ERROR: oopsie you made a typo lmao")
	print(state)

# SEES WHETHER OR NOT MOUSE CURSOR IS INSIDE OF THE SHEEP
func _on_mouse_entered():
	mouse_inside = true
	if state!=States.DEATH:
		set_state("FLEE")
func _on_mouse_exited():
	mouse_inside = false
	if state!=States.DEATH:
		set_state("WALK")

# SEES MOUSE CLICKS TO ALLOW DEATH
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and mouse_inside and state!=States.DEATH:
		set_state("DEATH")

func _on_idle_timeout():
	set_state("WALK")
func _on_walk_timeout():
	set_state("IDLE")
func _on_death_timeout():
	queue_free()

func _on_hitbox_body_entered(body: Node2D):
	if body.name=="LBound" or body.name=="RBound":
		velocity.x = -velocity.x
	elif body.name=="BBound" or body.name=="TBound":
		velocity.y = -velocity.y
