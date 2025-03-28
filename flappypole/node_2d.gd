extends CharacterBody2D

const GRAVITY: float = 1000.0
const JUMP_FORCE: float = -400.0

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	move_and_slide()
	
	if velocity.y < -150:
		$Bird.play("tiltUp")
	elif velocity.y > 150:   
		$Bird.play("tiltDown")
	else:
		$Bird.play("tiltFlat")

	
	var screen_size = get_viewport_rect().size
	if position.y > screen_size.y or position.y < 0:
		_game_over()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		velocity.y = JUMP_FORCE
		print("Bird jumped")

func _game_over() -> void:
	print("Bird died!")
	set_process(false)
	set_physics_process(false)
