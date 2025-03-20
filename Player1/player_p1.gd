class_name Player1 extends CharacterBody2D

signal shoot_signal
signal reload_signal
signal player1_dead
signal out_of_bullets

@export var initial_speed: int
@export var speed:int
@export var bullet: PackedScene
@export var shoot_delay: float = 0.3
@export var reload_delay: float = 0.3
@export var max_bullets: int = 6
@export var attacking:bool = false
@export var reloading: bool = false
@export var dead: bool = false

@onready var marker_2d: Marker2D = $Marker2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var attack_timer: Timer = $AttackTimer
@onready var reload_timer: Timer = $ReloadTimer
@onready var head_area: Area2D = $head_area
@onready var body_area: Area2D = $body_area

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var shoot_sound: AudioStream

var invurnable_timer: float = 2.0
var invurnable: bool = false
var direction: Vector2
var current_bullet_count: int = 6

func _ready() -> void:
	animation_player.play("idle")
	attack_timer.wait_time = shoot_delay
	reload_timer.wait_time = reload_delay
	head_area.area_entered.connect(_take_head_dmg)
	body_area.area_entered.connect(_take_body_dmg)
	Globals.gui.break_over.connect(next_round)

func _process(_delta: float) -> void:
	if invurnable:
		invurnable_timer -= _delta
		if invurnable_timer <= 0:
			invurnable = false
			invurnable_timer = 2.0
	if not attacking and not reloading and not dead:
		if Input.is_action_just_pressed("shoot_p1") and current_bullet_count > 0:
			attacking = true
			shoot()
	if not reloading and not attacking and not dead:
		if Input.is_action_just_pressed("reload_p1") and current_bullet_count < max_bullets:
			reloading = true
			reload()
	pass

func _physics_process(_delta):
	if not attacking and not reloading and not dead:
		direction = Input.get_vector("left_p1", "right_p1", "up_p1", "down_p1")
		if direction.length() != 0:
			animation_player.play("walk")
		if direction.length() == 0:
			animation_player.play("idle")
		velocity = direction * speed
		move_and_slide()

func next_round() -> void:
	animation_player.play("idle")
	speed = initial_speed
	current_bullet_count = max_bullets
	reload_signal.emit()
	dead = false
	invurnable = true
	pass

func reload() -> void:
	reload_timer.start()
	animation_player.play("reload")
	current_bullet_count += 1
	reload_signal.emit()

func shoot() -> void:	
	var b = bullet.instantiate()
	Globals.map.add_child(b)
	b.global_transform = marker_2d.global_transform
	attack_timer.start()
	animation_player.play("shoot")
	audio_player.set_stream(shoot_sound)
	audio_player.set_pitch_scale(randf_range(0.7, 1.0))
	audio_player.play()
	current_bullet_count -= 1
	if current_bullet_count == 0:
		out_of_bullets.emit()
	shoot_signal.emit()
	pass

func _on_attack_timer_timeout() -> void:
	attacking = false
	pass # Replace with function body.

func _on_reload_timer_timeout() -> void:
	reloading = false
	pass # Replace with function body.

func _take_head_dmg(_body) -> void:
	if _body.is_in_group("bullet") and not invurnable:
		dead = true
		Globals.player2_score += 1
		player1_dead.emit()
		_body.queue_free()
		process_mode = Node.PROCESS_MODE_ALWAYS
		animation_player.play("die")
		await animation_player.animation_finished
		process_mode = Node.PROCESS_MODE_INHERIT

func _take_body_dmg(_body) -> void:
	if _body.is_in_group("bullet") and not invurnable:
		speed -= 10
		_body.queue_free()
		pass # Replace with function body.
