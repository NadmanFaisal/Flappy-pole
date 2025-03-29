extends Node2D

@onready var bullet_scene = preload("res://Scenes/BulletScene.tscn")
@onready var bird = $Bird
@onready var score = $ScoreHUD


func _ready() -> void:
	$Bird.connect("bird_out_of_bounds", Callable(self, "game_over"))

	$BulletSpawnTimer.wait_time = 2.0
	$BulletSpawnTimer.autostart = true
	$BulletSpawnTimer.one_shot = false
	$BulletSpawnTimer.start()

func _on_BulletSpawnTimer_timeout() -> void:
	spawn_bullet()

func spawn_bullet() -> void:
	if not is_instance_valid(bird):
		return

	var bullet = bullet_scene.instantiate()
	bullet.position = Vector2(1100, bird.position.y)
	add_child(bullet)
	bullet.connect("bird_hit", Callable(self, "game_over"))
	
func game_over():
	print("Game Over!")
	bird._game_over()
	score.stop_score()

	$BulletSpawnTimer.stop()
