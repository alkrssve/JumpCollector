extends KinematicBody2D

var velocity = Vector2()
export var direction = 1

func _ready():
	if direction == -1:
		$AnimatedSprite.flip_h = true
	$FloorCheck.position.x = $CollisionShape2D.shape.get_extents().x * direction
	
func _physics_process(delta):
	
	if is_on_wall() or not $FloorCheck.is_colliding():
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$FloorCheck.position.x = $CollisionShape2D.shape.get_extents().x * direction
	
	velocity.y += 20
	
	velocity.x = 50 * direction
	
	velocity = move_and_slide(velocity, Vector2.UP)




func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		body.damage(position.x)
