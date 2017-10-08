extends RigidBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var speed = 15
export var blast_radius = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_linear_velocity(get_global_transform().basis.z.normalized() * speed)
	
	set_contact_monitor(true)
	set_max_contacts_reported(5)
	
	connect("body_enter", self, "explode")

func explode(body):
	if (body.is_in_group("player_group")):
		return
		
	var pos = get_translation()
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
	
	queue_free()