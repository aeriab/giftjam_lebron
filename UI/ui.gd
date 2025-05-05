extends Control

@onready var blood_meter = $Blood/BloodMeter

@onready var seeds_number = $Seeds/SeedsNumber

@export var GOOD_COLOR: Color
@export var EVIL_COLOR: Color
@export var GOOD_SHADOW_COLOR: Color
@export var EVIL_SHADOW_COLOR: Color


func _ready():
	
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



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_evil_button_toggled(toggled_on):
	Global.evil_mode = toggled_on
	SignalManager.song_change.emit()

@onready var good_texture_button = $GoodTextureButton
@onready var evil_texture_button = $EvilTextureButton
@onready var activity_label = $ActivityLabel

func _on_good_texture_button_pressed():
	if Global.in_plant_scene:
		activity_label.text = "BLOOD WATER"
	else:
		activity_label.text = "MURDER"
	good_texture_button.visible = false
	evil_texture_button.visible = true
	activity_label.modulate = EVIL_COLOR
	#activity_label.add_font_override("font", custom_font)
	#activity_label.get_font("font").shadow_color = EVIL_SHADOW_COLOR


func _on_evil_texture_button_pressed():
	if Global.in_plant_scene:
		activity_label.text = "plant seeds"
	else:
		activity_label.text = "feed sheep"
	good_texture_button.visible = true
	evil_texture_button.visible = false
	activity_label.modulate = GOOD_COLOR
	#activity_label.add_font_override("font", custom_font)
	#activity_label.get_font("font").font_shadow_color = GOOD_SHADOW_COLOR
