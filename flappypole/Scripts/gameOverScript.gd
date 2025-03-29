extends CanvasLayer

@onready var score_label = $Score
@onready var replay = $Replay

func _ready():
	replay.pressed.connect(_replay_pressed)

func set_score(score: int):
	score_label.text = "%d" % score

func _replay_pressed():
	get_tree().reload_current_scene()
