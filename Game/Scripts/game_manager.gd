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
	var player_collider_scn = preload("res://Game/Scenes/Characters/player_collider.tscn")
	
	player_node = player_scn.instance()
	add_child(player_node)
	player_node.global_translate(Vector3(0,5,0))
	player_shape_node = BoxShape.new()
	player_node.add_shape(player_shape_node)
	
	set_process(true)

func _process(delta):
	# Enable key for debugging to disable collider.
	if (Input.is_action_pressed("disable_collider")):
		print("disable collider")
		player_node.remove_shape(0)