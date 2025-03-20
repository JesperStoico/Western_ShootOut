class_name Player2 extends CharacterBody2D

signal shoot_signal
signal reload_signal
signal player2_dead

@export var speed:int
@export var bullet: PackedScene
@export var shoot_delay: float = 0.3
@export var reload_delay: float = 0.3
@export var max_bullets: int = 6
@export var attacking:bool = false
@export var reloading: bool = false

@onready var marker_2d: Marker2D = $Marker2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var attack_timer: Timer = $AttackTimer
@onready var reload_timer: Timer = $ReloadTimer
@onready var head_area: Area2D = $head_area
@onready var body_area: Area2D = $body_area

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var shoot_sound: AudioStream

var direction: Vector2
var current_bullet_count: int = 6

func _ready() -> void:
	animation_player.play("idle")
	attack_timer.wait_time = shoot_delay
	reload_timer.wait_time = reload_delay
	head_area.area_entered.connect(_take_head_dmg)
	body_area.area_entered.connect(_take_body_dmg)

func _process(_delta: float) -> void:
	if not attacking and not reloading:
		if Input.is_action_just_pressed("shoot_p2") and current_bullet_count > 0:
			attacking = true
			shoot()
	if not reloading and not attacking:
		if Input.is_action_just_pressed("reload_p2") and current_bullet_count < max_bullets:
			reloading = true
			reload()
	pass

func _physics_process(_delta):
	if not attacking and not reloading:
		direction = Input.get_vector("left_p2", "right_p2", "up_p2", "down_p2")
		if direction.length() != 0:
			animation_player.play("walk")
		if direction.length() == 0:
			animation_player.play("idle")
		velocity = direction * speed
		move_and_slide()

func reload() -> void:
	reload_timer.start()
	animation_player.play("reload")
	current_bullet_count += 1
	reload_signal.emit()

func shoot() -> void:
	var b = bullet.instantiate()
	owner.add_child(b)
	b.transform = marker_2d.global_transform
	attack_timer.start()
	animation_player.play("shoot")
	audio_player.set_stream(shoot_sound)
	audio_player.set_pitch_scale(randf_range(0.7, 1.0))
	audio_player.play()
	current_bullet_count -= 1
	shoot_signal.emit()
	pass

func _on_attack_timer_timeout() -> void:
	attacking = false
	pass # Replace with function body.

func _on_reload_timer_timeout() -> void:
	reloading = false
	pass # Replace with function body.

func _take_head_dmg(_body) -> void:
	if _body.is_in_group("bullet"):
		Globals.player1_score += 1
		player2_dead.emit()
		_body.queue_free()

func _take_body_dmg(_body) -> void:
	if _body.is_in_group("bullet"):
		speed -= 10
		_body.queue_free()
		pass # Replace with function body.
