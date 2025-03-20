extends Control

@onready var player_1_bullet_warning: Label = $Player1_bullet_warning
@onready var player_2_bullet_warning: Label = $Player2_bullet_warning

var tween:Tween

func _ready() -> void:
	Globals.player1.out_of_bullets.connect(show_p1_text)
	Globals.player2.out_of_bullets.connect(show_p2_text)
	Globals.player1.reload_signal.connect(hide_p1_text)
	Globals.player2.reload_signal.connect(hide_p2_text)
	
	player_1_bullet_warning.visible = false
	player_2_bullet_warning.visible = false
	blink_warning_text()

func hide_p2_text() -> void:
	player_2_bullet_warning.visible = false

func hide_p1_text() -> void:
	player_1_bullet_warning.visible = false

func show_p1_text() -> void:
	player_1_bullet_warning.visible = true

func show_p2_text() -> void:
	player_2_bullet_warning.visible = true

func blink_warning_text() -> void:
	tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "modulate:a", 0, 0.5)
	tween.tween_property(self, "modulate:a", 1, 0.5)
