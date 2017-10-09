extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var multiplayer = false
export var singleplayer_spawn_position = Vector3(0,0,0)
export var player1_spawn_position = Vector3(-20,0,0)
export var player2_spawn_position = Vector3(20,0,0)
export var spawn_wait_time = 10
export var include_hell_enemy = true
export var include_fat_enemy = true
export var enemies_per_wave = 10
export var map_max_z = 99
export var map_min_z = -99
export var map_max_x = 99
export var map_min_x = -99

var next_spawn = 0
var hell_enemy_scn = preload("res://Game/Scenes/Characters/hell_enemy.tscn")
var hell_fat_enemy_scn = preload("res://Game/Scenes/Characters/hell_fat_enemy.tscn")
var player_node
var player2_node

var monsters = []

func _ready():
	var chibi_player_scn = preload("res://Game/Scenes/Characters/chibi_player.tscn")
	var chibi_player2_scn = preload("res://Game/Scenes/Characters/chibi_player2.tscn")
	var camera_scn = preload("res://Game/Scenes/Objects/camera.tscn")
	
#	# Create list of available monsters
	if include_hell_enemy:
		monsters.append(hell_enemy_scn)
	if include_fat_enemy:
		monsters.append(hell_fat_enemy_scn)

	# Spawn players
	player_node = chibi_player_scn.instance()
	add_child(player_node)
	if not multiplayer:
		player_node.global_translate(singleplayer_spawn_position)
		add_child(camera_scn.instance())
	else:
		# Player 1 view
		var panel1 = Panel.new()
		panel1.set_margin(MARGIN_RIGHT, 500)
		panel1.set_margin(MARGIN_BOTTOM, 600)
		var viewport1 = Viewport.new()
		var camera1 = camera_scn.instance()
		camera1.player_node = player_node
		add_child(panel1)
		panel1.add_child(viewport1)
		viewport1.add_child(camera1)
		
		# Spawn player 2
		player_node.global_translate(player1_spawn_position)
		player2_node = chibi_player2_scn.instance()
		add_child(player2_node)
		player2_node.global_translate(player2_spawn_position)
		var panel2 = Panel.new()
		panel2.set_margin(MARGIN_LEFT, 524)
		panel2.set_margin(MARGIN_RIGHT, 1024)
		panel2.set_margin(MARGIN_BOTTOM, 600)
		var viewport2 = Viewport.new()
		var camera2 = camera_scn.instance()
		camera2.player_node = player2_node
		add_child(panel2)
		panel2.add_child(viewport2)
		viewport2.add_child(camera2)
		
		# Create background
		var panel_back = Panel.new()
		panel_back.set_margin(MARGIN_RIGHT, 1024)
		panel_back.set_margin(MARGIN_BOTTOM, 600)
		var style = StyleBoxFlat.new()
		style.set_bg_color(Color(255,255,255))
		panel_back.add_child(style)
		panel_back.update()

	if (monsters.size() > 0):
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

func end_game(winning_player):
	var label = Label.new()
	label.set_text(winning_player + " wins!")
	label.set_margin(MARGIN_LEFT, 462)
	label.set_margin(MARGIN_TOP, 400)
	label.set_margin(MARGIN_RIGHT, 568)
	label.set_margin(MARGIN_BOTTOM, 414)
	add_child(label)
	
	var _timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "return_main_menu")
	_timer.set_wait_time(2)
	_timer.set_one_shot(true) # Make sure it loops
	_timer.start()
	
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
			
func return_main_menu():
	get_tree().change_scene("res://Game/Scenes/UI/start_screen.tscn")