extends CanvasLayer

@onready var score_label = $Score
@onready var replay = $Replay
@onready var home = $HomeButton

func _ready():
	replay.pressed.connect(_replay_pressed)
	home.pressed.connect(_home_button_pressed)

func set_score(score: int):
	score_label.text = "%d" % score

func _replay_pressed():
	get_tree().reload_current_scene()

func _home_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/MenuScene.tscn")
