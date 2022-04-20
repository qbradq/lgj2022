extends KinematicBody2D
class_name Enemy


export var walk_speed:float = 50.0


var velocity:Vector2
var facing_left:bool


func _physics_process(delta):
	think(delta)
	velocity += Global.gravity_force * delta
	velocity = move_and_slide(velocity, Vector2.UP)


func think(delta:float):
	pass


func walk():
	if facing_left:
		velocity.x = -walk_speed
	else:
		velocity.x = walk_speed
