class_name Camera extends Camera2D

@export var shake_intensity: float = 10.0  # How strong the shake is
@export var shake_duration: float = 0.3  # How long the shake lasts

func _ready() -> void:
	Globals.player1.player1_dead.connect(shake)
	Globals.player2.player2_dead.connect(shake)

func shake():
	var tween = create_tween()
	tween.set_loops()  # Keep looping

	for _i in range(int(shake_duration * 30)):  # 30 iterations per second
		var offset_x = randf_range(-shake_intensity, shake_intensity)
		var offset_y = randf_range(-shake_intensity, shake_intensity)
		tween.tween_property(self, "offset", Vector2(offset_x, offset_y), 0.03)

	await get_tree().create_timer(shake_duration).timeout  # Wait for shake duration
	tween.stop()  # Stop the tween
	offset = Vector2.ZERO  # Reset camera position
