class_name Cactus extends StaticBody2D

var health: int = 6

func take_damage() -> void:
	health -= 1
	if health <= 0:
		queue_free()

func _on_bullet_hit():
	take_damage()
