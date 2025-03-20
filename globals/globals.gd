extends Node

signal we_have_a_winner()

const PLAYER1 = preload("res://Player1/player.tscn")
const PLAYER2 = preload("res://Player2/player2.tscn")

@onready var spawn_player_1: Marker2D
@onready var spawn_player_2: Marker2D
@onready var map: Node2D
@onready var gui: Control

var player1: Player1
var player2: Player2

var player1_score: int = 0
var player2_score: int = 0

func _ready() -> void:
	map = get_node("/root/Map1")
	gui = get_node("/root/Map1/GUI/Control")
	spawn_player_1 = get_node("/root/Map1/SpawnPlayer1")
	spawn_player_2 = get_node("/root/Map1/SpawnPlayer2")

	player1 = PLAYER1.instantiate()
	player1.global_position = spawn_player_1.global_position
	map.add_child(player1)

	player2 = PLAYER2.instantiate()
	player2.global_position = spawn_player_2.global_position
	map.add_child(player2)

	player1.player1_dead.connect(slow_down_game)
	player2.player2_dead.connect(slow_down_game)

func _process(_delta: float) -> void:
	if player1_score == 5:
		we_have_a_winner.emit(1)
	
	if player2_score == 5:
		we_have_a_winner.emit(2)

func slow_down_game(duration: float = 0.5, factor: float = 0.3):
	Engine.time_scale = factor  # Slow down game
	await get_tree().create_timer(duration * factor).timeout
	Engine.time_scale = 1.0  # Reset speed
