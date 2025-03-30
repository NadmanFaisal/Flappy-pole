extends Node2D

func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MenuScene.tscn")
	
func _ready():
	$IntroMusic.play()
	$IntroMusic.stream.loop = true
	
