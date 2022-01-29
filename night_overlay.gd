extends TextureRect

export var playback_speed: float = 1

func _init():
	DayNightManager.is_night = false

func _ready() -> void:
	$AnimationPlayer.play("TimeOverlay", -1, playback_speed)

func _set_night(night: bool):
	DayNightManager.signal_night(night)
