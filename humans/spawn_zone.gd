extends Node2D
class_name SpawnZone

export var width: float = 100.0
export var height: float = 100.0

var acculumated_area: float = 0.0

func get_area() -> float:
	return width * height

func get_min_x() -> float:
	return global_position.x - 0.5 * width;
func get_max_x() -> float:
	return global_position.x + 0.5 * width;
func get_min_y() -> float:
	return global_position.y - 0.5 * height;
func get_max_y() -> float:
	return global_position.y + 0.5 * height;

func get_point_in_zone(rng: RandomNumberGenerator) -> Vector2:
	var x = rng.randf_range(get_min_x(), get_max_x() )
	var y = rng.randf_range(get_min_y(), get_max_y() )
	return Vector2(x, y)

func get_corner_points() -> Array:
	var min_x = get_min_x()
	var max_x = get_max_x()
	var min_y = get_min_y()
	var max_y = get_max_y()
	return [
		Vector2(min_x, min_y),
		Vector2(min_x, max_y),
		Vector2(max_x, min_y),
		Vector2(max_x, max_y)
	]
