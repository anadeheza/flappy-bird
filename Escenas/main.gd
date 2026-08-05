extends Node2D

const PIPE_SCENE = preload("res://Escenas/pipe.tscn")
const PIPE_SPAWN_X = 600.0 
 
var score = 0

func _ready():
	$PipeSpawnTimer.timeout.connect(_on_pipe_spawn_timer_timeout)

func _on_pipe_spawn_timer_timeout():
	var pipe = PIPE_SCENE.instantiate()
	pipe.position = Vector2(PIPE_SPAWN_X, randi_range(200, 400))
	add_child(pipe)
	pipe.scored.connect(_on_pipe_scored)

func _on_pipe_scored():
	score += 1
	print(score)
