extends CanvasLayer


func _ready():
	load_hearts()
	load_coins()
	load_jumps()
	Global.hud = self

func load_hearts():
	$Life/HealthFull.rect_size.x = (Global.lives/2 * 8)
	if Global.lives % 2 == 0:
		$Life/HealthHalf.rect_size.x = 0
	if Global.lives % 2 == 1:
		$Life/HealthHalf.rect_size.x = 8
		
	$Life/HealthEmpty.rect_size.x = ((Global.max_lives - Global.lives)/2 * 8)
		
	$Life/HealthHalf.rect_position.x = $Life/HealthFull.rect_position.x + $Life/HealthFull.rect_size.x * $Life/HealthFull.rect_scale.x
	$Life/HealthEmpty.rect_position.x = $Life/HealthHalf.rect_position.x + $Life/HealthHalf.rect_size.x * $Life/HealthHalf.rect_scale.x

func load_coins():
	$Money.text = String(Global.coins)

func load_jumps():
	$Jumps/JumpCount.text = String(Global.jumps)
