extends Label

func _process(delta):
	text = str(round(Global.blood * 10) / 10.0)
	pass
