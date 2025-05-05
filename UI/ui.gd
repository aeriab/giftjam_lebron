extends Control

@onready var blood_meter = $Blood/BloodMeter

@onready var seeds_number = $Seeds/SeedsNumber

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
	print("decreasing seed by: " + str(num))
	seeds_number.text = str(int(Global.seed))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_evil_button_toggled(toggled_on):
	Global.evil_mode = toggled_on
	SignalManager.song_change.emit()
