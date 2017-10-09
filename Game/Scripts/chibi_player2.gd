extends RigidBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var movement_speed = 10
export var bomb_drop_delay = 1000
export var arrow_fire_delay = 1000

var player_bomb_scn
var player_arrow_scn
var animation_player
var next_bomb_drop = 0
var next_arrow = 0
var can_move = true

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	player_bomb_scn = preload("res://Game/Scenes/Weapons/player_bomb.tscn")
	player_arrow_scn = preload("res://Game/Scenes/Weapons/player_arrow.tscn")
	animation_player = get_node("Mesh/AnimationPlayer")
	set_fixed_process(true)

func _fixed_process(delta):
	if (can_move):
		var move_vector = Vector3(0,0,0)
		if (Input.is_action_pressed("p2_move_forward")):
			move_vector.z = -1
		if (Input.is_action_pressed("p2_move_backwards")):
			move_vector.z = 1
		if (Input.is_action_pressed("p2_move_left")):
			move_vector.x = -1
		if (Input.is_action_pressed("p2_move_right")):
			move_vector.x = 1
		# Check if animation should play
		if (move_vector.length() > 0 and animation_player.get_current_animation() != "walk"):
			get_node("Mesh/AnimationPlayer").play("walk")
		elif move_vector.length() == 0 and animation_player.get_current_animation() != "idle":
			get_node("Mesh/AnimationPlayer").play("idle")
		# Modify rotation of rigidbody
		rotate_towards_vector(move_vector)
		move_vector = move_vector.normalized() * movement_speed * delta
		move_vector.y = get_linear_velocity().y * delta
		global_translate(move_vector)
	
	if (Input.is_action_pressed("p2_use_bomb") and OS.get_ticks_msec() > next_bomb_drop):
		animation_player.play("drop")
		next_bomb_drop = OS.get_ticks_msec() + bomb_drop_delay*5
		var bomb_node = player_bomb_scn.instance()
		bomb_node.set_translation(Vector3(get_translation().x, bomb_node.get_node("TestCube").get_scale().y, get_translation().z))
		get_node("/root/Node").add_child(bomb_node)
		# Don't allow player to move until animation is finished.
		can_move = false
		animation_player.connect("finished", self, "allow_movement")
	
	if (Input.is_action_pressed("p2_use_arrow") and OS.get_ticks_msec() > next_arrow):
		next_arrow = OS.get_ticks_msec() + arrow_fire_delay
		var arrow_node = player_arrow_scn.instance()
		arrow_node.set_translation(Vector3(get_translation().x, get_node("CollisionShape").get_translation().y, get_translation().z))
		arrow_node.set_rotation(Vector3(get_rotation()))
		get_node("/root/Node").add_child(arrow_node)
		# Don't allow player to move until animation is finished.
		
func allow_movement():
	next_bomb_drop = OS.get_ticks_msec() + bomb_drop_delay
	can_move = true
	
func rotate_towards_vector(dir):
	if (dir.length() > 0):
		look_at(get_translation()-dir, Vector3(0,1,0))