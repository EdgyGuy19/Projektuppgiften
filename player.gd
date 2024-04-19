extends CharacterBody2D

@export var speed : float = 100

func _physics_process(_delta):
	# Inputs for directions
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)

	print(input_direction)

#Update velocity
	velocity = input_direction * speed
	move_and_slide()
#Moving
