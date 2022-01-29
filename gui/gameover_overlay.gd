extends TextureRect

func _ready() -> void:
	var _result = GameManager.connect("gameover_status_changed", self, "on_GameManager_gameover_status_changed")

func on_GameManager_gameover_status_changed(is_gameover: bool) -> void:
	visible = is_gameover
