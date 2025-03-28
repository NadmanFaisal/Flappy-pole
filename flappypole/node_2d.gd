extends CharacterBody2D

# Constants
const GRAVITY: float = 1000.0
const JUMP_FORCE: float = -400.0

func _physics_process(delta: float) -> void:
	# Apply gravity
	velocity.y += GRAVITY * delta

	# Move the bird
	move_and_slide()
	
	# Check if bird is out of screen vertically
	var screen_size = get_viewport_rect().size

	if position.y > screen_size.y or position.y < 0:
		_game_over()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		velocity.y = JUMP_FORCE
		print("Bird jumped")

func _game_over() -> void:
	print("Bird died!")
	# You can disable movement, show game over UI, etc.
	set_process(false)
	set_physics_process(false)
