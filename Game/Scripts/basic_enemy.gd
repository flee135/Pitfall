extends RigidBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var speed = 2

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)

func _fixed_process(delta):
	# Check if under stage. If so, delete enemy.
	if get_translation().y < -10:
		queue_free()
	
	var players = get_tree().get_nodes_in_group("player_group")
	# Find nearest player
	var closest_dist = 10000
	var closest_player = null
	for p in players:
		var dist = get_translation().distance_squared_to(p.get_translation())
		if dist < closest_dist:
			closest_dist = dist
			closest_player = p

	# Move towards closest player
	var direction = (closest_player.get_translation() - get_translation()).normalized()
	global_translate(direction*speed*delta) 