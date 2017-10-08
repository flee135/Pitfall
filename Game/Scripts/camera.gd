extends Camera

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var players;

var zoom = 60;
var normal = 120;
var smooth = 5;
var isZoomed = false;

func _ready():
	set_process(true)
	
func _process(delta):
	players = get_tree().get_nodes_in_group("player_group")
	var totalX = 0
	var totalZ = 0
	var maxX = -10000
	var maxZ = -10000
	var minX = 10000
	var minZ = 10000
	for p in players:
		totalX += p.get_translation().x
		totalZ += p.get_translation().z
		if p.get_translation().x > maxX: maxX = p.get_translation().x
		if p.get_translation().x < minX: minX = p.get_translation().x
		if p.get_translation().z > maxZ: maxZ = p.get_translation().z
		if p.get_translation().z < minZ: minZ = p.get_translation().z

	var centerX = totalX / players.size()
	var centerZ = totalZ / players.size()

	set_translation(Vector3(centerX, 20, centerZ + 4.5))
    
#    float fov = 30*Mathf.Log(Vector3.Distance(new Vector3(maxX, 0, maxZ), new Vector3(minX, 0, minZ)))
#    if (fov < 60) fov = 60
#    if (fov > 80) fov = 80
#    cam.fieldOfView = Mathf.Lerp(cam.fieldOfView, fov, Time.deltaTime * smooth)
