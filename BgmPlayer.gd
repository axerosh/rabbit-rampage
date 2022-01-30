extends Node2D
class_name BgmPlayer

var is_night: bool = false

func _ready():
	$AnimationPlayer.playback_speed = 0.5
	if DayNightManager.is_night:
		$"Bgm Day".volume_db = -80
		$"Bgm Night".volume_db = -5
	else:
		$"Bgm Day".volume_db = 0
		$"Bgm Night".volume_db = -80
		
	var _result = DayNightManager.connect("day_night_changed", self, "_day_night_changed")

func _exit_tree():
	DayNightManager.disconnect("day_night_changed", self, "_day_night_changed")

func _day_night_changed(new_is_night: bool):
	if (new_is_night == is_night):
		return
	
	is_night = new_is_night
	if is_night:
		$AnimationPlayer.play("FadeToNight")
	else:
		$AnimationPlayer.play("FadeToDay")
