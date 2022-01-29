extends KinematicBody2D
class_name Farmer

const flesh_scene: PackedScene = preload("res://collectables/flesh.tscn");
const carrot_scene: PackedScene = preload("res://collectables/carrot.tscn");

const time_between_drops: float = 2.0;
const speed: Vector2 = Vector2(4000, 0);

var time_until_drop: float = time_between_drops;
var carrots_dropped: int = 0;

func _physics_process(delta: float) -> void:
	var _movement: Vector2 = move_and_slide(speed * delta)

func _process(delta: float) -> void:
	time_until_drop -= delta;
	if (time_until_drop <= 0.0):
		time_until_drop = time_between_drops;
		drop_carrot()

func drop_carrot() -> void:
	var carrot: Carrot = carrot_scene.instance();
	get_tree().get_root().add_child(carrot);
	carrot.global_position = self.global_position;

func drop_dead() -> void:
	var flesh: Flesh = flesh_scene.instance();
	get_tree().get_root().add_child(flesh);
	flesh.global_position = self.global_position;
	queue_free();
