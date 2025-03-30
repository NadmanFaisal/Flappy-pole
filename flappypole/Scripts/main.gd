extends Node2D

@onready var bullet_scene = preload("res://Scenes/BulletScene.tscn")
@onready var pipe_scene = preload("res://Scenes/PipeScene.tscn")
@onready var bird = $Bird
@onready var score = $ScoreHUD
@onready var game_over_scene = preload("res://Scenes/GameOverScene.tscn")
@onready var speed_timer = $SpeedTimer
@onready var pipe_speed_timer = $PipeTimer

var bullet_speed := -200.0
var pipe_speed := 800

var max_bullet_spawn_time = 2
var bullet_spawn_time = 2
var min_bullet_spawn_time = 0.5

func _ready() -> void:
	$ColorRect.modulate.a = 0.0
	await get_tree().create_timer(15.0).timeout
	call_deferred("fade_in_evening_filter")

	$Bird.connect("bird_out_of_bounds", Callable(self, "game_over"))

	$BulletSpawnTimer.wait_time = 2.0
	$BulletSpawnTimer.autostart = true
	$BulletSpawnTimer.one_shot = false
	$BulletSpawnTimer.start()
	$WhilePlayMusic.play()
	$WhilePlayMusic.stream.loop = true
	
	speed_timer.wait_time = 5.0
	speed_timer.autostart = true
	speed_timer.connect("timeout", Callable(self, "_on_speed_timer_timeout"))
	speed_timer.start()
	

	pipe_speed_timer.wait_time = 15.0
	pipe_speed_timer.autostart = true
	pipe_speed_timer.connect("timeout", Callable(self, "_on_pipe_speed_timer_timeout"))
	pipe_speed_timer.start()

func _on_BulletSpawnTimer_timeout() -> void:
	update_bullet_spawn_time()
	spawn_bullet()

func _on_pipe_speed_timer_timeout():
	pipe_speed += 200
	$Pipe.set_speed(pipe_speed)
	print("Pipe speed increased:", bullet_speed)

func update_bullet_spawn_time() -> void:
	# Adjust spawn time dynamically based on score
	bullet_spawn_time = max_bullet_spawn_time - (($ScoreHUD.score_time / 5) * 0.1)
	if bullet_spawn_time < min_bullet_spawn_time:
		bullet_spawn_time = min_bullet_spawn_time
	$BulletSpawnTimer.wait_time = bullet_spawn_time
	print("Bullets spawn every:", bullet_spawn_time, "seconds")

func _on_speed_timer_timeout():
	bullet_speed -= 25
	print("Bullet speed increased:", bullet_speed)

func spawn_bullet() -> void:
	if not is_instance_valid(bird):
		return

	if $Pipe.is_bird_touching_any_pipe(bird):
		print("Bird is touching a pipe — safe zone.")
		return
	else:
		print("Bird is not inside the pipes.")

	var bullet = bullet_scene.instantiate()
	bullet.position = Vector2(1100, bird.position.y)
	add_child(bullet)
	bullet.connect("bird_hit", Callable(self, "game_over"))
	bullet.set_speed(bullet_speed)

func game_over():
	print("Game Over!")
	bird._game_over()
	score.stop_score()

	$BulletSpawnTimer.stop()
	
	for child in get_children():
		if child.scene_file_path == bullet_scene.resource_path:
			child.set_physics_process(false)
		if child.scene_file_path == pipe_scene.resource_path:
			child.set_process(false)
	
	var game_over = game_over_scene.instantiate()
	add_child(game_over)
	var final_score = int($ScoreHUD.score_time)
	game_over.set_score(final_score)

func fade_in_evening_filter():
	while true:
		var tween = create_tween()

		# Fade in (evening)
		tween.tween_property($ColorRect, "modulate:a", 0.4, 2.0)
		await tween.finished
		await get_tree().create_timer(20.0).timeout  # Stay orange

		# Fade out (day)
		tween = create_tween()  # New tween after first completes
		tween.tween_property($ColorRect, "modulate:a", 0.0, 2.0)
		await tween.finished
		await get_tree().create_timer(15.0).timeout  # Stay clear
