extends Area2D

var speed: int = 500

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("props"):
		body._on_bullet_hit()
		queue_free()
	pass # Replace with function body.
