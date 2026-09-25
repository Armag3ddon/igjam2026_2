extends Label

signal text_finished

var max_scale: Vector2 = Vector2(2.0, 2.0)
var max_timer: float = 0.0
var timer: float = 0.0

func action(new_text: String, set_timer_to: float) -> void:
	visible = true
	text = new_text
	scale = max_scale
	max_timer = set_timer_to
	timer = 0.0

func _process(delta: float) -> void:
	if visible:
		timer += delta
		scale = max_scale * (1.0 - (timer / max_timer))
	if timer > max_timer:
		visible = false
		text_finished.emit()
		timer = 0.0
