extends Human
class_name Bandit

const speed: float = 4500.0
const kill_range_squared: float = 2000.0

var current_target: Farmer = null
var is_enabled: bool = true

func _physics_process(delta: float) -> void:
	if (!is_enabled):
		return
	if (current_target == null):
		choose_new_target()
	if (current_target != null):
		var direction: Vector2 = self.global_position.direction_to(current_target.global_position)
		var _movement: Vector2 = move_and_slide(direction * speed * delta)
		
		var distance_squared: float = self.global_position.distance_squared_to(current_target.global_position)
		if (distance_squared <= kill_range_squared):
			current_target.drop_dead()

func choose_new_target():
	var closest_farmer: Farmer = null
	var closest_distance_squared: float = 10000000.0
	for potential_farmer in get_tree().get_root().get_node("Game").get_children():
		if potential_farmer is Farmer and !potential_farmer.is_dead:
			var distance_squared: float = self.global_position.distance_squared_to(potential_farmer.global_position)
			if (distance_squared < closest_distance_squared):
				closest_distance_squared = distance_squared
				closest_farmer = potential_farmer
	if (closest_farmer != null):
		current_target = closest_farmer
		var _result = current_target.connect("died", self, "_on_current_target_died")

func _on_current_target_died(human: Human) -> void:
	if (human == current_target):
		current_target = null
		choose_new_target()
