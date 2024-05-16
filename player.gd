extends CharacterBody2D

@export var speed : float = 100
@export var hp = 100
@export var maxhp = 100

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
@onready var lblTime = get_node("%time")
@onready var deathPanel = get_node("%DeathPanel")
@onready var lbl_Result = get_node("%lbl_Result")

var orb = preload("res://orb.tscn")
@onready var orbTimer = get_node("%orbTimer")
@onready var orbAttackTimer = get_node("%orbAttackTimer")

var time = 0

var orb_ammo = 0
var orb_baseammo = 1
var orb_attackspeed = 1.5
var orb_level = 0

var enemy_close = []


var collected_upgrades = []
var upgrade_options = []
var armor = 0
var extra_speed = 0
var speel_cooldown = 0
var additional_attacks = 0

var xp = 0
var level = 1
var exp_required = 10

func attack():
	if orb_level > 0:
		orbTimer.wait_time = orb_attackspeed
		if orbTimer.is_stopped():
			orbTimer.start()

func _physics_process(_delta):
	
	update_healthbar()
	update_experiencebar()
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
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
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
	if Input.is_key_pressed(KEY_J) and attackcooldown.is_stopped():
		if not ap.current_animation == "attack1":
			ap.play("attack1")
			attackcooldown.start()
	attack()

func _on_hurt_box_hurt(damage):
	hp -= damage
	if hp < 0:
		death()

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
	else:
		print("not level up")
		xp += earnedxp
	
func calculate_experiencecap():
	var exp_cap = level
	if level < 20:
		exp_cap = level*5
	elif level < 40:
		exp_cap = 95 * (level-19)*8
	else:
		exp_cap = 255 * (level-39)*12
	
	return exp_cap

func get_time(argtime = 0):
	time = argtime
	var get_m = int(time/60.0)
	var get_s = time % 60
	if get_m < 10:
		get_m = str(0, get_m)
	if get_s < 10:
		get_s = str(0, get_s)
	lblTime.text = str(get_m, ":", get_s)

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
		option_choice.item = get_random_item()
		upgradeOptions.add_child(option_choice)
		options += 1
	
	get_tree().paused = true

func upgrade_character(upgrade):
	match upgrade:
		"jesus":
			hp += 20
			hp = clamp(hp,0,maxhp)
		"boots1", "boots2":
			speed += 30
		"magic1":
			orb_level = 1
		"magic2":
			orb_baseammo = 2

	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_options.clear()
	collected_upgrades.append(upgrade)
	levelPanel.visible = false
	levelPanel.position = Vector2(626,-480)
	get_tree().paused = false

func get_random_item():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades: #find collected upgrades
			pass
		elif i in upgrade_options: #if the upgrade already is an option
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item":#dont pick food
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0: #check for prerequisites
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:
					pass
				else:
					dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var randomitem = dblist.pick_random()
		upgrade_options.append(randomitem)
		return randomitem
	else:
		return null


func _on_orb_attack_timer_timeout():
	if orb_ammo > 0:
		var orb_attack = orb.instantiate()
		orb_attack.position = position
		orb_attack.target = get_random_target()
		orb_attack.level = orb_level
		add_child(orb_attack)
		orb_ammo -= 1
		if orb_ammo > 0:
			orbAttackTimer.start()
		else:
			orbAttackTimer.stop()

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP


func _on_orb_timer_timeout():
	orb_ammo += orb_baseammo
	orbAttackTimer.start()


func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)

func death():
	deathPanel.visible = true
	get_tree().paused = true
	var tween = deathPanel.create_tween()
	tween.tween_property(deathPanel, "position", Vector2(476,150),0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	if time >= 300:
		lbl_Result.text = "You Win"
	else:
		lbl_Result.text = "You Lose"

func _on_back_to_menu_pressed():
	get_tree().paused = false
	var _level = get_tree().change_scene_to_file("res://menu.tscn")
