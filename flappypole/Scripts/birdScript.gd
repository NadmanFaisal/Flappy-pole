extends CharacterBody2D

const GRAVITY: float = 1000.0
const JUMP_FORCE: float = -400.0

var bullet_scene = preload("res://Scenes/BulletScene.tscn")

signal bird_out_of_bounds

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	move_and_slide()

	if velocity.y < -150:
		rotation_degrees = -30
	elif velocity.y > 150:   
		rotation_degrees = 30
	else:
		rotation_degrees = 0

	var screen_size = get_viewport_rect().size
	if position.y > screen_size.y or position.y < 0:
		emit_signal("bird_out_of_bounds")
		$BirdOutOfBounds.play()
		_game_over()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		velocity.y = JUMP_FORCE
		print("Bird jumped")
		$BirdBounceAudio.play()  # Play the flap sound

func _game_over() -> void:
	print("Bird died!")
	set_process(false)
	set_physics_process(false)
