extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var player_spawn_position = Vector3(0,0,0)

var basic_enemy_scn
var path_enemy_scn
var player_node
var player_shape_node

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var player_scn = preload("res://Game/Scenes/Characters/player.tscn")
	var chibi_player_scn = preload("res://Game/Scenes/Characters/chibi_player.tscn")
	basic_enemy_scn = preload("res://Game/Scenes/Characters/basic_enemy.tscn")
	path_enemy_scn = preload("res://Game/Scenes/Characters/navigation_enemy.tscn")
	
#	player_node = player_scn.instance()
#	add_child(player_node)
#	player_node.global_translate(Vector3(0,5,0))
#	player_shape_node = BoxShape.new()
#	player_node.add_shape(player_shape_node)

	player_node = chibi_player_scn.instance()
	add_child(player_node)
	player_node.global_translate(player_spawn_position)
	
	var enemy_node = basic_enemy_scn.instance()
	add_child(enemy_node)
	enemy_node.global_translate(Vector3(5,1,5))
	
	var path_enemy_node = path_enemy_scn.instance()
	add_child(path_enemy_node)
	path_enemy_node.global_translate(Vector3(10, 1, -10))
	
	set_process(true)

func _process(delta):
	# Enable key for debugging to disable collider.
	if (Input.is_action_pressed("disable_collider")):
		var pos = player_node.get_translation()
		get_node("/root/Node/Navigation/GridMap").set_cell_item(int(round((pos.x+1)/2-1)),0,int(round((pos.z+1)/2-1)),-1)