class_name Cactus extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var health: int = 6

func _ready() -> void:
	animation_player.play("idle")

func take_damage() -> void:
	animation_player.play("take_damage")
	health -= 1
	await animation_player.animation_finished
	if health == 4:
		animation_player.play("dmg_takend_1")
		await animation_player.animation_finished
	if health == 2:
		animation_player.play("dmg_takend_2")
		await animation_player.animation_finished
	if health <= 0:
		collision_shape_2d.disabled = true
		animation_player.play("die")
		await animation_player.animation_finished
		queue_free()

func _on_bullet_hit():
	take_damage()
