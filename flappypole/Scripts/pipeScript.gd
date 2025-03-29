extends Node2D

const MOVE_SPEED = 800.0
const MIN_GROUP = 2
const MAX_GROUP = 3
const GROUP_PIPE_SPACING = 300  # spacing between groups
const OFFSCREEN_X = -12000  # pipe fully off-screen before being removed

var top_pipe_groups = []
var bottom_pipe_groups = []
var top_positions = []
var bottom_positions = []

var active_groups = []
var last_spawn_x = 0  # used to control spacing, not needed for now but kept for future use

func _ready():
	for i in range(1, 4):  # TopPipeGroup1 to 3, BottomPipeGroup1 to 3
		var top_group = get_node("TopPipeGroup%d" % i)
		var bottom_group = get_node("BottomPipeGroup%d" % i)

		top_pipe_groups.append(top_group)
		top_positions.append(top_group.position)

		bottom_pipe_groups.append(bottom_group)
		bottom_positions.append(bottom_group.position)

		top_group.visible = false
		bottom_group.visible = false

	# Spawn the first group
	spawn_group()

func _process(delta):
	var to_remove = []

	# Move each active pipe group
	for group in active_groups:
		group.position.x -= MOVE_SPEED * delta
		if group.position.x < OFFSCREEN_X:
			group.visible = false
			to_remove.append(group)

	for group in to_remove:
		active_groups.erase(group)

	# Spawn a new group when there's room (distance-based)
	if active_groups.size() == 0 or (active_groups[-1].position.x <= get_viewport_rect().size.x - GROUP_PIPE_SPACING):
		if active_groups.size() < 10:
			spawn_group()

func spawn_group():
	var use_top = randf() < 0.5
	var source_list = top_pipe_groups if use_top else bottom_pipe_groups
	var source_positions = top_positions if use_top else bottom_positions

	spawn_pipe_group(source_list, source_positions)

func spawn_pipe_group(group_list, position_list):
	var screen_width = get_viewport_rect().size.x

	# Get only non-visible (available) pipe groups
	var available = []
	for group in group_list:
		if not group.visible:
			available.append(group)

	if available.size() < MIN_GROUP:
		return  # Not enough to spawn a full group

	var group_size = randi() % (min(MAX_GROUP, available.size()) - MIN_GROUP + 1) + MIN_GROUP
	available.shuffle()

	for i in range(group_size):
		var group = available[i]
		var original_pos = position_list[group_list.find(group)]
		var spacing_x = i * GROUP_PIPE_SPACING
		group.position = original_pos + Vector2(screen_width + spacing_x, 0)
		group.visible = true
		active_groups.append(group)

func is_bird_touching_any_pipe(bird: CharacterBody2D) -> bool:
	for group in top_pipe_groups + bottom_pipe_groups:
		if not group.visible:
			continue

		if group.has_overlapping_bodies():
			var overlaps = group.get_overlapping_bodies()
			if bird in overlaps:
				return true

	return false
