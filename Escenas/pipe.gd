extends Node2D
signal scored 
const SPEED = 150.0
@onready var top_sprite: Sprite2D = $Top/Sprite2D
@onready var top_coll: CollisionShape2D = $Top/CollisionShape2D

var moving = true 

func _ready():
	_stretch_top_pipe()

func _stretch_top_pipe():
	var altura = top_sprite.texture.get_height()
	var borde_inf = top_sprite.position.y + altura / 2.0

	var borde_sup = position.y + borde_inf
	var techo_objetivo = -50.0  
	var altura_nec = borde_sup - techo_objetivo
	altura_nec = max(altura_nec, altura)  
	var escala_y = altura_nec / altura

	top_sprite.scale.y = escala_y
	top_sprite.position.y = borde_inf - altura_nec / 2.0
	top_coll.scale.y = escala_y
	top_coll.position.y = top_sprite.position.y

func _process(delta):
	if not moving:
		return 
	position.x -= SPEED * delta
	if position.x < -100:
		queue_free()

func detener():
	moving = false

func _on_score_body_entered(_body):
	emit_signal("scored")
