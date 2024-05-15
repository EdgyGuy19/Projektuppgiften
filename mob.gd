extends CharacterBody2D


@export var movement_speed = 50.0
@export var hp = 10
@export var xp = 5

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var healthbar = $Healthbar

var death_anim = preload("res://death_animation.tscn")

func _ready():
	pass

func _physics_process(_delta):
	update_healthbar()
	if not anim.current_animation == "hit":
		anim.play("walk")
		
	var direction = global_position.direction_to(player.global_position)
	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < -0.1:
		sprite.flip_h = false
	
	velocity = direction*movement_speed
	move_and_slide()

func update_healthbar():
	healthbar.value = hp
	
	if hp >= 10:
		healthbar.visible = false
	else:
		healthbar.visible = true

func death():
	var mob_death = death_anim.instantiate()
	mob_death.scale = sprite.scale
	mob_death.global_position = global_position
	get_parent().call_deferred("add_child",mob_death)
	queue_free()
	player.increase_xp(xp)

func _on_hurt_box_hurt(damage):
	hp -= damage
	if hp <= 0:
		death()
	else:
		anim.play("hit")
