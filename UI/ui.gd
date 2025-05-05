extends Control

@onready var blood_meter = $Blood/BloodMeter

@onready var seeds_number = $Seeds/SeedsNumber

@export var GOOD_COLOR: Color
@export var EVIL_COLOR: Color
@export var GOOD_SHADOW_COLOR: Color
@export var EVIL_SHADOW_COLOR: Color

@export var FEEDING_SEED_AMOUNT: int

@export var FADE_IN_OPACITY: float
@export var FADE_OUT_OPACITY: float

var ready_for_switch: bool = true

const EVIL_FACE = preload("res://assets/Faces/EvilFace.png")
const CLICKED_EVIL_FACE = preload("res://assets/Faces/ClickedEvilFace.png")
const CLICKED_HAPPY_FACE = preload("res://assets/Faces/ClickedHappyFace (1).png")
const HAPPY_FACE = preload("res://assets/Faces/HappyFace.png")

func _process(delta):
	
	if Global.blood <= 0.0 && Global.in_plant_scene && ready_for_switch:
		evil_activity_label.text = "no blood"
		evil_texture_button.texture_normal = CLICKED_EVIL_FACE
	elif Global.blood > 0.0 && Global.in_plant_scene && ready_for_switch:
		evil_activity_label.text = "BLOOD WATER"
		evil_texture_button.texture_normal = EVIL_FACE
	
	if !Global.in_plant_scene && Global.sheep_left <= 1 && !ready_for_switch:
		#print("MAKING HERE HERERERER")
		evil_activity_label.text = "need more sheep"
		evil_texture_button.texture_normal = CLICKED_EVIL_FACE
	elif !Global.in_plant_scene && Global.sheep_left > 1 && !ready_for_switch:
		evil_activity_label.text = "MURDER"
		evil_texture_button.texture_normal = EVIL_FACE
	
	if Global.seed < 1 && Global.in_plant_scene && ready_for_switch:
		good_activity_label.text = "grow seeds"
		good_texture_button.texture_normal = CLICKED_HAPPY_FACE
		if Global.any_seeds_ready:
			good_activity_label.text = "harvest"
			Global.any_seeds_ready = false
			good_texture_button.texture_normal = HAPPY_FACE
	elif Global.seed >= 1 && ready_for_switch:
		good_activity_label.text = "plant seeds"
		good_texture_button.texture_normal = HAPPY_FACE
		SignalManager.mouseover.emit("seed")
	
	var can_feed: bool = (Global.any_seeds_planted && Global.seed >= FEEDING_SEED_AMOUNT) || (Global.seed > FEEDING_SEED_AMOUNT)
	if !Global.in_plant_scene && !can_feed && !ready_for_switch:
		good_activity_label.text = "need more seeds"
		good_texture_button.texture_normal = CLICKED_HAPPY_FACE
	elif !Global.in_plant_scene && can_feed && !ready_for_switch:
		good_activity_label.text = "feed sheep"
		good_texture_button.texture_normal = HAPPY_FACE

func _ready():
	
	evil_toggle_on(false)
	
	SignalManager.cameraPanFinished.connect(switchActivityLabel)
	
	SignalManager.sheep_killed.connect(addBlood)
	SignalManager.blood_watered.connect(minusBlood)
	SignalManager.seed_gathered.connect(addSeed)
	SignalManager.seed_used.connect(minusSeed)
	blood_meter.text = str(int(Global.blood))
	seeds_number.text = str(int(Global.seed))

func addBlood():
	Global.blood += 1
	blood_meter.text = str(int(Global.blood))

func minusBlood():
	Global.blood -=1
	blood_meter.text = str(int(Global.blood))

func addSeed(num : int):
	Global.seed += num
	seeds_number.text = str(int(Global.seed))

func minusSeed(num : int):
	Global.seed -= num
	#print("decreasing seed by: " + str(num))
	seeds_number.text = str(int(Global.seed))


func _on_evil_button_toggled(toggled_on):
	Global.evil_mode = toggled_on
	SignalManager.song_change.emit()

@onready var good_texture_button = $GoodTextureButton
@onready var evil_texture_button = $EvilTextureButton
@onready var good_activity_label = $GoodActivityLabel
@onready var evil_activity_label = $EvilActivityLabel


func _on_evil_texture_button_pressed():
	Global.evil_mode = true
	SignalManager.song_change.emit()
	
	#if Global.in_plant_scene:
		#evil_activity_label.text = "BLOOD WATER"
	#else:
		#evil_activity_label.text = "MURDER"
	
	evil_toggle_on(true)
	#evil_activity_label.visible = true
	#good_activity_label.visible = false
	
	#good_texture_button.visible = false
	#evil_texture_button.visible = true

func _on_good_texture_button_pressed():
	Global.evil_mode = false
	SignalManager.song_change.emit()
	
	#if Global.in_plant_scene:
		#good_activity_label.text = "plant seeds"
	#else:
		#good_activity_label.text = "feed sheep"
	
	evil_toggle_on(false)
	#good_activity_label.visible = true
	#evil_activity_label.visible = false
	#
	#good_texture_button.visible = true
	#evil_texture_button.visible = false

func switchActivityLabel():
	
	if Global.in_plant_scene:
		ready_for_switch = true
		#evil_activity_label.text = "BLOOD WATER"
	else:
		ready_for_switch = false
		#evil_activity_label.text = "MURDER"
	
	if Global.in_plant_scene:
		ready_for_switch = true
		#good_activity_label.text = "plant seeds"
	else:
		ready_for_switch = false
		#good_activity_label.text = "feed sheep"
	
	pass

func evil_toggle_on(is_on : bool):
	if !is_on:
		evil_texture_button.modulate.a = FADE_OUT_OPACITY
		evil_activity_label.modulate.a = FADE_OUT_OPACITY
		
		good_texture_button.modulate.a = FADE_IN_OPACITY
		good_activity_label.modulate.a = FADE_IN_OPACITY
	else:
		evil_texture_button.modulate.a = FADE_IN_OPACITY
		evil_activity_label.modulate.a = FADE_IN_OPACITY
		
		good_texture_button.modulate.a = FADE_OUT_OPACITY
		good_activity_label.modulate.a = FADE_OUT_OPACITY
	
	
