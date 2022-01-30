extends Node2D
class_name BgmPlayer

func _ready():
	if DayNightManager.is_night:
		$"Bgm Day".volume_db = -80
		$"Bgm Night".volume_db = 0
	else:
		$"Bgm Day".volume_db = 0
		$"Bgm Night".volume_db = -80
		
	var _result = DayNightManager.connect("day_night_changed", self, "_day_night_changed")

func _exit_tree():
	DayNightManager.disconnect("day_night_changed", self, "_day_night_changed")

func _day_night_changed(is_night: bool):
	if is_night:
		$AnimationPlayer.play("FadeToNight")
	else:
		$AnimationPlayer.play("FadeToDay")
