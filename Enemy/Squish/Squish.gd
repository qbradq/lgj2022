extends Enemy
class_name EnemySquish


func _ready():
	facing_left = true


func think(delta:float):
	if $LeftWallRayCast.is_colliding() or $RightWallRayCast.is_colliding():
		facing_left = not facing_left
	elif $LeftFloorRayCast.is_colliding() == false or $RightFloorRayCast.is_colliding() == false:
		facing_left = not facing_left
	walk()
