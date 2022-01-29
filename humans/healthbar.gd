extends Node

const cell_scene: PackedScene = preload("res://humans/health_cell.tscn")

var cells: Array = []

# Only call this once
func init(max_health: int, current_health: int, is_evil: bool) -> void:
	var offset_x: float = 0.0
	var is_first_cell: bool = true
	for i in range(max_health):
		var cell: HealthCell = cell_scene.instance()
		cell.is_evil = is_evil
		cell.set_alive(current_health > i)
		add_child(cell)
		cells.append(cell)
		if (is_first_cell):
			is_first_cell = false
			offset_x = -0.5 *  (max_health - 1) * cell.texture.get_width()
		cell.position = Vector2(offset_x + i * cell.texture.get_width(), 0.0)

func set_current_health(current_health: int) -> void:
	for i in range(cells.size()):
		var cell: HealthCell = cells[i]
		cell.set_alive(current_health > i)
