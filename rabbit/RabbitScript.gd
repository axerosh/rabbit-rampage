extends KinematicBody2D

var moveSpeed: int = 10000

var carrots_collected: int = 0
var flesh_collected: int = 0

var velocity: Vector2 = Vector2()
var facingDir: Vector2 = Vector2(0, 1)

signal carrot_count_changed(new_carrot_count)
signal flesh_count_changed(new_flesh_count)

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	
	velocity = Vector2()
	
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		facingDir = Vector2(0, -1)
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		facingDir = Vector2(0, 1)
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		facingDir = Vector2(-1, 0)
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		facingDir = Vector2(1, 0)
		
	velocity = velocity.normalized()
		
	var _movement: Vector2 = move_and_slide(velocity * moveSpeed * delta)

func _on_CollectionArea2D_area_entered(area: Area2D) -> void:
	if (area is Carrot):
		carrots_collected += 1
		area.queue_free()
		emit_signal("carrot_count_changed", carrots_collected)
	if (area is Flesh):
		flesh_collected += 1
		area.queue_free()
		emit_signal("flesh_count_changed", flesh_collected)
