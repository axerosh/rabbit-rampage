extends KinematicBody2D

var moveSpeed: int = 10000

export var monster_mode: bool = false
var carrots_collected: int = 0
var flesh_collected: int = 0

var velocity: Vector2 = Vector2()
var facing_dir: Vector2 = Vector2(0, 1)
var hitbox_rot_degrees: float = 0

var current_target: Farmer = null

signal carrot_count_changed(new_carrot_count)
signal flesh_count_changed(new_flesh_count)

func _ready() -> void:
	var _result = DayNightManager.connect("day_night_changed", self, "_on_DayNightManager_day_night_changed")

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
	if Input.is_action_pressed("attack") and monster_mode and current_target != null:
		current_target.drop_dead()
	
	velocity = velocity.normalized()
		
	var _movement: Vector2 = move_and_slide(velocity * moveSpeed * delta)

func _on_DayNightManager_day_night_changed(is_night: bool) -> void:
	if (is_night):
		print("Is night, should turn into monster")
	else:
		print("Is day, should turn into bunny")

func _on_CollectionArea2D_area_entered(area: Area2D) -> void:
	if (area is Carrot):
		carrots_collected += 1
		area.queue_free()
		emit_signal("carrot_count_changed", carrots_collected)
	if (area is Flesh):
		flesh_collected += 1
		area.queue_free()
		emit_signal("flesh_count_changed", flesh_collected)


func _on_HitBox_body_entered(body):
	if (body is Farmer):
		current_target = (body as Farmer)


func _on_HitBox_body_exited(body):
	if (body is Farmer):
		current_target = null
