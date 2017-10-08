extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var player_spawn_position = Vector3(0,0,0)
export var spawn_wait_time = 10
export var include_basic = true
export var include_pathfinder = true
export var enemies_per_wave = 10

var map_max_z = 99
var map_min_z = -map_max_z
var map_max_x = 99
var map_min_x = -map_max_x
var next_spawn = 0
var basic_enemy_scn = preload("res://Game/Scenes/Characters/basic_enemy.tscn")
var path_enemy_scn = preload("res://Game/Scenes/Characters/navigation_enemy.tscn")
var player_node

var monsters = []

func _ready():
	var player_scn = preload("res://Game/Scenes/Characters/player.tscn")
	var chibi_player_scn = preload("res://Game/Scenes/Characters/chibi_player.tscn")
	
#	# Create list of available monsters
	if include_basic:
		monsters.append(basic_enemy_scn)
	if include_pathfinder:
		monsters.append(path_enemy_scn)

	# Spawn players
	player_node = chibi_player_scn.instance()
	add_child(player_node)
	player_node.global_translate(player_spawn_position)

	spawn_enemies()
	# Set a timer for futures spawns
	var _timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "spawn_enemies")
	_timer.set_wait_time(spawn_wait_time)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()

	set_process(true)

func _process(delta):
	pass
#	if (OS.get_unix_time() > next_spawn):
#		next_spawn = OS.get_unix_time() + spawn_wait_time
#		spawn_enemies()
	
func spawn_enemies():
	for i in range(0, enemies_per_wave):
		randomize()
		var enemy_index = randi() % monsters.size()
		randomize()
		var side = randi() % 4
		
		var enemy_node = monsters[enemy_index].instance()
		add_child(enemy_node)
		randomize() # For position on side of map
		if side == 0: # Top
			var pos = randf() * (map_max_x - map_min_x) - map_max_x
			enemy_node.global_translate(Vector3(pos, 2, map_min_z))
		elif side == 1: # Bottom
			var pos = randf() * (map_max_x - map_min_x) - map_max_x
			enemy_node.global_translate(Vector3(pos, 2, map_max_z))
		elif side == 2: # Left
			var pos = randf() * (map_max_z - map_min_z) - map_max_z
			enemy_node.global_translate(Vector3(map_min_x, 2, pos))
		elif side == 3: # Right
			var pos = randf() * (map_max_z - map_min_z) - map_max_z
			enemy_node.global_translate(Vector3(map_min_x, 2, pos))