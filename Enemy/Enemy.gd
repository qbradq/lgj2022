extends KinematicBody2D
class_name Enemy


const IFRAMES = 0.2


export var walk_speed:float = 50.0
export var hit_points:int = 1


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
	iframes = IFRAMES
	hit_points -= damage
	if hit_points <= 0:
		die()


func die():
	queue_free()



func _on_StompArea_body_entered(body):
	print("bounce")
