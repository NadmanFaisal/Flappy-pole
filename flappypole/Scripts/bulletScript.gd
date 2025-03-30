extends CharacterBody2D

var SPEED: float = -200.0
var half_screen_x: float

@onready var anim = $AnimatedSprite2D

func _ready() -> void:
	var screen_size = get_viewport_rect().size
	half_screen_x = screen_size.x * 0.5
	$RPGAudio.play()  # Play the RPG sound


func _physics_process(delta: float) -> void:
	velocity.x = SPEED
	move_and_slide()

	if position.x <= half_screen_x:
		$AnimatedSprite2D.frame = 1

	if position.x <= 0:
		print("Reached the left edge!")
		queue_free()  # Removes the bullet from the scene


func _on_area_entered(area: Area2D) -> void:
	pass

signal bird_hit

func _on_Hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Bird":
		print("Bird hit!")
		emit_signal("bird_hit")
		body._game_over()
		bullet_game_over()
		$CollisionAudio.play()

func bullet_game_over() -> void:
	print("Bullet collided with the bird!")
	set_process(false)
	set_physics_process(false)

func set_speed(new_speed: float) -> void:
	SPEED = new_speed
