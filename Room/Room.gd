extends Node


func _ready():
	# Set player camera bounds
	if $Contents/Player:
		var camera = $Contents/Player/Camera2D
		var map_limits = $Background/TileMap.get_used_rect()
		var map_cellsize = $Background/TileMap.cell_size
		camera.limit_left = map_limits.position.x * map_cellsize.x
		camera.limit_right = map_limits.end.x * map_cellsize.x
		camera.limit_top = map_limits.position.y * map_cellsize.y
		camera.limit_bottom = map_limits.end.y * map_cellsize.y
