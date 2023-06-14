extends Node3D

var droplet_scene: PackedScene = load("res://Objects/Droplet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var nrows = 60
	var ncols = 10
	var nplanes = 5
	for row in range(nrows):
		for col in range(ncols):
			for plane in range(nplanes):
				var droplet = droplet_scene.instantiate()
				droplet.position = Vector3(-1.3 + (col - ncols * 0.5) * 1.7, 25.0 + row * 3.0, -6.0 - 3.0 * plane) + Vector3.ONE * randf() * 3.0
				droplet.starting_position = droplet.position
				droplet.position += Vector3.DOWN * 35.0
				add_child(droplet)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
