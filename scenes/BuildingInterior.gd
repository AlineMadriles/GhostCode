extends Spatial
var items_collected = 0
var total_items = 3 
var door_unlocked = false

func _ready():
	spawn_character()
	show_intro_message()

func spawn_character():
	var spawn_point = $SpawnPoint
	if not spawn_point:
		print("Punto de spawn no encontrado!")
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
				print("Personaje spawneo y camara activada")
			else:
				print("No se pudo cargar la escena del personaje!")
				get_tree().change_scene("res://scenes/CharacterSelect.tscn")
		else:
			print("Personaje no seleccionado!")
			get_tree().change_scene("res://scenes/CharacterSelect.tscn")

func show_intro_message():
	print("=== GHOSTCODE ===")
	print("Despertaste despues de haberte quedado hasta tarde para terminar tu proyecto...")
	print("La uni esta sola y oscura...")
	print("Necesitas escapar antes de que los fantasmas te eliminen!")
	print("Encuentra todas la piezas mediante retos de redes para desbloquear la salida de este edificio!")
	print("Utiliza WASD para moverte, ESPACIO para saltar, E para interactuar con los objetos")
	print("ESC para ir al menu de pausa")

func collect_item():
	items_collected += 1
	print("Objeto conseguido! Progreso: ", items_collected, "/" , total_items)
	
	if items_collected >= total_items:
		unlock_door()
	
func unlock_door():
	door_unlocked = true
	print("Esooo!!! Ya puedes salir de este laboratorio!")
	print("Encuentra la salida verde para el siguiente reto!")
	
func try_exit():
	if door_unlocked:
		print("Yupiii! Escapaste el primer reto!")
		print("Ahora tendras que completar los retos de los otros laboratorios para salir del edificio B!")
	else:
		print("EKKK!!! Esta cerrado! Encuentra los " + str(total_items) + " objetos primero!")
		print("Progreso actual: " + str(items_collected) + "/" + str(total_items))
		
