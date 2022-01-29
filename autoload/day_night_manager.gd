extends Node

signal day_night_changed(is_night)

const day_length: float = 4.0
const night_length: float = 4.0

var night_overlay: TextureRect = null
var is_night: bool = false
var time_until_next_phase: float = day_length

func _process(delta: float) -> void:
	time_until_next_phase -= delta;
	if (time_until_next_phase <= 0.0):
		is_night = !is_night;
		if (night_overlay != null):
			night_overlay.visible = is_night;
		emit_signal("day_night_changed", is_night)
		if (is_night):
			time_until_next_phase = night_length
		else:
			time_until_next_phase = day_length
