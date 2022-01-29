extends KinematicBody2D
class_name Human

signal died(human)
var is_dead: bool = false;

func drop_dead() -> void:
	is_dead = true
	emit_signal("died", self)
	queue_free();
