extends KinematicBody2D
class_name Human

var health: int = 2;

signal died(human)
var is_dead: bool = false;

func init_health(max_health: int, is_evil: bool):
	health = max_health
	$HealthBar.init(max_health, max_health, is_evil)

func damage(damage: int) -> void:
	health -= damage
	$HealthBar.set_current_health(health)
	if (health <= 0):
		is_dead = true
		emit_signal("died", self)
		queue_free();
