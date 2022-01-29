extends Node

var is_night: bool = false

signal day_night_changed(is_night)

func signal_night(is_night):
	emit_signal("day_night_changed", is_night)
