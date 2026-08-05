extends CharacterBody2D


const GRAVITY = 900.0
const JUMP_FORCE = -350.0


func _physics_process(delta):
	velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_FORCE
	move_and_slide()
	
	rotation_degrees = clamp(velocity.y / 10.0, -30, 90)
