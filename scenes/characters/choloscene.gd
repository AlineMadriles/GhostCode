extends KinematicBody

export var character_name = "El cholo"
export var speed := 6.0
export var jump_force := 12.0
export var gravity := -24.8

var velocity := Vector3.ZERO
var direction := Vector3.ZERO

onready var spring_arm := $SpringArm
onready var camera := $SpringArm/Camera

export var mouse_sensitivity := 0.05
var rotation_x := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Debug info
	print("Character spawned: ", character_name)
	print("Camera exists: ", $SpringArm/Camera != null)
	if $SpringArm/Camera:
		$SpringArm/Camera.current = true
		print("Camera set to current")
		
	print("Character Y position on spawn: ", global_transform.origin.y)
	print("Character collision shape position: ", $CollisionShape.transform.origin)

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

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_force
	#testing
	if velocity.length() > 0.1:
		print("Moving! Velocity: ", velocity)
		
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_force
		print("JUMP!")

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
