extends Spatial

var items_collected = 0
var total_items = 3 
var door_unlocked = false

onready var message_label = $CanvasLayer/MessageLabel
onready var message_timer = Timer.new()

func _ready():
	# Setup timer for hiding messages
	message_timer.one_shot = true
	message_timer.wait_time = 4.0
	message_timer.connect("timeout", self, "_on_message_timeout")
	add_child(message_timer)

	spawn_character()
	show_intro_message()

func show_message(text):
	message_label.bbcode_text = "[center]" + text + "[/center]"
	message_label.show()
	message_timer.start()

func _on_message_timeout():
	message_label.hide()

# --- Rest of your functions (spawn_character, collect_item, etc.) ---


func spawn_character():
	var spawn_point = $SpawnPoint
	if not spawn_point:
		show_message("Punto de spawn no encontrado!")
		return
	
	if Global.selected_character_path != "":
		var player_scene = load(Global.selected_character_path)
		if player_scene:
			var player = player_scene.instance()
			add_child(player)
			player.global_transform = spawn_point.global_transform
			
			var camera = player.get_node("SpringArm/Camera")
			if camera:
				camera.current = true
				show_message("Personaje spawneado y cámara activada")
			else:
				show_message("No se pudo cargar la cámara del personaje!")
				get_tree().change_scene("res://scenes/CharacterSelect.tscn")
		else:
			show_message("Personaje no seleccionado!")
			get_tree().change_scene("res://scenes/CharacterSelect.tscn")

func show_intro_message():
	show_message("=== GHOSTCODE ===\nDespertaste después de quedarte hasta tarde...\n" +
				 "La uni está sola y oscura...\n" +
				 "Encuentra todas las piezas para desbloquear la salida!\n" +
				 "WASD: mover | ESPACIO: saltar | E: interactuar | ESC: menú de pausa")

func collect_item():
	items_collected += 1
	show_message("Objeto conseguido! Progreso: %d/%d" % [items_collected, total_items])
	
	if items_collected >= total_items:
		unlock_door()
	
func unlock_door():
	door_unlocked = true
	show_message("¡Esooo! Ya puedes salir del laboratorio!\nBusca la salida verde para el siguiente reto.")

func try_exit():
	if door_unlocked:
		show_message("¡Yupiii! Escapaste el primer reto!\nAhora completa los otros laboratorios para salir del edificio B!")
	else:
		show_message("EKKK!!! Está cerrado!\nEncuentra los %d objetos primero.\nProgreso actual: %d/%d" %
					 [total_items, items_collected, total_items])
