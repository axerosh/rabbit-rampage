extends Human
class_name Bandit

const speed: float = 4500.0
const kill_range_squared: float = 2000.0
const attack_cooldown_time: float = 2.0

var current_target: Farmer = null
var time_until_attack: float = 0.0
var attack_damage: int = 1

func _ready() -> void:
	var is_evil = true
	init_health(2, is_evil)

func _physics_process(delta: float) -> void:
	if (!is_enabled):
		return
	time_until_attack -= delta
	if (current_target == null):
		choose_new_target()
	if (current_target != null):
		var direction: Vector2 = self.global_position.direction_to(current_target.global_position)
		var speed_modifier: float = 1.0
		if (!DayNightManager.is_night):
			speed_modifier = 0.5
		var _movement: Vector2 = move_and_slide(direction * speed * speed_modifier * delta)
		
		var distance_squared: float = self.global_position.distance_squared_to(current_target.global_position)
		if (distance_squared <= kill_range_squared && time_until_attack <= 0.0):
			time_until_attack = attack_cooldown_time
			current_target.damage(attack_damage)

func choose_new_target():
	var closest_farmer: Farmer = null
	var closest_distance_squared: float = 10000000.0
	for farmer in GameManager.farmers:
		farmer = farmer as Farmer
		if !farmer.is_dead:
			var distance_squared: float = self.global_position.distance_squared_to(farmer.global_position)
			if (distance_squared < closest_distance_squared):
				closest_distance_squared = distance_squared
				closest_farmer = farmer
	if (closest_farmer != null):
		current_target = closest_farmer
		var _result = current_target.connect("died", self, "_on_current_target_died")

func _on_current_target_died(human: Human) -> void:
	if (human == current_target):
		current_target = null
		choose_new_target()
