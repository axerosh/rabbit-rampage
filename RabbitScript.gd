extends KinematicBody2D

var moveSpeed: int = 200

var velocity: Vector2 = Vector2()
var facingDir: Vector2 = Vector2(0, 1)

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	
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
		
	move_and_slide(velocity * moveSpeed)
