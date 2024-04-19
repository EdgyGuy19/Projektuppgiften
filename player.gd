extends CharacterBody2D

@export var speed : float = 100

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

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

#Printing vector(for testing)
	print(velocity)

	move_and_slide()
	
#Playing the animations
	animations(horizontal_direction)
	
#Function for changing animations
func animations(direction):
	if direction == 0:
		ap.play("idle")
	else:
		ap.play("run")
