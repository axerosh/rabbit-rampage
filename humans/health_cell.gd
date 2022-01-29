extends Sprite
class_name HealthCell

const dead_texture: StreamTexture = preload("res://images/health_dead.png")
const evil_texture: StreamTexture = preload("res://images/health_evil.png")
const good_texture: StreamTexture = preload("res://images/health_good.png")

var is_evil: bool = false

func set_alive(is_alive: bool):
	if (!is_alive):
		texture = dead_texture
	elif (is_evil):
		texture = evil_texture
	else:
		texture = good_texture
