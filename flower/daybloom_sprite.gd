extends Sprite2D

@onready var teen_lotus = $"../TeenLotus"

@onready var cpu_particles_2d = $"../CPUParticles2D"
@onready var digSFX = $"../digSFX"

@export var MAX_OPACITY: float
@export var MIN_OPACITY: float
@export var FADE_IN_SPEED: float
@export var FADE_OUT_SPEED: float

@export var NORMAL_COLOR: Color
@export var NO_SEEDS_COLOR: Color

var planted_tile: bool = false
var being_hovered: bool = false
var target_opacity: float = 0.0

var current_opacity: float = 0.0

var time_ellapsed: float = 0.0

var plant_time_ellapsed: float = 0.0
var plant_stage_index: int = 0
var next_stage_times

var ready_to_harvest: bool = false

@onready var target_color: Color = NORMAL_COLOR
@onready var current_color: Color = NORMAL_COLOR
@onready var blood: Sprite2D = $"../blood"

@export var GROWTH_MIN: float
@export var GROWTH_MAX: float

@onready var min_grow_time: float = GROWTH_MIN
@onready var max_grow_time: float = GROWTH_MAX


@export var BLOOD_GROWTH_MIN: float
@export var BLOOD_GROWTH_MAX: float

var lotus_time: bool = false

func _ready():
	next_stage_times = []
	for i in range(7):
		next_stage_times.append(randf_range(min_grow_time * 5, max_grow_time * 5))

func _process(delta):
	#print("blood opac: " + str(blood.current_opacity))
	if blood.current_opacity >= 0.1:
		plant_time_ellapsed += delta * (GROWTH_MAX / BLOOD_GROWTH_MAX)
	else:
		plant_time_ellapsed += delta
	
	if !planted_tile:
		if being_hovered:
			current_opacity = lerpf(current_opacity,target_opacity,FADE_IN_SPEED * delta)
		else:
			current_opacity = lerpf(current_opacity,target_opacity,FADE_OUT_SPEED * delta)
	else:
		Global.any_seeds_planted = true
		current_opacity = lerpf(current_opacity,target_opacity,FADE_IN_SPEED * delta)
		
		plant_time_ellapsed += delta
		if plant_stage_index >= next_stage_times.size():
			ready_to_harvest = true
			Global.any_seeds_ready = true
			return
		if plant_time_ellapsed > next_stage_times[plant_stage_index]:
			plant_stage_index += 1
			plant_time_ellapsed = 0
			frame += 1
			if lotus_time:
				teen_lotus.frame += 1
	
	current_color = current_color.lerp(target_color, FADE_IN_SPEED * delta)
	
	if Global.color_distance(current_color, target_color) < 0.1:
		target_color = NORMAL_COLOR
	
	modulate = current_color
	
	modulate.a = current_opacity


func _on_interactive_color_rect_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		
		if !Global.evil_mode:
			if !planted_tile:
				if Global.seed > 0:
					plant_seed()
				else:
					target_color = NO_SEEDS_COLOR
					
			
			if ready_to_harvest:
				harvest_plant()
		

func plant_seed():
	if Global.seed < 20:
		lotus_time = false
		frame = 6
		teen_lotus.frame = 0
		visible = true
		teen_lotus.visible = false
		next_stage_times = []
		for i in range(7):
			next_stage_times.append(randf_range(min_grow_time * 5, max_grow_time * 5))
		Global.any_seeds_planted = true
		digSFX.play()
		target_opacity = MAX_OPACITY + randf_range(0.1, 0.2)
		planted_tile = true
		SignalManager.seed_used.emit(1)
	else:
		lotus_time = true
		frame = 6
		teen_lotus.frame = 0
		visible = false
		teen_lotus.visible = true
		next_stage_times = []
		for i in range(4):
			next_stage_times.append(randf_range(min_grow_time * 25, max_grow_time * 25))
		print(next_stage_times)
		Global.any_seeds_planted = true
		digSFX.play()
		target_opacity = MAX_OPACITY + randf_range(0.1, 0.2)
		planted_tile = true
		SignalManager.seed_used.emit(20)

func harvest_plant():
	SignalManager.play_harvest_sound.emit()
	teen_lotus.visible = false
	Global.any_seeds_planted = false
	cpu_particles_2d.emitting = true
	if lotus_time:
		SignalManager.seed_gathered.emit(30)
	else:
		SignalManager.seed_gathered.emit(2)
	frame = 6
	teen_lotus.frame = 0
	target_opacity = 0.0
	planted_tile = false
	time_ellapsed = 0.0
	plant_stage_index = 0
	plant_time_ellapsed = 0.0
	ready_to_harvest = false
	next_stage_times = []
	for i in range(7):
		next_stage_times.append(randf_range(min_grow_time * 5, max_grow_time * 5))

func _on_interactive_color_rect_mouse_entered():
	if !Global.evil_mode:
		if !planted_tile && Global.seed > 0:
			
			target_opacity = MAX_OPACITY
			
			if Input.is_action_pressed("left_click"):
				plant_seed()
		
		if planted_tile && ready_to_harvest:
			if Input.is_action_pressed("left_click"):
				harvest_plant()
		
		being_hovered = true


func _on_interactive_color_rect_mouse_exited():
	if !planted_tile:
		target_opacity = MIN_OPACITY
	being_hovered = false
