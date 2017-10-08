extends RigidBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var speed = 2

var path = []

func _ready():
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

	if closest_player != null:
		var destination = get_node("/root/Node/Navigation").get_closest_point(closest_player.get_translation())
		path = get_node("/root/Node/Navigation").get_simple_path(get_translation(), destination)
		if path.size() > 1:
			var direction = (path[1] - path[0]).normalized()
			global_translate(direction*speed*delta) 