extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var player_node
var player_shape_node

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var player_scn = preload("res://Game/Scenes/Characters/player.tscn")
	
	player_node = player_scn.instance()
	add_child(player_node)
	player_node.global_translate(Vector3(0,5,0))
	player_shape_node = BoxShape.new()
	player_node.add_shape(player_shape_node)
	
	for x in range(-10,10):
		for z in range(-10,10):
			print (x, " ", z, " ", get_node("/root/Node/GridMap").get_cell_item(x,0,z))
	set_process(true)

func _process(delta):
	# Enable key for debugging to disable collider.
	if (Input.is_action_pressed("disable_collider")):
		var pos = player_node.get_translation()
		get_node("/root/Node/GridMap").set_cell_item(int(round((pos.x+1)/2-1)),0,int(round((pos.z+1)/2-1)),-1)
		print(pos.x, " ", pos.y, " ", pos.z)
		print(int(round((pos.x)))/2," ",0," ",int(round((pos.z)))/2)