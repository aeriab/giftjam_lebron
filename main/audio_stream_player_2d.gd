extends AudioStreamPlayer2D

var Syncstream
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Syncstream = preload("res://main/backgroundMusicStream.tres")
	play()

var curr_evil = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var vol1 = Syncstream.get_sync_stream_volume(0)
	#print ("vol1", vol1)
	var vol2 = Syncstream.get_sync_stream_volume(1)
	#print ("vol2", vol2)
	var t = 10 * delta
	if Global.evil_mode:
		Syncstream.set_sync_stream_volume(1, lerpf(vol2,3,t))
		Syncstream.set_sync_stream_volume(0, lerpf(vol1,-60,t))
	else:
		Syncstream.set_sync_stream_volume(1, lerpf(vol2,-60,t))
		Syncstream.set_sync_stream_volume(0, lerpf(vol1,0,t))
