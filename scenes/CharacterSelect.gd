extends Control

var character_paths = {
	"A": "res://scenes/characters/choloscene.tscn",
	"B": "res://scenes/characters/fresascene.tscn", 
	"C": "res://scenes/characters/gothscene.tscn"
}

var unlocked_characters = ["A"]

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	update_characters_buttons()
	
func update_characters_buttons():
	$Panel/FresaButton.disabled = !("B" in unlocked_characters)
	$Panel/GothButton.disabled = !("C" in unlocked_characters)
	
	if 	$Panel/FresaButton.disabled:
			$Panel/FresaButton.text = "La fresa 🔓🔓🔓🔓🔒🔒"
	if 	$Panel/GothButton.disabled:
			$Panel/GothButton.text = "La gotica"

func _on_cholo_pressed():
	if "A" in unlocked_characters:
		start_game("A")
	
func _on_fresa_pressed():
	if "B" in unlocked_characters:
		start_game("B")
	else:
		print("La Fresa aun no ha sido desbloqueada! Completa el nivel NIGHTMARE para desbloquearla.")

func _on_goth_pressed():
	if "C" in unlocked_characters:
		start_game("C")
	else:
		print("La Gotica aun no ha sido desbloqueada! Encuentra todos los secretos escondidos para desbloquearla.")

func start_game(choice):
	if character_paths.has(choice):
		if ResourceLoader.exists(character_paths[choice]):
			Global.selected_character_path = character_paths[choice]
			get_tree().change_scene("res://scenes/Main.tscn")
			print("Personaje seleccionado: " + choice)
		else:
			print("Error: ", character_paths[choice])
	else:
		print("El personaje esta bloqueado o error de path: ", choice)
