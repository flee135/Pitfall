extends RigidBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var speed = 5
export var blast_radius = 1

var animation_player
var path = []
var can_move = true


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	animation_player = get_node("Mesh/AnimationPlayer")
	set_fixed_process(true)

func _fixed_process(delta):
	# Check if under stage. If so, delete enemy.
	if get_translation().y < -10:
		queue_free()
	if can_move:
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
				look_at(get_translation()-direction, Vector3(0,1,0))
				
			if get_translation().distance_to(closest_player.get_translation()) < 10:
				can_move = false
				animation_player.play("attack")
				animation_player.connect("finished", self, "resolve_attack", [closest_player])
		
func resolve_attack(closest_player):
	can_move = true
	var direction = (closest_player.get_translation() - get_translation()).normalized()
	var pos = get_translation() + direction*10
	var center_cell_row = int(round((pos.x+1)/2-1))
	var center_cell_col = int(round((pos.z+1)/2-1))
	var max_cell_dist
	
	if (blast_radius == 0):
		max_cell_dist = 0
	elif (blast_radius == 1):
		max_cell_dist = 1
	else:
		max_cell_dist = (blast_radius - 1) * 2
	
	for i in range(center_cell_row - blast_radius, center_cell_row + blast_radius + 1):
		for j in range(center_cell_col - blast_radius, center_cell_col + blast_radius + 1):
			if (abs(i - center_cell_row) + abs(j - center_cell_col) <= max_cell_dist):
				get_node("/root/Node/Navigation/GridMap").set_cell_item(i, 0, j, -1)