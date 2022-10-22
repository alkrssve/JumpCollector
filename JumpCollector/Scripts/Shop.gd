extends Node2D

signal talkEntered
signal talkLeft

func _ready():
	Global.shop = self

func _process(delta):
	if $Item1/Sprite.position.y > 10:
		$Item1/ItemIcon.visible = false
		$Item1/Price.visible = false
		$Item1/s.visible = false
		$Item2/ItemIcon.visible = false
		$Item2/Price.visible = false
		$Item2/s.visible = false
	if Global.talkOver:
		$E.visible = false
		$AnimatedSprite.animation = "idle"

func _on_Item1_mouse_entered():
	$Item1/Sprite.texture = load("res://Sprites/ShopRelated/BuySignBold.png")
		
		
func _on_Item1_mouse_exited():
	$Item1/Sprite.texture = load("res://Sprites/ShopRelated/BuySign.png")


func _on_Item2_mouse_entered():
	$Item2/Sprite.texture = load("res://Sprites/ShopRelated/BuySignBold.png")


func _on_Item2_mouse_exited():
	$Item2/Sprite.texture = load("res://Sprites/ShopRelated/BuySign.png")




func _on_ShopAppear_area_entered(area):
	$Item1/AnimationPlayer.play("PopUp")
	$Item2/AnimationPlayer.play("PopUp")


func _on_ShopAppear_area_exited(area):
	$Item1/AnimationPlayer.play("PopDown")
	$Item2/AnimationPlayer.play("PopDown")


func _on_ShopTalk_area_entered(area):
	$E.visible = true
	emit_signal("talkEntered")


func _on_ShopTalk_area_exited(area):
	$E.visible = false
	$AnimatedSprite.animation = "idle"
	emit_signal("talkLeft")


func _on_AnimationPlayer_animation_finished(anim_name = "PopUp"):
	$Item1/ItemIcon.visible = true
	$Item1/Price.visible = true
	$Item1/s.visible = true
	$Item2/ItemIcon.visible = true
	$Item2/Price.visible = true
	$Item2/s.visible = true
	$Item1/Price.text = Global.item1_price
	$Item2/Price.text = Global.item2_price



func _on_Item1_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		var item = 1
		self.on_click(item)

func _on_Item2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		var item = 2
		self.on_click(item)

func on_click(item):
	if item == 1 and Global.coins >= int($Item1/Price.get_text()):
		Global.max_lives += 2
		Global.lives += 2
		Global.coins -= int($Item1/Price.get_text())
		Global.item1_price = str(int($Item1/Price.get_text()) + 10)
		$Item1/Price.text = Global.item1_price
		Global.hud.load_hearts()
		Global.hud.load_coins()
	if item == 2 and Global.coins >= int($Item2/Price.get_text()):
		Global.min_jumps += 1
		if Global.jumps < Global.min_jumps:
			Global.jumps = Global.min_jumps
		Global.coins -= int($Item2/Price.get_text())
		Global.item2_price = str(int($Item2/Price.get_text()) + 10)
		$Item2/Price.text = Global.item2_price
		Global.hud.load_jumps()
		Global.hud.load_coins()
