extends Spatial

# Gameplay variables
var items_collected = 0
var total_items = 3
var door_unlocked = false

func _ready():
	# Spawn player
	var spawn_point = $SpawnPoint
	if not spawn_point:
		print("SpawnPoint not found.")
		return

	if Global.selected_character_path != "":
		var player_scene = load(Global.selected_character_path)
		if player_scene:
			var player = player_scene.instance()
			add_child(player)
			player.global_transform = spawn_point.global_transform
			
			# Make sure the character camera is current
			var camera = player.get_node("SpringArm/Camera")
			if camera:
				camera.current = true
				print("Character camera activated")
			else:
				print("Camera not found in character!")
		else:
			print("Could not load player scene from: ", Global.selected_character_path)
			get_tree().change_scene("res://scenes/CharacterSelect.tscn")
	else:
		print("No character selected - returning to character select")
		get_tree().change_scene("res://scenes/CharacterSelect.tscn")

func collect_item():
	items_collected += 1
	print("Item collected! Progress: %d/%d" % [items_collected, total_items])
	
	if items_collected >= total_items:
		unlock_door()

func unlock_door():
	door_unlocked = true
	print("Door unlocked! You can now exit.")

func try_exit():
	if door_unlocked:
		print("You escaped the first challenge! Now complete the other labs.")
	else:
		print("Door is locked! Collect all %d items first. Current progress: %d/%d" %
			  [total_items, items_collected, total_items])
