extends TextureRect

func _ready() -> void:
	visible = DayNightManager.is_night
	DayNightManager.night_overlay = self

func _exit_tree():
	DayNightManager.night_overlay = null
