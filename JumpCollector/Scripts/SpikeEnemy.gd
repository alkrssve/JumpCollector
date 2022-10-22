extends KinematicBody2D

export var speed_modifier = 1.0
export var reverse = true
export var vertical = true
export var distance = 50

var start_position_x = position.x
var start_position_y = position.y

var direction_check = false

func _ready():
	start_position_x = self.get_position().x
	start_position_y = self.get_position().y
	if reverse:
		direction_check = true

func _physics_process(delta):
	if vertical == true:
		if (position.y > start_position_y + distance):
			direction_check = false
		if (position.y < start_position_y - distance):
			direction_check = true
	else:
		if (position.x > start_position_x + distance):
			direction_check = false
		if (position.x < start_position_x - distance):
			direction_check = true
	if direction_check:
		if vertical == true:
			position.y += speed_modifier
		else:
			position.x += speed_modifier
	else:
		if vertical == true:
			position.y -= speed_modifier
		else: 
			position.x -= speed_modifier


func _on_DamageCheck_body_entered(body):
	if body.is_in_group("Player"):
		body.damage(position.x)
