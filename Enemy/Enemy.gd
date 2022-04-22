extends KinematicBody2D
class_name Enemy


const IFRAMES = 0.2


export var walk_speed:float = 50.0
export var hit_points:int = 1
export var dead:float = false

var velocity:Vector2
var facing_left:bool
var iframes:float


func _physics_process(delta):
	if dead:
		return
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


func turn_off():
	dead = true
	collision_layer = 0
	collision_mask = 0
	$Sprite.visible = false
	$LeftWallRayCast.collision_mask = 0
	$RightWallRayCast.collision_mask = 0
	$LeftFloorRayCast.collision_mask = 0
	$RightFloorRayCast.collision_mask = 0
	$BounceArea.collision_layer = 0
	$BounceArea.collision_mask = 0
	$HurtArea.collision_layer = 0
	$HurtArea.collision_mask = 0


func die():
	turn_off()
	$DieParticles.emitting = true
	$Timer.start(0.5)
	yield($Timer, "timeout")
	queue_free()


func get_bounced_on(from):
	turn_off()
	$SquishParticles.emitting = true
	$Timer.start(0.5)
	yield($Timer, "timeout")
	queue_free()


func _on_HurtArea_body_entered(body):
	body.hurt(1, global_position)
