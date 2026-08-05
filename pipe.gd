extends Node2D

const SPEED = 150.0

func _process(delta):
	position.x -= SPEED * delta
	if position.x < -100:
		queue_free()
