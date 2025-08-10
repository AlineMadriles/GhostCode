extends KinematicBody

export var character_name = "La Fresa"
export var speed := 6.0
export var jump_force := 12.0
export var gravity := -24.8
export var mouse_sensitivity := 0.05
export var max_health = 100

var velocity := Vector3.ZERO
var direction := Vector3.ZERO
var rotation_x := 0.0
var current_health = 100
var ui_scene

onready var spring_arm := $SpringArm
onready var camera := $SpringArm/Camera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Debug info
	print("Character spawned: ", character_name)
	print("Camera exists: ", $SpringArm/Camera != null)
	if $SpringArm/Camera:
		$SpringArm/Camera.current = true
		print("Camera set to current")
	
	# HP UI
	setup_ui()
	

func setup_ui():
	ui_scene = preload("res://scenes/PlayerUI.tscn").instance()
	add_child(ui_scene)
	ui_scene.update_health(current_health, max_health)
	
# Funcion que hace damage
func take_damage(amount):
	current_health = max(0, current_health - amount)
	ui_scene.update_health(current_health, max_health)
	print(character_name + " took " + str(amount) + " damage! Health: " +str(current_health))
	
	if current_health <= 0:
		die()
		
func heal(amount):
	current_health = min(max_health, current_health + amount)
	ui_scene.update_health(current_health, max_health)
	print(character_name + " healed " + str(amount) + "! Health: " + str(current_health))
	
func die():
	print(character_name + " died!")
	# Mientras tanto, solo se reiniciara la escena
	get_tree().reload_current_scene()

# Temporal! SOLO TESTEO, eliminar mas tarde
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_T:  # Tecla T para damage
			take_damage(10)
		if event.scancode == KEY_H:  # Tecla H para healing
			heal(10)
	if event.is_action_just_pressed("ui_cancel"):
		var pause_menu = get_tree().current_scene.get_node("PauseMenu")
		if pause_menu:
			pause_menu.toggle_pause()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_x = clamp(rotation_x - event.relative.y * mouse_sensitivity, -60, 60)
		spring_arm.rotation_degrees.x = rotation_x
		rotate_y(-event.relative.x * mouse_sensitivity)


func _physics_process(delta):
	get_input()
	apply_gravity(delta)
	move_and_slide(velocity, Vector3.UP)
	
	#testing
	if not is_on_floor():
		if abs(velocity.y) <= 0.0001:
			print("ON GROUND! Y position: ", global_transform.origin.y)
		else:
			print("NOT ON GROUND! Y position: ", global_transform.origin.y)

func get_input():
	direction = Vector3.ZERO
	var cam_basis = camera.global_transform.basis
	var forward = -cam_basis.z
	var right = cam_basis.x

	if Input.is_action_pressed("move_forward"):
		direction += forward
	if Input.is_action_pressed("move_backwards"):
		direction -= forward
	if Input.is_action_pressed("move_left"):
		direction -= right
	if Input.is_action_pressed("move_right"):
		direction += right

	direction.y = 0
	direction = direction.normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	if Input.is_action_just_pressed("jump"):
		print("JUMPING!")
		velocity.y = jump_force

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
