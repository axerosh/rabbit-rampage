extends Node2D

signal gameover_status_changed(is_gameover)

var farmers: Array = []
var is_gameover = false

func _ready() -> void:
	pause_mode = PAUSE_MODE_PROCESS

func register_farmer(farmer: Farmer) -> void:
	if (!farmers.has(farmer)):
		var _result = farmer.connect("died", self, "on_farmer_died")
		farmers.append(farmer)

func on_farmer_died(farmer: Farmer) -> void:
	farmers.erase(farmer)
	if (farmers.empty()):
		set_gameover_status(true)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		var _error = get_tree().reload_current_scene()
		set_gameover_status(false)

func set_gameover_status(is_gameover_new: bool):
	is_gameover = is_gameover_new
	emit_signal("gameover_status_changed", is_gameover_new)
	get_tree().paused = is_gameover_new
