extends KinematicBody

# ------------------------ Variables ------------------------
# --- Movimiento ---
export var speed := 6.0
export var jump_force := 12.0
export var gravity := -24.8
var velocity := Vector3.ZERO
var direction := Vector3.ZERO

# --- Camara y rotacion ---
onready var spring_arm := $SpringArm  
onready var camera := spring_arm.get_node("Camera")
export var mouse_sensitivity := 0.2
var rotation_x := 0.0  # Rotacion vertical de camara

# ------------------------ Metodos ------------------------
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_x = clamp(rotation_x - event.relative.y * mouse_sensitivity, -60, 60)
		spring_arm.rotation_degrees.x = rotation_x
		rotation_degrees.y -= event.relative.x * mouse_sensitivity  # Rotar al jugador

func _physics_process(delta):
	get_input()
	apply_gravity(delta)
	move_and_slide(velocity, Vector3.UP)

# ------------------------ Mas metodos ------------------------
func get_input():
	direction = Vector3.ZERO  # Clear direction every frame

	var cam_basis = camera.global_transform.basis  
	var cam_forward = -cam_basis.z
	var cam_right = cam_basis.x

	if Input.is_action_pressed("move_forward"):
		direction += cam_forward
	if Input.is_action_pressed("move_backwards"):  # changed from just_pressed
		direction -= cam_forward
	if Input.is_action_pressed("move_left"):
		direction -= cam_right
	if Input.is_action_pressed("move_right"):
		direction += cam_right

	direction.y = 0
	direction = direction.normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_force

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
