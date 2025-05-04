extends Control

var blood = 0

func _ready():
	SignalManager.sheep_killed.connect(addBlood)
	SignalManager.blood_watered.connect(minusBlood)
	$Blood/BloodMeter.text = str(blood)

func addBlood():
	blood += 1
	$Blood/BloodMeter.text = str(blood)

func minusBlood():
	blood -=1
	$Blood/BloodMeter.text = str(blood)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
