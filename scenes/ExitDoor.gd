extends StaticBody

var player_nearby = false

func _ready():
	
	var area = Area.new()
	var collision = CollisionShape.new()
	var box_shape = BoxShape.new()
	box_shape.extents = Vector3(3,3,3)
	collision.shape = box_shape
	area.add_child(collision)
	add_child(area)
	
	area.connect("body_entered", self, "_on_player_entered")
	area.connect("body_exited", self, "_on_player_exited")
	
	update_door_appearance(false)

func _on_player_entered(body):
	if is_player(body):
		player_nearby = true
		var building = get_tree().current_scene
		if building.door_unlocked:
			print("Presiona E para ESCAPA!!")
		else:
			print("Puerta bloqueada. Encuentra todos los objetos primero!")

func _on_player_exited(body):
	if is_player(body):
		player_nearby = false

func is_player(body):
	return (body.name == "Cholo" or
		body.name == "Fresa" or
		body.name == "Gotica" or
		body.name.begins_with("Player"))

func _input(event):
	if player_nearby and Input.is_action_just_pressed("interact_object"):
		var building = get_tree().current_scene
		if building.has_method(("try_exit")):
			building.try_exit()
			if building.door_unlocked:
				update_door_appearance(true)

func update_door_appearance(unlocked):
	var mesh_instance = get_node("MeshInstance")
	if mesh_instance:
		var material = mesh_instance.get_surface_material(0)
		if not material:
			material = SpatialMaterial.new()
			mesh_instance.set_surface_material(0, material)
		
		if unlocked:
			material.albedo_color = Color.green
			material.emission = Color(0, 0.5, 0)
		else:
			material.albedo_color = Color.red
			material.emission = Color(0.3, 0, 0)
