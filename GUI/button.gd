extends Button

var blink_time = 0.5  # Speed of blinking
var is_hovered = false

func _ready():
	grab_focus()
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)

func _on_mouse_entered():
	is_hovered = true

func _on_mouse_exited():
	is_hovered = false
	modulate = Color(1, 1, 1)  # Reset color

func _process(_delta):
	if is_hovered:
		var glow = sin(Time.get_ticks_msec() * 0.005) * 0.5 + 0.5
		modulate = Color(1, 1, 1, glow)  # Blinking effect

func _on_pressed() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.
