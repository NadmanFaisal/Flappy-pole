extends CanvasLayer

var score_time := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	score_time += delta
	$Label.text = "Score: %d" % int(score_time)

func reset_score():
	score_time = 0.0

func stop_score():
	set_process(false)
