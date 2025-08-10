extends Control


func _ready():
	visible = false
	
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	

func toggle_pause():
	var is_paused = !get_tree().paused
	get_tree().paused = is_paused
	visible = is_paused
	
	# Modo del mouse
	if is_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_ResumeButton_pressed():
	toggle_pause()

func _on_RestartButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_MainMenuButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/CharacterSelect.tscn")
	

