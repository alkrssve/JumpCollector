extends Node

var max_lives = 4
var lives = max_lives
var coins = 0
var position_lost = false
var jumps = 99
var min_jumps = 0
var item1_price = "10"
var item2_price = "10"
var save_num = 1
var last_save_x = 0
var last_save_y = 0

var jump_positions = []

var canTalk = false
var talkOver = false

var scn
var hud
var shop
var player

func lose_life():
	lives -= 1
	hud.load_hearts()
	if lives <= 0:
		position_lost = true
		player.save_position(last_save_x,last_save_y)
		lives = max_lives
		hud.load_hearts()
		
func lose_jump():
	if jumps > min_jumps:
		jumps -= 1
	hud.load_jumps()
	
func collect_money(coinType):
	if (coinType == 0):
		coins += 1
	if (coinType == 1):
		coins += 5
	if (coinType == 2):
		coins += 10
	if (coinType == 3):
		if jumps <= 20:
			jumps += 1
	hud.load_coins()
	hud.load_jumps()
	
func set_save_position(x,y):
	last_save_x = x
	last_save_y = y

	
