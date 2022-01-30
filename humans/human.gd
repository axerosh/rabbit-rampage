extends KinematicBody2D
class_name Human

var health: int = 2;
export var is_enabled: bool = true

signal died(human)
var is_dead: bool = false;

func init_health(max_health: int, is_evil: bool):
	health = max_health
	$HealthBar.init(max_health, max_health, is_evil)

func damage(damage: int) -> void:
	health -= damage
	$HealthBar.set_current_health(health)
	$BloodParticles.emitting = true
	if (health <= 0):
		is_dead = true
		emit_signal("died", self)
		$Sprite.visible = false
		is_enabled = false
		$HealthBar.visible = false
		$CollisionShape2D.disabled = true
		$DeathParticles.emitting = true
		yield(get_tree().create_timer(1.0), "timeout")
		queue_free()

func set_sweating(sweating: bool):
	$SweatParticles.emitting = sweating
