extends Node

var speed: int = 100
@onready var tilemap_container = $TileNode

func _ready():
	if tilemap_container == null:
		push_error("TileMapContainer node NOT found! Please check your scene structure.")
		return

func _process(delta):
	if tilemap_container:
		for tilemap in tilemap_container.get_children():
			if tilemap is TileMap:
				tilemap.position.x += speed * delta
