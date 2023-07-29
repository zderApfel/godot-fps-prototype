extends CharacterBody3D

const JOG_SPEED = 8
const SPRINT_SPEED = 12
const JUMP_VELOCITY = 4
const CROUCH_SPEED = JOG_SPEED*0.5
const SENSITIVITY = 0.01

const BOB_FREQ = 2.0
const BOB_AMP = 0.08

@onready var gravity = 9.8
@onready var speed = 8

@onready var camera = $pivot/Camera3D
@onready var head = $pivot

@onready var t_bob = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(60))

func _physics_process(delta):
	jump(delta)
	ground_movement(delta)
	headbob_controller(delta)

func jump(x):
	if not is_on_floor():
		velocity.y -= gravity * x
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func ground_movement(x):
	
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, x * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, x * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, x * 0.5)
		velocity.z = lerp(velocity.z, direction.z * speed, x * 0.5)

	move_and_slide()
	
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
	
func headbob_controller(x):
	t_bob += x * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
