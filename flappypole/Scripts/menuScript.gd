extends Node2D

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
func _ready():
	$IntroMusic.play()
	$IntroMusic.stream.loop = true


func _on_tuto_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/TutorialScene.tscn")
