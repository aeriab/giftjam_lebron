extends CharacterBody2D

@onready var anim = $Sprite/AnimationPlayer
@onready var hitSFX = $Hit

# Variables
var mouse_inside : bool
var adapt_vector : Vector2

# STATE STUFF
enum States {IDLE, WALK, FLEE, POPULATE, DEATH}
var state: States

func _ready():
	# SETS SHEEP TO SPAWN IN WITH 
	if randi_range(0,1)==0:
		set_state("IDLE")
	else:
		set_state("WALK")

func _process(delta:float):
	if velocity.x < 0:
		$Sprite.flip_h=true
	elif velocity.x >0:
		$Sprite.flip_h=false

func _physics_process(delta: float):
	if state==States.FLEE:
		adapt_vector = (global_position - get_global_mouse_position())/abs(global_position - get_global_mouse_position())
		velocity = Vector2(randf_range(15,25)*adapt_vector.x,randf_range(15,25)*adapt_vector.y)
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
		# velocity is handled in physics processes
		state = States.FLEE
		
		# handle animations
		anim.play("RESET")
		anim.play("Run")
	
	elif new_phase == "POPULATE":
		# set state and variables
		state = States.POPULATE
		velocity = Vector2(0,0)
		
		# reduce seeds
		SignalManager.seed_used.emit()
		
		# handle animations
		anim.play("RESET")
		
		# wait
		await get_tree().create_timer(1).timeout
		
		# tell minigame to populate sheep
		SignalManager.populate_sheep.emit(position)
		
		# wait
		await get_tree().create_timer(2).timeout
		
		set_state("WALK")
		
	elif new_phase == "DEATH":
		hitSFX.play()
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

# SEES WHETHER OR NOT MOUSE CURSOR IS INSIDE OF THE SHEEP
func _on_mouse_entered():
	mouse_inside = true
	
func _on_mouse_exited():
	mouse_inside = false

# SEES MOUSE CLICKS TO ALLOW DEATH
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and mouse_inside:
			if state!=States.DEATH:
				set_state("DEATH")
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT and mouse_inside:
			if state!=States.DEATH and state!=States.POPULATE and Global.seed > 0:
				set_state("POPULATE")

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
	elif body.name.contains("@CharacterBody2D"):
		velocity = -velocity


func _on_hitbox_area_entered(area: Area2D):
	if area.name=="scarefield" and state!=States.DEATH and state!=States.POPULATE:
		if Global.evil_mode:
			set_state("FLEE")

func _on_hitbox_area_exited(area: Area2D):
	if area.name=="scarefield" and state!=States.DEATH and state!=States.POPULATE:
		set_state("WALK")
