class_name GUI extends Control

signal break_over

@export var bullet_texture: Texture  # Assign in the Inspector

@onready var bullet_containers: Dictionary = {
	1: $Player1_bullets,
	2: $Player2_bullets
}
@onready var player_1: Player1 = Globals.player1
@onready var player_2: Player2 = Globals.player2
@onready var score: Label = $Label
@onready var win_screen: Control = $WinScreen
@onready var win_screen_label: Label = $WinScreen/ColorRect/Label
@onready var break_screen_label: Label = $BreakScreen/Label
@onready var break_screen_timer: float = 0.0

var break_timer_running: bool = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	player_1.shoot_signal.connect(bullet_used_p1)
	player_1.reload_signal.connect(reload_p1)
	player_1.player1_dead.connect(update_score_board)
	player_2.shoot_signal.connect(bullet_used_p2)
	player_2.reload_signal.connect(reload_p2)
	player_2.player2_dead.connect(update_score_board)
	
	Globals.we_have_a_winner.connect(show_win_screen)
	
	win_screen.visible = false
	break_screen_label.visible = false
	score.text = str(Globals.player1_score) + " - " + str(Globals.player2_score)
	update_bullet_display()

func _process(delta: float) -> void:
	if break_timer_running:
		if break_screen_timer > 0:
			break_screen_timer -= delta
			break_screen_label.text = "Next round in " + str(snapped(break_screen_timer, 1.0))
		else:
			break_screen_label.visible = false
			get_tree().paused = false
			break_over.emit()
			break_timer_running = false

func update_bullet_display():
	for player in range(1, 3):
		for child in bullet_containers[player].get_children():
			child.queue_free()
		
		if player == 1:
			for i in range(player_1.current_bullet_count):
				var bullet = TextureRect.new()
				bullet.texture = bullet_texture
				bullet.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT  # Keeps the aspect ratio
				bullet.custom_minimum_size = Vector2(10, 10)  # Set a fixed size
				bullet_containers[player].add_child(bullet)
		else:
			for i in range(player_2.current_bullet_count):
				var bullet = TextureRect.new()
				bullet.texture = bullet_texture
				bullet.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT  # Keeps the aspect ratio
				bullet.custom_minimum_size = Vector2(10, 10)  # Set a fixed size
				bullet_containers[player].add_child(bullet)

func set_bullets_p2(amount: int):
	player_2.current_bullet_count = clamp(amount, 0, player_2.max_bullets)
	update_bullet_display()

func bullet_used_p2() -> void:
	set_bullets_p2(player_2.current_bullet_count)

func reload_p2() -> void:
	set_bullets_p2(player_2.current_bullet_count)

func set_bullets_p1(amount: int):
	player_1.current_bullet_count = clamp(amount, 0, player_1.max_bullets)
	update_bullet_display()

func bullet_used_p1() -> void:
	set_bullets_p1(player_1.current_bullet_count)

func reload_p1() -> void:
	set_bullets_p1(player_1.current_bullet_count)

func update_score_board() -> void:
	break_screen_label.text = "Next round in 10"
	break_screen_timer = 10.0
	break_screen_label.visible = true
	get_tree().paused = true
	break_timer_running = true
	
	score.text = str(Globals.player1_score) + " - " + str(Globals.player2_score)

func show_win_screen(player: int) -> void:
	get_tree().paused = true
	win_screen_label.text = "THE WINNER IS PLAYER " + str(player)
	win_screen.visible = true	
	pass
