extends Control

func resume():
	get_tree().paused = false
	hide()

func pause():
	get_tree().paused = true
	show()

func testEsc():
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()

func _on_resume_pressed():
	resume()


func _on_restart_pressed():
	resume()
	get_tree().reload_current_scene()


func _on_give_up_pressed():
	get_tree().quit()

func _process(delta):
	testEsc()
