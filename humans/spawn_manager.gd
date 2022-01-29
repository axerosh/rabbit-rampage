extends Node2D
class_name SpawnManager

export var scene_to_spawn: PackedScene = null

const time_between_spawns: float = 2.0

var rng: RandomNumberGenerator
var spawn_zones: Array = []
var total_area: float = 0.0
var time_until_spawn: float = 0.0

func _ready() -> void:
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	init_zones()
	var _result = DayNightManager.connect("day_night_changed", self, "on_DayNightManager_day_night_changed")
	
	#test_spawn_all_corners()

func init_zones() -> void:
	spawn_zones.clear()
	total_area = 0.0
	for potential_spawn_zone in get_children():
		if (potential_spawn_zone is SpawnZone):
			var spawn_zone: SpawnZone = potential_spawn_zone as SpawnZone
			spawn_zones.append(spawn_zone)
			total_area += spawn_zone.get_area()
			spawn_zone.acculumated_area = total_area

func on_DayNightManager_day_night_changed(_is_night: bool):
	time_until_spawn = 0.0

func _physics_process(delta: float) -> void:
	if (DayNightManager.is_night):
		time_until_spawn -= delta
		if (time_until_spawn <= 0):
			time_until_spawn = time_between_spawns
			spawn_at_random_position()

func spawn_at_random_position() -> void:
	var roll: float = rng.randf_range(0.0, total_area)
	for obj in spawn_zones:
		var spawn_zone = obj as SpawnZone
		if (spawn_zone.acculumated_area > roll):
			var spawn_point: Vector2 = spawn_zone.get_point_in_zone(rng)
			var spawned_scene: Bandit = scene_to_spawn.instance()
			get_tree().root.add_child(spawned_scene)
			spawned_scene.global_position = spawn_point
			return

func test_spawn_all_corners() -> void:
	if (scene_to_spawn == null):
		print(str(typeof(self)) + "No scene to spawn specified")
		return
	
	for spawn_zone in get_children():
		if (spawn_zone is SpawnZone):
			for spawn_point in (spawn_zone as SpawnZone).get_corner_points():
				var spawned_scene: Bandit = scene_to_spawn.instance()
				spawned_scene.is_enabled = false
				get_tree().root.call_deferred("add_child", spawned_scene)
				spawned_scene.global_position = spawn_point
