extends Sprite2D


@onready var cpu_particles_2d = $"../CPUParticles2D"
@onready var digSFX = $"../digSFX"

@export var MAX_OPACITY: float
@export var MIN_OPACITY: float
@export var FADE_IN_SPEED: float
@export var FADE_OUT_SPEED: float

@export var MIN_GROW_TIME: float
@export var MAX_GROW_TIME: float

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

func _ready():
	next_stage_times = []
	for i in range(7):
		next_stage_times.append(randf_range(MIN_GROW_TIME, MAX_GROW_TIME))

func _process(delta):
	if !planted_tile:
		if being_hovered:
			current_opacity = lerpf(current_opacity,target_opacity,FADE_IN_SPEED * delta)
		else:
			current_opacity = lerpf(current_opacity,target_opacity,FADE_OUT_SPEED * delta)
	else:
		current_opacity = lerpf(current_opacity,target_opacity,FADE_IN_SPEED * delta)
		
		plant_time_ellapsed += delta
		if plant_stage_index >= next_stage_times.size():
			ready_to_harvest = true
			return
		if plant_time_ellapsed > next_stage_times[plant_stage_index]:
			plant_stage_index += 1
			plant_time_ellapsed = 0
			frame += 1
	
	current_color = current_color.lerp(target_color, FADE_IN_SPEED * delta)
	
	if Global.color_distance(current_color, target_color) < 0.1:
		target_color = NORMAL_COLOR
	
	modulate = current_color
	
	modulate.a = current_opacity


func _on_interactive_color_rect_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		
		if !planted_tile:
			if Global.seed > 0:
				plant_seed()
			else:
				target_color = NO_SEEDS_COLOR
				
		
		if ready_to_harvest:
			harvest_plant()
		

func plant_seed():
	digSFX.play()
	target_opacity = MAX_OPACITY + randf_range(0.1, 0.2)
	planted_tile = true
	SignalManager.seed_used.emit()

func harvest_plant():
	#cpu_particles_2d.emitting = true
	SignalManager.seed_gathered.emit()
	SignalManager.seed_gathered.emit()
	frame = 6
	target_opacity = 0.0
	planted_tile = false
	time_ellapsed = 0.0
	plant_stage_index = 0
	plant_time_ellapsed = 0.0
	ready_to_harvest = false
	next_stage_times = []
	for i in range(7):
		next_stage_times.append(randf_range(MIN_GROW_TIME, MAX_GROW_TIME))

func _on_interactive_color_rect_mouse_entered():
	if !planted_tile:
		target_opacity = MAX_OPACITY
		
		if Input.is_action_pressed("left_click") && Global.seed > 0:
			plant_seed()
	
	if planted_tile && ready_to_harvest:
		if Input.is_action_pressed("left_click"):
			harvest_plant()
	
	being_hovered = true


func _on_interactive_color_rect_mouse_exited():
	if !planted_tile:
		target_opacity = MIN_OPACITY
	being_hovered = false
