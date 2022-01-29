extends KinematicBody2D

const level_stats: Dictionary = {
	1: {
		flesh_required = 0,
		attack_damage = 1,
		movement_speed = 10000.0,
	},
	2: {
		flesh_required = 2,
		attack_damage = 2,
		movement_speed = 11000.0,
	},
	3: {
		flesh_required = 5,
		attack_damage = 3,
		movement_speed = 12500.0,
	},
	4: {
		flesh_required = 9,
		attack_damage = 5,
		movement_speed = 14500.0,
	},
	5: {
		flesh_required = 14,
		attack_damage = 7,
		movement_speed = 17000.0,
	},
	6: {
		flesh_required = 20,
		attack_damage = 10,
		movement_speed = 20000.0,
	},
}

export var monster_mode: bool = false
var carrots_collected: int = 0
var flesh_collected: int = 0

var velocity: Vector2 = Vector2()
var facing_dir: Vector2 = Vector2(0, 1)
var hitbox_rot_degrees: float = 0
var current_target: Human = null

var level = 1;
var attack_damage: int = 1
var movement_speed: float = 10000.0

signal carrot_count_changed(new_carrot_count)
signal flesh_count_changed(new_flesh_count)

func _ready() -> void:
	var _result = DayNightManager.connect("day_night_changed", self, "_on_DayNightManager_day_night_changed")
	monster_mode = DayNightManager.is_night

func _exit_tree() -> void:
	DayNightManager.disconnect("day_night_changed", self, "_on_DayNightManager_day_night_changed")

func _physics_process(delta: float) -> void:
	
	velocity = Vector2()
	
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		facing_dir = Vector2(0, -1)
		hitbox_rot_degrees = 180
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		facing_dir = Vector2(0, 1)
		hitbox_rot_degrees = 0
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		facing_dir = Vector2(-1, 0)
		hitbox_rot_degrees = 90
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		facing_dir = Vector2(1, 0)
		hitbox_rot_degrees = 270
		
	$HitBox.rotation_degrees = hitbox_rot_degrees
	$HitBox.visible = monster_mode
	if Input.is_action_just_pressed("attack") and monster_mode and current_target != null and carrots_collected > 0:
		current_target.damage(attack_damage)
		carrots_collected -= 1
		emit_signal("carrot_count_changed", carrots_collected)
		$CarrotEatSound.stop()
		$CarrotEatSound.play()
	
	velocity = velocity.normalized()
		
	var _movement: Vector2 = move_and_slide(velocity * movement_speed * delta)

func _on_DayNightManager_day_night_changed(is_night: bool) -> void:
	monster_mode = is_night

func _on_CollectionArea2D_area_entered(area: Area2D) -> void:
	if (area is Carrot):
		carrots_collected += 1
		area.queue_free()
		emit_signal("carrot_count_changed", carrots_collected)
		$CarrotEatSound.stop()
		$CarrotEatSound.play()
	if (area is Flesh):
		flesh_collected += 1
		area.queue_free()
		try_evolve()
		emit_signal("flesh_count_changed", flesh_collected)
		$FleshEatSound.stop()
		$FleshEatSound.play()

func try_evolve():
	var next_level = level + 1
	if (!level_stats.has(next_level)):
		return
	var next_level_stats = level_stats[next_level]
	if (flesh_collected >= next_level_stats.flesh_required):
		flesh_collected -= next_level_stats.flesh_required
		level = next_level
		attack_damage = next_level_stats.attack_damage
		movement_speed = next_level_stats.movement_speed

func _on_current_target_died(human: Human) -> void:
	if (human == current_target):
		current_target = null

func _on_HitBox_body_entered(body):
	if (body is Human):
		var human: Human = body as Human
		if (!human.is_dead):
			current_target = human
			if (!current_target.is_connected("died", self, "_on_current_target_died")):
				var _result = current_target.connect("died", self, "_on_current_target_died")


func _on_HitBox_body_exited(body):
	if (body is Human):
		if (body as Human == current_target):
			current_target.disconnect("died", self, "_on_current_target_died")
			current_target = null
