extends ColorRect

@export var mat: ShaderMaterial
var loaded: bool = false
var tween_duration: float = 0.5 #sec

func _process(delta: float) -> void:
	if Global.evil_mode and not loaded:
		loaded = true
		create_tween().tween_property(
			mat, "shader_parameter/vignette_strength", 1.5, tween_duration
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		#mat.set_shader_parameter("vignette_strength", 1.5)
	elif not Global.evil_mode and loaded:
		loaded = false
		create_tween().tween_property(
			mat, "shader_parameter/vignette_strength", 0.0, tween_duration
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		#mat.set_shader_parameter("vignette_strength", 0)
		
