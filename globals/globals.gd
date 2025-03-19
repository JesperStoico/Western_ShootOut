extends Node

signal we_have_a_winner()

var player1_score: int = 0
var player2_score: int = 0

func _process(_delta: float) -> void:
	if player1_score == 5:
		we_have_a_winner.emit(1)
	
	if player2_score == 5:
		we_have_a_winner.emit(2)
