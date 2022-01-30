extends Human
class_name Farmer

const flesh_scene: PackedScene = preload("res://collectables/flesh.tscn");
const carrot_scene: PackedScene = preload("res://collectables/carrot.tscn");

const min_time_between_drops: float = 2.0;
const max_time_between_drops: float = 10.0;
const speed: float = 3000.0
const min_time_waiting: float = 0.5;
const max_time_waiting: float = 3.5;
const pursuer_detection_range_squared: float = 10000.0;

var time_between_drops: float = rand_range(min_time_between_drops, max_time_between_drops)
var time_until_drop: float = time_between_drops
var waiting_time: float = rand_range(min_time_waiting, max_time_waiting)

var carrots_dropped: int = 0;

var walk_path: PoolVector2Array = PoolVector2Array([])
var pursuers: Array = []

func _ready() -> void:
	GameManager.register_farmer(self)
	var is_evil = false
	init_health(is_evil)
	var _result = connect("died", self, "on_death")

func on_death(_human: Human):
	drop_flesh()

func _physics_process(delta: float) -> void:
	if !is_enabled:
		return;
	var closest_nearby_pursuer: Human = null
	var closest_distance_squared: float = pursuer_detection_range_squared
	for pursuer in pursuers:
		if not is_instance_valid(pursuer):
			continue
		pursuer = pursuer as Human
		var distance_squared: float = self.global_position.distance_squared_to(pursuer.global_position)
		if (distance_squared < closest_distance_squared):
			closest_distance_squared = distance_squared
			closest_nearby_pursuer = pursuer
	
	if (closest_nearby_pursuer != null):
		set_sweating(true)
		move_away_from(closest_nearby_pursuer.global_position, speed * delta)
	else:
		set_sweating(false)
		move_along_path(speed * delta)

func move_away_from(from_point: Vector2, distance: float):
	var direction = (global_position - from_point).normalized()
	var _result = move_and_slide(direction * distance)
	
	while (!walk_path.empty()):
		walk_path.remove(0)
		waiting_time = 0

func move_along_path(distance: float):
	if walk_path.size() == 0:
		return
	
	var start_point = position
	var next_point = walk_path[0]
	var distance_to_next = start_point.distance_to(next_point)
	var direction = (next_point - position).normalized()
	if distance <= distance_to_next:
		var _result = move_and_slide(direction * distance)
	else:
		var _result = move_and_slide(direction * (distance - distance_to_next))
		walk_path.remove(0)


func _process(delta: float) -> void:
	if !is_enabled:
		return;
	time_until_drop -= delta;
	if (time_until_drop <= 0.0):
		time_until_drop = time_between_drops;
		drop_carrot()
	
	if walk_path.size() == 0:
		if waiting_time > 0:
			waiting_time -= delta
		elif waiting_time <= 0:
			walk_path = Lookup.find_LevelNavigation().get_random_walk_path(global_position)
			waiting_time = rand_range(min_time_waiting, max_time_waiting)

func set_haunted(pursuer: Human) -> void:
	if (!pursuers.has(pursuer)):
		pursuers.append(pursuer)
	if (!pursuer.is_connected("died", self, "on_pursuer_died")):
		var _error = pursuer.connect("died", self, "on_pursuer_died")

func on_pursuer_died(pursuer: Human) -> void:
	var time = OS.get_time()
	var time_return = String(time.hour) +":"+String(time.minute)+":"+String(time.second)
	print(time_return + ": pursuer " + str(pursuer) + " died")
	if (pursuers.has(pursuer)):
		pursuers.erase(pursuer)
	if (pursuer.is_connected("died", self, "on_pursuer_died")):
		pursuer.disconnect("died", self, "on_pursuer_died")

func drop_carrot() -> void:
	var carrot: Carrot = carrot_scene.instance();
	get_tree().get_root().add_child(carrot);
	carrot.global_position = self.global_position;

func drop_flesh() -> void:
	var flesh: Flesh = flesh_scene.instance();
	get_tree().get_root().add_child(flesh);
	flesh.global_position = self.global_position;
