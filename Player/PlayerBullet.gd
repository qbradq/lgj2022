extends Area2D


export var velocity:Vector2 = Vector2.RIGHT * 400.0


func _physics_process(delta):
	global_position += velocity * delta
