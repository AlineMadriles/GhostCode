extends Control

var character_paths = {
	"A": "res://scenes/characters/choloscene.tscn",
	"B": "res://scenes/characters/fresascene.tscn", 
	"C": "res://scenes/characters/gothscene.tscn"
}

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_cholo_pressed():
	start_game("A")

func _on_fresa_pressed():
	start_game("B")

func _on_goth_pressed():
	start_game("C")

func start_game(choice):
	if character_paths.has(choice):
		if ResourceLoader.exists(character_paths[choice]):
			Global.selected_character_path = character_paths[choice]
			get_tree().change_scene("res://scenes/Main.tscn")
			print("Character selected")
		else:
			print("Character scene doesn't exist: ", character_paths[choice])
	else:
		print("Invalid character choice: ", choice)
