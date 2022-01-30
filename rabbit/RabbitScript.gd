extends KinematicBody2D

const level_stats: Dictionary = {
	1: {
		flesh_required = 0,
		attack_damage = 1,
		attack_cost = 1,
		speed_factor = 1.0,
	},
	2: {
		flesh_required = 2,
		attack_damage = 2,
		attack_cost = 2,
		speed_factor = 1.1,
	},
	3: {
		flesh_required = 5,
		attack_damage = 3,
		attack_cost = 2,
		speed_factor = 1.25,
	},
	4: {
		flesh_required = 9,
		attack_damage = 5,
		attack_cost = 3,
		speed_factor = 1.45,
	},
	5: {
		flesh_required = 14,
		attack_damage = 7,
		attack_cost = 4,
		speed_factor = 1.7,
	},
	6: {
		flesh_required = 20,
		attack_damage = 10,
		attack_cost = 6,
		speed_factor = 2.0,
	},
}

export var monster_mode: bool = false
export var monster_color: Color = Color.white

var carrots_collected: int = 0
var flesh_collected: int = 0

var velocity: Vector2 = Vector2()
var facing_dir: Vector2 = Vector2(0, 1)
var hitbox_rot_degrees: float = 0
var current_target: Human = null

const base_speed: float = 10000.0
var is_first_update: bool = true
var level: int = 0;
var attack_damage: int = 1
var attack_cost: int = 1
var speed_factor: float = 1.0


signal leveled_up(level, speed, damage, carrot_cost, next_flesh_cost, next_level, next_speed, next_damage, next_carrot_cost)
signal final_leveled_up(level, speed, damage, carrot_cost)
signal carrot_count_changed(new_carrot_count)
signal flesh_count_changed(new_flesh_count)

func _ready() -> void:
	var _result = DayNightManager.connect("day_night_changed", self, "_on_DayNightManager_day_night_changed")
	monster_mode = DayNightManager.is_night

func _exit_tree() -> void:
	DayNightManager.disconnect("day_night_changed", self, "_on_DayNightManager_day_night_changed")

func _physics_process(delta: float) -> void:
	if (is_first_update):
		is_first_update = false
		try_evolve()
	
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
	if Input.is_action_just_pressed("attack") and monster_mode and current_target != null and carrots_collected >= attack_cost:
		current_target.damage(attack_damage)
		carrots_collected -= attack_cost
		emit_signal("carrot_count_changed", carrots_collected)
		$CarrotEatSound.stop()
		$CarrotEatSound.play()
	
	velocity = velocity.normalized()
		
	var _movement: Vector2 = move_and_slide(velocity * base_speed * speed_factor * delta)

func _on_DayNightManager_day_night_changed(is_night: bool) -> void:
	monster_mode = is_night
	if monster_mode:
		$AnimationPlayer.play("TurnIntoMonster")
	else:
		$AnimationPlayer.play("TurnIntoNormal")

func _on_CollectionArea2D_area_entered(area: Area2D) -> void:
	if (area is Carrot):
		carrots_collected += 1
		area.queue_free()
		emit_signal("carrot_count_changed", carrots_collected)
		$CarrotEatSound.stop()
		$CarrotEatSound.play()
		$EatCarrotParticles.emitting = true
	if (area is Flesh):
		flesh_collected += 1
		area.queue_free()
		try_evolve()
		emit_signal("flesh_count_changed", flesh_collected)
		$FleshEatSound.stop()
		$FleshEatSound.play()
		$EatFleshParticles.emitting = true

func try_evolve():
	var next_level = level + 1
	if (!level_stats.has(next_level)):
		return
	var next_level_stats = level_stats[next_level]
	if (flesh_collected >= next_level_stats.flesh_required):
		flesh_collected -= next_level_stats.flesh_required
		level = next_level
		attack_damage = next_level_stats.attack_damage
		attack_cost = next_level_stats.attack_cost
		speed_factor = next_level_stats.speed_factor
		
		next_level = level + 1
		$LevelUpParticles.emitting = true
		if (!level_stats.has(next_level)):
			emit_signal("final_leveled_up", level, speed_factor, attack_damage, attack_cost)
		else:
			next_level_stats = level_stats[next_level]
			var next_flesh_required: int = next_level_stats.flesh_required
			var next_attack_damage: int = next_level_stats.attack_damage
			var next_attack_cost: int = next_level_stats.attack_cost
			var next_speed_factor: float = next_level_stats.speed_factor
			emit_signal("leveled_up", level, speed_factor, attack_damage, attack_cost, next_flesh_required, next_level, next_speed_factor, next_attack_damage, next_attack_cost)

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
