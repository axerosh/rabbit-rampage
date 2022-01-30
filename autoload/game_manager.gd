extends Node2D

signal gameover_status_changed(is_gameover)
signal villager_count_changed(villager_count, birth_count)
signal night_count_changed(night_count)

var farmers: Array = []
var is_gameover: bool = false
var night_counter: int = 0

func _ready() -> void:
	pause_mode = PAUSE_MODE_PROCESS
	var _error = DayNightManager.connect("day_night_changed", self, "on_DayNightManager_day_night_changed")

func register_farmer(farmer: Farmer) -> void:
	if (!farmers.has(farmer)):
		var _result = farmer.connect("died", self, "on_farmer_died")
		farmers.append(farmer)
		emit_signal("villager_count_changed", farmers.size(), get_birth_count())

func on_farmer_died(farmer: Farmer) -> void:
	farmers.erase(farmer)
	emit_signal("villager_count_changed", farmers.size(), get_birth_count())
	if (farmers.empty()):
		set_gameover_status(true)

func get_birth_count() -> int:
	return ceil(farmers.size() / 2.0) as int

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		farmers.clear()
		night_counter = 0
		var _error = get_tree().reload_current_scene()
		set_gameover_status(false)

func set_gameover_status(is_gameover_new: bool):
	is_gameover = is_gameover_new
	emit_signal("gameover_status_changed", is_gameover_new)
	get_tree().paused = is_gameover_new

func on_DayNightManager_day_night_changed(is_night: bool):
	if (is_night):
		night_counter += 1
		emit_signal("night_count_changed", night_counter)
