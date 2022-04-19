extends KinematicBody2D


var walk_force:Vector2 = Vector2.RIGHT * 600.0
var walk_force_max:Vector2 = Vector2.RIGHT * 150.0
var friction_force:Vector2 = Vector2.LEFT * 900.0
var jump_force:Vector2 = Vector2.UP * 350.0
var double_jump_force:Vector2 = Vector2.UP * 250.0
var gravity_force:Vector2 = Vector2.DOWN * 1000.0
var terminal_velocity:Vector2 = Vector2.DOWN * 450.0
var wall_slide_max_velocity:Vector2 = Vector2.DOWN * 75.0
var wall_jump_force:Vector2 = Vector2.UP * 350.0 + Vector2.RIGHT * 300.0


var velocity:Vector2
var can_double_jump:bool
var is_wall_slide_left:bool
var is_wall_slide_right:bool
var is_wall_slide:bool


func _input(event):
	if event.is_action_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = jump_force.y
			can_double_jump = true
		elif is_wall_slide:
			velocity.y = wall_jump_force.y
			if is_wall_slide_left:
				velocity.x += wall_jump_force.x
			else:
				velocity.x -= wall_jump_force.x
		elif can_double_jump:
			velocity.y = double_jump_force.y
			can_double_jump = false


func _physics_process(delta):
	# Input
	var invec := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# Movement
	velocity.x += invec.x * walk_force.x * delta
	if velocity.x > walk_force_max.x:
		velocity.x = walk_force_max.x
	if velocity.x < -walk_force_max.x:
		velocity.x = -walk_force_max.x
	# Gravity
	velocity += gravity_force * delta
	if is_wall_slide:
		if velocity.y > wall_slide_max_velocity.y:
			velocity.y = wall_slide_max_velocity.y
	else:
		if velocity.y > terminal_velocity.y:
			velocity.y = terminal_velocity.y
	# Apply motion
	velocity = move_and_slide(velocity, Vector2.UP)
	# Friction
	if invec.x == 0.0 and is_on_floor():
		if velocity.x > 0.0:
			velocity.x += friction_force.x
			if velocity.x < 0.0:
				velocity.x = 0.0
		if velocity.x < 0.0:
			velocity.x -= friction_force.x
			if velocity.x > 0.0:
				velocity.x = 0.0
	# Check for wall slides
	is_wall_slide_left = $LeftWallRay.is_colliding()
	is_wall_slide_right = $RightWallRay.is_colliding()
	is_wall_slide = is_wall_slide_left or is_wall_slide_right
	# Motion animation
	if not is_on_floor():
		$AnimationPlayer.play("Jump")
	else:
		if velocity.x != 0.0:
			$AnimationPlayer.play("Run")
		else:
			$AnimationPlayer.play("Idle")
	if invec.x < 0.0:
		$Sprite.flip_h = true
	elif invec.x > 0.0:
		$Sprite.flip_h = false
	# Wall slide animation
	$WallSlideParticles.emitting = is_wall_slide and not is_on_floor() and velocity.y > 0.0
