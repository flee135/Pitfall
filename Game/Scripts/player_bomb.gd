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
	var pos = get_translation()
	get_node("/root/Node/Navigation/GridMap").set_cell_item(int(round((pos.x+1)/2-1)),0,int(round((pos.z+1)/2-1)),-1)
	queue_free()