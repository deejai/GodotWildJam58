extends Node3D

var droplet_scene: PackedScene = load("res://Objects/Droplet.tscn")

func _ready():
	var nrows = 60
	var ncols = 10
	var nplanes = 5
	for row in range(nrows):
		for col in range(ncols):
			for plane in range(nplanes):
				var droplet = droplet_scene.instantiate()
				droplet.position = Vector3(-3.8 + (col - ncols * 0.5) * 2.6, 25.0 + row * 3.0, -8.0 - 3.0 * plane) + Vector3.ONE * randf() * 3.0
				droplet.starting_position = droplet.position
				droplet.position += Vector3.DOWN * 35.0
				get_parent().add_child.call_deferred(droplet)

func _process(delta):
	pass
