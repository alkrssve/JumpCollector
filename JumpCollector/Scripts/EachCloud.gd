extends Sprite

func _ready():
	position.x = rand_range(-1200,700)
	position.y = rand_range(-250,500)

func _process(delta):
	if position.x > 800:
		position.x = -1200
	
