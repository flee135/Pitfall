extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("StartScreen/CenterContainer/VBoxContainer/Button").connect("pressed", self, "play")
	
	set_process(true)
	
func _process(delta):
	var size = get_viewport().get_rect().size
	set_size(size)
	
func play():
	var hell_enemy = get_node("StartScreen/CenterContainer/VBoxContainer/EnemyOptions/HellEnemyCheck").is_pressed()
	var fat_enemy = get_node("StartScreen/CenterContainer/VBoxContainer/EnemyOptions/FatEnemyCheck").is_pressed()
	var spawn_wait = get_node("StartScreen/CenterContainer/VBoxContainer/SpawnWaitOption/SpawnWaitInput").get_text()
	var spawn_num = get_node("StartScreen/CenterContainer/VBoxContainer/SpawnNumOption/SpawnNumInput").get_text()
	
#	print(hell_enemy)
#	print(fat_enemy)
#	print(spawn_wait)
#	print(spawn_num)
	
	global.include_hell_enemy = hell_enemy
	global.include_fat_enemy = fat_enemy
	if (spawn_wait != ""):
		global.spawn_wait_time = int(spawn_wait)
	if (spawn_num != ""):
		global.enemies_per_wave = int(spawn_num)
	
#	print(global.include_hell_enemy)
#	print(global.include_fat_enemy)
#	print(global.spawn_wait_time)
#	print(global.enemies_per_wave)
	
	get_tree().change_scene("res://Game/Scenes/Maps/25x25_gridmap.tscn")
#	print("Play!")