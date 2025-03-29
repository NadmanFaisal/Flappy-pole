extends Node2D

const MOVE_SPEED = 1000.0  # constant speed
const MIN_GROUP = 4
const MAX_GROUP = 9
const SPAWN_INTERVAL = 1.0  # in seconds
const OFFSCREEN_X = -150  # pipe disappears after crossing left edge (adjust as needed)

var top_pipes = []
var bottom_pipes = []
var top_positions = []
var bottom_positions = []

var active_pipes = []
var time_since_last_spawn = 0.0

func _ready():
	for i in range(1, 6):
		var top_pipe = get_node("TopPipe%d" % i)
		var bottom_pipe = get_node("BottomPipe%d" % i)

		top_pipes.append(top_pipe)
		top_positions.append(top_pipe.position)

		bottom_pipes.append(bottom_pipe)
		bottom_positions.append(bottom_pipe.position)

		top_pipe.visible = false
		bottom_pipe.visible = false

func _process(delta):
	var pipes_to_remove = []

	# Move all active pipes
	for pipe in active_pipes:
		pipe.position.x -= MOVE_SPEED * delta
		if pipe.position.x < OFFSCREEN_X:
			pipe.visible = false
			pipe.position = get_original_position(pipe)
			pipes_to_remove.append(pipe)

	# Safely remove them after loop
	for pipe in pipes_to_remove:
		active_pipes.erase(pipe)

	# Spawn new pipes on timer
	time_since_last_spawn += delta
	if time_since_last_spawn >= SPAWN_INTERVAL:
		spawn_group()
		time_since_last_spawn = 0.0

func spawn_group():
	spawn_pipe_group(top_pipes, top_positions)
	spawn_pipe_group(bottom_pipes, bottom_positions)

func spawn_pipe_group(pipe_list, position_list):
	var max_available = min(MAX_GROUP, pipe_list.size())
	var group_size = randi() % (max_available - MIN_GROUP + 1) + MIN_GROUP

	var shuffled = pipe_list.duplicate()
	shuffled.shuffle()

	var screen_width = get_viewport_rect().size.x  # ✅ define screen width here

	for i in range(group_size):
		var pipe = shuffled[i]
		var original_pos = position_list[pipe_list.find(pipe)]
		var spacing_x = i * randf_range(80, 140)
		pipe.position = original_pos + Vector2(screen_width + spacing_x, 0)
		pipe.visible = true
		active_pipes.append(pipe)



func get_original_position(pipe):
	if top_pipes.has(pipe):
		return top_positions[top_pipes.find(pipe)]
	elif bottom_pipes.has(pipe):
		return bottom_positions[bottom_pipes.find(pipe)]
	return Vector2.ZERO
