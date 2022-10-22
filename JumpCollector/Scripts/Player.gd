extends KinematicBody2D

var MOVE_SPEED = 100
const JUMP_FORCE = 225
const GRAVITY = 15
const MAX_FALL_SPEED = 500

var jump_max = Global.jumps
var jump_count = 0

var player_last_ground_position_x = 0
var player_last_ground_position_y = 0

onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite
onready var timer = $Timer

var velocity = Vector2(0,0)
var y_velo = 0

var crouched = false
var facing_right = false

var saveStone_anim_player
var previous_SaveStone_anim_player
var shop_anim_sprite
var stone_hover = false
var save_finish = true

var invincible = false

var current_save_position = 1
var previous_save
var not_previous = false

var talk_zone = false

var cursor = load("res://Sprites/Cursor.png")

var jump_replace = preload("res://Coin.tscn")

func _ready():
	Global.player = self
	Input.set_custom_mouse_cursor(cursor)
	saveStone_anim_player = get_parent().get_node("SaveStones/SaveStone1/AnimationPlayer")
	previous_SaveStone_anim_player = get_parent().get_node("SaveStones/SaveStone1/AnimationPlayer")
	
func _physics_process(delta):
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	if Input.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
		
	if Input.is_action_pressed("speed_up") && crouched == false:
		MOVE_SPEED = 175
		$AnimationPlayer.playback_speed = 2
	if Input.is_action_just_released("speed_up"):
		MOVE_SPEED = 100
		$AnimationPlayer.playback_speed = 1
		
	var move_dir = 0
	if Input.is_action_pressed("right"):
		move_dir += 1
		velocity.x = 1
	elif Input.is_action_pressed("left"):
		move_dir -= 1
		velocity.x = -1
		
	move_and_slide(Vector2(velocity.x * MOVE_SPEED, y_velo), Vector2(0, -1))
	
	velocity.x = lerp(velocity.x,0,0.5)
	
	var grounded = is_on_floor()
	if grounded:
		jump_count = 0
		jump_max = Global.jumps	
	
	y_velo += GRAVITY
	if jump_count<jump_max:
		if Input.is_action_just_pressed("jump"):
			y_velo = -JUMP_FORCE
			jump_count += 1
			Global.lose_jump()
	
	if Input.is_action_just_released("jump") && y_velo < 0:
		y_velo = 0
	
	if grounded and y_velo >= 5:
		y_velo = 5
	if y_velo > MAX_FALL_SPEED:
		y_velo = MAX_FALL_SPEED
		
	if grounded and Input.is_action_pressed("crouch"):
		crouched = true
		MOVE_SPEED = 25
	if Input.is_action_just_released("crouch"):
		crouched = false
		MOVE_SPEED = 100

	if facing_right and move_dir > 0:
		flip()
	if !facing_right and move_dir < 0:
		flip()
	
	if grounded:
		if crouched:
			play_anim("Crouched")
		elif move_dir == 0 || is_on_wall():
			play_anim("Idle")
		else:
			play_anim("Walking")
	else:
		if y_velo < 0:
			play_anim("Jumping")
		elif y_velo > 0:
			play_anim("Falling")
			
	if stone_hover and Input.is_action_just_pressed("interact"):
		saveStone_anim_player.play("Save")
		Global.set_save_position(position.x,position.y)
		for pos in Global.jump_positions:
			var jump_instance = jump_replace.instance()
			jump_instance.connect("body_entered", self, "_on_coin_body_entered")
			jump_instance.connect("coin_collected", self, "_on_coin_collected")
			jump_instance.coinType = 3
			jump_instance.position.x = pos[0]
			jump_instance.position.y = pos[1]
			get_parent().add_child(jump_instance)
		Global.jump_positions = []
		#Global.jumps = Global.min_jumps
		#Global.hud.load_jumps()
		if not_previous:
			previous_SaveStone_anim_player.play("Off")
			not_previous = false
	
	if talk_zone and Input.is_action_just_pressed("interact"):
		Global.canTalk = true
		shop_anim_sprite = get_parent().get_node("Shop/AnimatedSprite")
		shop_anim_sprite.animation = "talk"
		
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var danger = get_parent().get_node("Environment/Danger")
		if collision.collider == danger && invincible == false:
			Global.lose_life()
			set_modulate(Color(0,0.0,0.0,0.3))
			invincible = true
			$Damage.start()
			
		
		
func flip():
	facing_right = !facing_right
	sprite.flip_h = !sprite.flip_h
		
func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)


func _on_coin_collected(coin_type):
	Global.collect_money(coin_type)
	
	
func _on_Fallout_area_entered(area):
	position.x = player_last_ground_position_x
	position.y = player_last_ground_position_y
	Global.lose_life()
	if Global.lives == 0:
		get_tree().reload_current_scene()
		
func damage(var enemyposx):
	if invincible == false:
		Global.lose_life()
		invincible = true
		set_modulate(Color(0,0.0,0.0,0.3))
		y_velo = JUMP_FORCE
		if position.x < enemyposx:
			velocity.x = -10
		elif position.x >= enemyposx:
			velocity.x = 10
	
		Input.action_release("move_left")
		Input.action_release("move_right")
	
		$Damage.start()
	


func _on_Timer_timeout():
	if is_on_floor():
		player_last_ground_position_x = position.x
		player_last_ground_position_y = position.y
		
func _on_Damage_timeout():
	set_modulate(Color(1,1,1,1))
	invincible = false


func _on_SaveStone_saveFinished(Anim_Finished):
	save_finish = true


func _on_SaveStone_area_entered(area):
	stone_hover = true
	previous_save = current_save_position
	yield(get_tree().create_timer(0.01), "timeout")
	saveStone_anim_player = get_parent().get_node(str("SaveStones/SaveStone", current_save_position, "/AnimationPlayer"))
	previous_SaveStone_anim_player = get_parent().get_node(str("SaveStones/SaveStone", previous_save, "/AnimationPlayer"))
	if !save_finish:
		saveStone_anim_player.play("On")
	if previous_save != current_save_position:
		not_previous = true
		
func _on_SaveStone_area_exited(area):
	stone_hover = false
	
func _on_SaveStone_saveEnter(save_num):
	current_save_position = save_num
	
func save_position(x,y):
	position.x = x
	position.y = y



func _on_Shop_talkEntered():
	talk_zone = true


func _on_Shop_talkLeft():
	talk_zone = false

