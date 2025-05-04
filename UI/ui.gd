extends Control

var blood = 0
@onready var blood_meter = $Blood/BloodMeter

var seed = 3
@onready var seeds_number = $Seeds/SeedsNumber

func _ready():
	SignalManager.sheep_killed.connect(addBlood)
	SignalManager.blood_watered.connect(minusBlood)
	SignalManager.seed_gathered.connect(addSeed)
	SignalManager.seed_used.connect(minusSeed)
	blood_meter.text = str(blood)

func addBlood():
	blood += 1
	blood_meter.text = str(blood)

func minusBlood():
	blood -=1
	blood_meter.text = str(blood)

func addSeed():
	seed += 1
	seeds_number.text = str(seed)

func minusSeed():
	seed -=1
	seeds_number.text = str(seed)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
