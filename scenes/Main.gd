extends Spatial

func _ready():
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
