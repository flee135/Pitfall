extends StaticBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var countdown_time = 5
export var blast_radius = 5

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var timer = get_node("Timer")
	
	timer.set_wait_time(countdown_time)
	timer.connect("timeout", self, "explode")
	timer.start()
	
func explode():
	var pos = get_translation()
	get_node("/root/Node/GridMap").set_cell_item(int(round((pos.x+1)/2-1)),0,int(round((pos.z+1)/2-1)),-1)
	queue_free()