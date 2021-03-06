extends RigidBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var movement_speed = 5
export var bomb_drop_delay = 1000

var player_bomb_scn
var next_bomb_drop = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	player_bomb_scn = preload("res://Game/Scenes/Weapons/player_bomb.tscn")
	set_fixed_process(true)

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
	
	if (Input.is_action_pressed("use_weapon") and OS.get_ticks_msec() > next_bomb_drop):
		next_bomb_drop = OS.get_ticks_msec() + bomb_drop_delay
		var bomb_node = player_bomb_scn.instance()
		bomb_node.set_translation(Vector3(get_translation().x, bomb_node.get_node("TestCube").get_scale().y, get_translation().z))
		get_node("/root/Node").add_child(bomb_node)