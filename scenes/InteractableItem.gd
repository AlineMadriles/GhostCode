extends StaticBody

export var item_name = "Pieza del puzzle"
export var item_color = Color.cyan
var can_interact = true
var player_nearby = false

func _ready():
	var area = Area.new()
	var collision = CollisionShape.new()
	var sphere_shape = SphereShape.new()
	sphere_shape.radius = 2.0
	collision.shape = sphere_shape
	area.add_child(collision)
	add_child(area)
	
	area.connect("body_entered", self, "_on_player_entered")
	area.connect("body_exited", self, "_on_player_exited")
	
	var mesh_instance = get_node("MeshInstance")
	if mesh_instance and mesh_instance.get_surface_material(0):
		mesh_instance.ger_surface_material(0).albedo_color = item_color

func _on_player_entered(body):
	if is_player(body):
		player_nearby = true
		print("Presiona E para recoger: ", item_name)

func _on_player_exited(body):  
	if is_player(body):
		player_nearby = false

func is_player(body):
	return (body.name == "Cholo" or
		body.name == "fresascene" or
		body.name == "gothscene" or
		body.name.begins_with("Jugador"))

func _input(event):
	if player_nearby and can_interact and Input.is_action_just_pressed("interact_object"):
		interact()

func interact():
	can_interact = false
	print("Recogiste: ", item_name)
	
	var building = get_tree().current_scene
	if building.has_method("collect_item"):
		building.collect_item()
	
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "scale", scale, Vector3.ZERO, 0.5)
	tween.start()
	yield(tween, "tween_completed")
	queue_free()
