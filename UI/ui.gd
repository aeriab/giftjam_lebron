extends Control

@onready var blood_meter = $Blood/BloodMeter

@onready var seeds_number = $Seeds/SeedsNumber

@export var GOOD_COLOR: Color
@export var EVIL_COLOR: Color
@export var GOOD_SHADOW_COLOR: Color
@export var EVIL_SHADOW_COLOR: Color

var ready_for_switch: bool = true

func _process(delta):
	if Global.seed < 1 && Global.in_plant_scene && ready_for_switch:
		good_activity_label.text = "grow seeds"
		if Global.any_seeds_ready:
			good_activity_label.text = "harvest"
			Global.any_seeds_ready = false

func _ready():
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


func _on_good_texture_button_pressed():
	Global.evil_mode = true
	SignalManager.song_change.emit()
	
	if Global.in_plant_scene:
		evil_activity_label.text = "BLOOD WATER"
	else:
		evil_activity_label.text = "MURDER"
	evil_activity_label.visible = true
	good_activity_label.visible = false
	
	good_texture_button.visible = false
	evil_texture_button.visible = true

func _on_evil_texture_button_pressed():
	Global.evil_mode = false
	SignalManager.song_change.emit()
	
	if Global.in_plant_scene:
		good_activity_label.text = "plant seeds"
	else:
		good_activity_label.text = "feed sheep"
	good_activity_label.visible = true
	evil_activity_label.visible = false
	
	good_texture_button.visible = true
	evil_texture_button.visible = false

func switchActivityLabel():
	
	if Global.in_plant_scene:
		ready_for_switch = true
		evil_activity_label.text = "BLOOD WATER"
	else:
		ready_for_switch = false
		evil_activity_label.text = "MURDER"
	
	if Global.in_plant_scene:
		ready_for_switch = true
		good_activity_label.text = "plant seeds"
	else:
		ready_for_switch = false
		good_activity_label.text = "feed sheep"
	
	pass
