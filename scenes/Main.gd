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
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			print("Could not load player scene from: ", Global.selected_character_path)
	else:
		print("No character selected.")
		get_tree().change_scene("res://scenes/CharacterSelect.tscn")
