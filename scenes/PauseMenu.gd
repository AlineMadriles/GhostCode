extends Control

func _ready():
	visible = false
	# This is CRITICAL - allows the pause menu to work when game is paused
	pause_mode = Node.PAUSE_MODE_PROCESS

func toggle_pause():
	var is_paused = !get_tree().paused
	get_tree().paused = is_paused
	visible = is_paused
	
	# Mouse mode
	if is_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_ResumeButton_pressed():
	toggle_pause()

func _on_RestartButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_MainMenuButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/CharacterSelect.tscn")
