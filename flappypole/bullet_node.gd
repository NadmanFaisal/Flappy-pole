extends CharacterBody2D

const SPEED: float = -200.0  # Negative to move left
var half_screen_x: float

@onready var anim = $AnimatedSprite2D  # Reference to AnimatedSprite2D

func _ready() -> void:
	var screen_size = get_viewport_rect().size
	half_screen_x = screen_size.x * 0.5  # Get 1/2 of the screen width

func _physics_process(delta: float) -> void:
	# Move left
	velocity.x = SPEED

	# Move the character
	move_and_slide()

	# Change animation when reaching a quarter of the screen
	if position.x <= half_screen_x:
		$AnimatedSprite2D.frame = 1  # Replace with your animation name

	# Stop at the left edge
	if position.x <= 0:
		velocity.x = 0
		position.x = 0
		print("Reached the left edge!")
