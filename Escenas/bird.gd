extends CharacterBody2D

signal died 

const GRAVITY = 900.0
const JUMP_FORCE = -350.0

var vive = false 
var can_move = false 

func _physics_process(delta):
	if not can_move:
		return 
	
	velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("jump") and vive:
		velocity.y = JUMP_FORCE
	move_and_slide()
	
	if vive and get_slide_collision_count() > 0:
		die()
		
func start(): 
	vive = true 
	can_move = true
	velocity = Vector2.ZERO 
	rotation_degrees = 0
	
func die():
	if not vive:
		return
	
	vive = false
	can_move = false
	died.emit()
