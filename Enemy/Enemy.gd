extends KinematicBody2D
class_name Enemy


export var walk_speed:float = 50.0


var velocity:Vector2
var facing_left:bool
var iframes:float


func _physics_process(delta):
	iframes -= delta
	iframes = max(0.0, iframes)
	if iframes:
		$Sprite.material.set_shader_param("white_progress", 1.0)
	else:
		$Sprite.material.set_shader_param("white_progress", 0.0)
	think(delta)
	$Sprite.flip_h = facing_left
	velocity += Global.gravity_force * delta
	velocity = move_and_slide(velocity, Vector2.UP)


func think(delta:float):
	pass


func walk():
	if facing_left:
		velocity.x = -walk_speed
	else:
		velocity.x = walk_speed
	$AnimationPlayer.play("Walk")


func hurt(damage:int):
	if iframes:
		return
	iframes += 0.4
	$AnimationPlayer.play("Hurt")
