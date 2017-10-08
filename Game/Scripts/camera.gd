extends Camera

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var player_node;

var height = 20;

func _ready():
	#player_node = get_node("/root/Node/GameManager/RigidBody")
	set_process(true)
	
func _process(delta):
	var centerX = player_node.get_translation().x
	var centerZ = player_node.get_translation().z
	set_translation(Vector3(centerX, height, centerZ + 4.5))
