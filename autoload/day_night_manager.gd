extends Node

var is_night: bool = false

signal day_night_changed(is_night)

func signal_night(is_night_new):
	is_night = is_night_new
	emit_signal("day_night_changed", is_night_new)
