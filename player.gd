extends CharacterBody2D

@export var speed : float = 100
@export var hp = 80

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var sword = $Sprite2D/HitBox
@onready var attackcooldown = $Sprite2D/HitBox/AttackCooldownTimer

func _physics_process(_delta):
	if not ap.current_animation == "attack1":
		#Getting inputs from the player
		var horizontal_direction = Input.get_axis("left", "right")
		var vertical_direction = Input.get_axis("up", "down")
		
		#Switching direction from left to right
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
	if Input.is_key_pressed(KEY_J) and attackcooldown.is_stopped():
		if not ap.current_animation == "attack1":
			ap.play("attack1")
			attackcooldown.start()

func _on_hurt_box_hurt(damage):
	hp -= damage
	print(hp)
