extends CharacterBody2D

@export var speed : float = 100
@export var hp = 100

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var sword = $Sprite2D/HitBox
@onready var attackcooldown = $Sprite2D/HitBox/AttackCooldownTimer
@onready var game_start_time = Time.get_ticks_msec()
@onready var healthbar = get_node("%Healthbar")
@onready var experiencebar = get_node("%Experiencebar")
@onready var levellabel = get_node("%LevelLabel")
@onready var levelPanel = get_node("%LevelUp")
@onready var upgradeOptions = get_node("%UpgradeOptions")
@onready var itemOptions = preload("res://item_option.tscn")

var xp = 0
var level = 1
var exp_required = 10


func _physics_process(_delta):
	
	update_healthbar()
	#Getting inputs from the player
	var horizontal_direction = Input.get_axis("left", "right")
	var vertical_direction = Input.get_axis("up", "down")
	
	#Switching direction from left to right
	if not ap.current_animation == "attack1":
		if horizontal_direction != 0:
			if Input.get_action_raw_strength("left"):
				sprite.scale.x = -1
			else:
				sprite.scale.x = 1
		
	#Vector directions
	velocity.x = speed * horizontal_direction
	velocity.y = speed * vertical_direction
		
	move_and_slide()
		
	#Playing the animations
	animations(horizontal_direction, vertical_direction)
	

#Function for changing animations
func animations(horizontal, vertical):

	if not ap.current_animation == "attack1":
		if horizontal == 0 and vertical == 0:
			ap.play("idle")
		else:
			ap.play("run")

func _process(_delta):
	$CanvasLayer/Control/Label.text =  get_time()
	if Input.is_key_pressed(KEY_J) and attackcooldown.is_stopped():
		if not ap.current_animation == "attack1":
			ap.play("attack1")
			attackcooldown.start()

func _on_hurt_box_hurt(damage):
	hp -= damage

func update_healthbar():
	healthbar.value = hp
	
	if hp >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
		
		

func update_experiencebar():
	experiencebar.value = xp
	experiencebar.max_value = exp_required

func increase_xp(earnedxp):
	exp_required = calculate_experiencecap()
	xp += earnedxp
	print("earnedxp")
	print(xp)
	print(exp_required)
	if xp >= exp_required:
		xp = 0
		print("levelup")
		level += 1
		levelup()
	update_experiencebar()

func calculate_experiencecap():
	var exp_cap = level
	if level < 10:
		exp_cap = 50
	elif level < 20:
		exp_cap = level*5
	elif level < 40:
		exp_cap = 95 * (level-19)*8
	else:
		exp_cap = 255 * (level-39)*12
	
	return exp_cap

func get_time():
	var current_time = Time.get_ticks_msec() - game_start_time
	var minutes = current_time/1000/60
	if minutes < 10:
		minutes = "0"+str(minutes)
	var seconds = current_time/1000%60
	if seconds < 10:
		seconds = "0"+str(seconds)
	return(str(minutes)+":"+str(seconds))

func levelup():
	levellabel.text = str("lvl", level)
	var tween = levelPanel.create_tween()
	tween.tween_property(levelPanel,"position", Vector2(476,150),0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	levelPanel.visible = true
	var options = 0
	var optionsmax = 3
	while options < optionsmax:
		var option_choice = itemOptions.instantiate()
		upgradeOptions.add_child(option_choice)
		options += 1
	
	get_tree().paused = true

func upgrade_character(upgrade):
	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	levelPanel.visible = false
	levelPanel.position = Vector2(626,-480)
	get_tree().paused = false
