extends Area2D

var speed: int = 500

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_head"):
		print("Hit player ", body.name)
		body._on_bullet_hit()
		queue_free()
	if body.is_in_group("props"):
		print("You hit a prop ", body.name)
		body._on_bullet_hit()
		queue_free()
	if body.is_in_group("player_body"):
		print("hit in body")
	pass # Replace with function body.
