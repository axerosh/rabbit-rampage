extends Human
class_name Farmer

const flesh_scene: PackedScene = preload("res://collectables/flesh.tscn");
const carrot_scene: PackedScene = preload("res://collectables/carrot.tscn");

const min_time_between_drops: float = 2.0;
const max_time_between_drops: float = 10.0;
const speed: float = 4000.0
const min_time_waiting: float = 0.5;
const max_time_waiting: float = 3.5;

var time_between_drops: float = rand_range(min_time_between_drops, max_time_between_drops)
var time_until_drop: float = time_between_drops
var waiting_time: float = rand_range(min_time_waiting, max_time_waiting)

var carrots_dropped: int = 0;

var walk_path: PoolVector2Array = PoolVector2Array([])

func _ready() -> void:
	var is_evil = false
	init_health(2, is_evil)

func _physics_process(delta: float) -> void:
	move_along_path(speed * delta)

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
	time_until_drop -= delta;
	if (time_until_drop <= 0.0):
		time_until_drop = time_between_drops;
		drop_carrot()
	
	if walk_path.size() == 0:
		if waiting_time > 0:
			waiting_time -= delta
		elif waiting_time <= 0:
			walk_path = Lookup.find_LevelNavigation().get_random_walk_path(position)
			waiting_time = rand_range(min_time_waiting, max_time_waiting)

func drop_carrot() -> void:
	var carrot: Carrot = carrot_scene.instance();
	get_tree().get_root().add_child(carrot);
	carrot.global_position = self.global_position;

func drop_dead() -> void:
	var flesh: Flesh = flesh_scene.instance();
	get_tree().get_root().add_child(flesh);
	flesh.global_position = self.global_position;
	.drop_dead()
