extends RigidBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var movement_speed = 5

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	var move_vector = Vector3(0,0,0)
	if (Input.is_action_pressed("move_forward")):
		move_vector.z = -1
	if (Input.is_action_pressed("move_backwards")):
		move_vector.z = 1
	if (Input.is_action_pressed("move_left")):
		move_vector.x = -1
	if (Input.is_action_pressed("move_right")):
		move_vector.x = 1
	move_vector = move_vector.normalized() * movement_speed * delta
	move_vector.y = get_linear_velocity().y * delta
	global_translate(move_vector)