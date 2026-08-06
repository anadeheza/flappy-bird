extends Node2D

const PIPE_SCENE = preload("res://Escenas/pipe.tscn")
const PIPE_SPAWN_X = 600.0 
 
const DIGITS = "res://assets/sprites/numbers/"

enum GameState {
	MENU,
	PLAYING,
	GAMEOVER
}

var game_state = GameState.MENU 
var score = 0

@onready var bird = $Bird 
@onready var pipe_timer = $PipeSpawnTimer
@onready var scoreSound: AudioStreamPlayer = $sonidoScore

func _ready():
	pipe_timer.timeout.connect(_on_pipe_spawn_timer_timeout)
	bird.died.connect(_on_bird_died)
	
	pipe_timer.stop()
	
	_show_menu()
	
func _input(event):
	if not event.is_action_pressed("jump"):
		return
	
	if game_state == GameState.MENU:
		start_game()
	elif game_state == GameState.GAMEOVER:
		restart_game()
		

func start_game():
	game_state = GameState.PLAYING
	
	score = 0
	mostrar_score(score, $UI/Score/ScoreLabel)
	
	$UI/Menu.visible = false 
	$UI/GameOver.visible = false 
	$UI/Score.visible = true
	
	bird.position = Vector2(93, 442)
	bird.start()
	pipe_timer.start()

func _on_pipe_spawn_timer_timeout():
	if game_state != GameState.PLAYING:
		return
	
	var pipe = PIPE_SCENE.instantiate()
	
	pipe.position = Vector2(
		PIPE_SPAWN_X, 
		randi_range(200, 400)
	)
	
	add_child(pipe)
	pipe.scored.connect(_on_pipe_scored)

func _on_pipe_scored():
	if game_state != GameState.PLAYING:
		return
	
	score += 1
	scoreSound.play()
	mostrar_score(score, $UI/Score/ScoreLabel)

func _on_bird_died():
	if game_state != GameState.PLAYING:
		return
	
	game_state = GameState.GAMEOVER
	
	pipe_timer.stop()
	
	for p in get_children():
		if p.scene_file_path == "res://Escenas/pipe.tscn":
			p.detener()
	
	$UI/GameOver/ScoreLabel.text = "SCORE: " + str(score)
	$UI/GameOver.visible = true
	$UI/Score.visible = false

func restart_game():
	for child in get_children():
		if child.scene_file_path == "res://Escenas/pipe.tscn": 
			child.queue_free()
	
	start_game()

func _show_menu():
	game_state = GameState.MENU 
	
	$UI/Menu.visible = true 
	$UI/GameOver.visible = false 
	$UI/Score.visible = false

func mostrar_score(numero: int, cont: HBoxContainer):
	for hijo in cont.get_children():
		hijo.queue_free()
		
	for car in str(numero):
		var tex_rec = TextureRect.new()
		tex_rec.texture = load(DIGITS + car + ".png")
		tex_rec.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		cont.add_child(tex_rec)
