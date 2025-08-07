extends Control

# Dictionary mapping each button ID to its scene path
var character_paths = {
	"A": "res://characters/choloscene.tscn",
	"B": "res://characters/fresascene.tscn",
	"C": "res://characters/gothscene.tscn"
}

func _ready():
	# Show the mouse cursor for UI interaction
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_cholo_pressed():
	start_game("A")

func _on_fresa_button_pressed():
	start_game("B")

func _on_goth_button_pressed():
	start_game("C")

func start_game(choice):
	if character_paths.has(choice):
		Global.selected_character_path = character_paths[choice]
		get_tree().change_scene("res://scenes/Main.tscn")
	else:
		print("EEGG! esta mal en algo!")
