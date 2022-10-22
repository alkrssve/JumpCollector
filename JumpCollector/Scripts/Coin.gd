extends Area2D

export var coinType = 0
signal coin_collected

func _ready():
	if(coinType == 0):
		$AnimatedSprite.animation = "SmallCoin"
	if(coinType == 1):
		$AnimatedSprite.animation = "MediumCoin"
	if(coinType == 2):
		$AnimatedSprite.animation = "BigCoin"
	if(coinType == 3):
		$AnimatedSprite.animation = "Jump"
	

func _on_Coin_body_entered(body):
	if body.is_in_group("Player"):
		if coinType == 3:
			Global.jump_positions.push_back([position.x,position.y])
		emit_signal("coin_collected", coinType)
		queue_free()
