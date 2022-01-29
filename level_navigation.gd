extends Navigation2D
class_name LevelNavigation


func get_random_walk_path(current_pos: Vector2, min_distance: float = 100, max_distance: float = 500):
	var distance = rand_range(min_distance, max_distance)
	var target_x = current_pos.x + rand_range(-distance, distance)
	var target_y = current_pos.y + rand_range(-distance, distance)
	
	var target = get_closest_point(Vector2(target_x, target_y))
	var path = get_simple_path(current_pos, target, false)
	return path

