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
	get_tree().change_scene("res://Game/Scenes/Maps/25x25_gridmap.tscn")
	print("Play!")