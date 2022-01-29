extends Node


func _find_LevelNavigation(node):
	for child in node.get_children():
		if child is LevelNavigation:
			return child
		elif child.get_child_count() > 0:
			var nav2d = _find_LevelNavigation(child)
			if nav2d != null:
				return nav2d
	return null


func find_LevelNavigation():
	var nav2d = _find_LevelNavigation(get_node("/root"))
	if nav2d == null:
		push_error("There is no LevelNavigation in the scene!")
	return nav2d
