extends StaticBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var countdown_time = 5
export var blast_radius = 5

var init_time #in milliseconds
var flash_wait_time #in milliseconds
var last_flash #in milliseconds
var flash_delay #in milliseconds
var current_color

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	init_time = OS.get_ticks_msec()
	flash_wait_time = countdown_time * 1000 - 1000
	last_flash = OS.get_ticks_msec()
	flash_delay = 25
	current_color = "red"
	
	var timer = get_node("Timer")
	
	timer.set_wait_time(countdown_time)
	timer.connect("timeout", self, "explode")
	timer.start()
	
	set_process(true)
	
func _process(delta):
	if (OS.get_ticks_msec() > init_time + flash_wait_time):
		if (OS.get_ticks_msec() > last_flash + flash_delay):
			last_flash = OS.get_ticks_msec()
			
			if (current_color == "red"):
				var material = get_node("TestCube").get_material_override().duplicate()
				material.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color(255, 255, 255))
				get_node("TestCube").set_material_override(material)
				current_color = "white"
			elif (current_color == "white"):
				var material = get_node("TestCube").get_material_override().duplicate()
				material.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color(255, 0, 0))
				get_node("TestCube").set_material_override(material)
				current_color = "red"
	
func explode():
	
	get_node("SamplePlayer").play("explosion")
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