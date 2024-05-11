extends CharacterBody2D

@export var speed : float 

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var game_start_time = Time.get_ticks_msec()

func _physics_process(delta):
	
#Getting inputs from the player
	var horizontal_direction = Input.get_axis("left", "right")
	var vertical_direction = Input.get_axis("up", "down")
	
#Switching direction from left to right
	if horizontal_direction != 0:
		sprite.flip_h = Input.get_action_raw_strength("left")

#Vector directions
	velocity.x = speed * horizontal_direction
	velocity.y = speed * vertical_direction

	move_and_slide()
	
#Playing the animations
	animations(horizontal_direction, vertical_direction)
	
#Function for changing animations
func animations(horizontal, vertical):
	if horizontal == 0 and vertical == 0:
		ap.play("idle")
	else:
		ap.play("run")

func get_time():
	var current_time = Time.get_ticks_msec() - game_start_time
	var minutes = current_time/1000/60
	if minutes < 10:
		minutes = "0"+str(minutes)
	var seconds = current_time/1000%60
	if seconds < 10:
		seconds = "0"+str(seconds)
	return(str(minutes)+":"+str(seconds))

func _process(delta):
	$CanvasLayer/Control/Label.text =  get_time()
