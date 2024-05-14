extends Area2D


@export_enum("Cooldown","HitOnce","DisableHitBox") var HurtBoxType = 0

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

signal hurt(damage)

func _on_area_entered(area):
	if area.is_in_group("attack"):
		print(area)
		if not area.get("damage") == null:
			match HurtBoxType:
				0:
					collision.call_deferred("set","disabled",true)
					disableTimer.start()
					
				1:
					pass
					
				2:
					if area.has_method("tempdisable"):
						area.tempdisable()
			var damage = area.damage
			print("Damage")
			emit_signal("hurt",damage)



func _on_disable_timer_timeout():
	collision.call_deferred("set","disabled",false)
