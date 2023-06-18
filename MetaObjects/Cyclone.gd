extends Node3D

var leaf_scene: PackedScene = load("res://Objects/Leaf.tscn")
var twig_scene: PackedScene = load("res://Objects/Twig.tscn")

var object_pool: Array = []
var spawned_object_pool: Array = []

var spawn_timer_wait_time: float = 0.01
var spawn_timer: float = 0.00

var cyclone_participants: Dictionary = {}

const MAX_HEIGHT = 20.0

var already_cycloned: Array = []

var stopsucking_timer: float = 6.5

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(120):
		var leaf = leaf_scene.instantiate()
		object_pool.push_back(leaf)

		var twig = twig_scene.instantiate()
		object_pool.push_back(twig)

	object_pool.shuffle()

	for obj in object_pool:
		obj.scale *= 0.8 + 0.4 * randf()
		obj.rotate(Vector3.BACK, 2 * PI * randf())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spawn_timer -= delta
	stopsucking_timer -= delta

	if spawn_timer <= 0.0:
		if object_pool.is_empty() == false:
			var next_obj = object_pool.pop_back()
			spawned_object_pool.push_back(next_obj)
			add_child(next_obj)

			if object_pool.size() < 25:
				spawn_timer_wait_time += 0.01

			spawn_timer = spawn_timer_wait_time

	for obj in spawned_object_pool:
		spiral_particle(obj, delta)
		if obj.position.y > MAX_HEIGHT:
			spawned_object_pool.erase(obj)
			obj.queue_free()

	if spawned_object_pool.is_empty():
		queue_free()

	for key in cyclone_participants.keys():
		var dict = cyclone_participants[key]

		if is_instance_valid(dict.obj) == false:
			cyclone_participants.erase(key)
			return

		if dict.obj.position.y > 12.0 or spawned_object_pool.is_empty() or stopsucking_timer <= 0.0:
			already_cycloned.append(dict.obj.get_instance_id())
			dict.obj.unstun()
			cyclone_participants.erase(key)
			return

		dict.origin.x += delta * .03 * signf(position.x - dict.origin.x)
		if position.x - dict.origin.x < 0.01:
			dict.origin.x = position.x

		spiral_participant(dict.obj, delta, dict.origin)

func _on_area_3d_area_entered(area):
	var obj: Node3D = area.get_parent()
	if (obj is Rabbit) and (obj.get_instance_id() not in already_cycloned) and (obj.state != Rabbit.State.STUNNED):
		obj.stun()
		cyclone_participants[obj.get_instance_id()] = {"obj": obj, "origin": obj.position}

func spiral_particle(obj: Node3D, delta:float):
	var height_progress = obj.position.y/MAX_HEIGHT
	obj.position.y += (2.0 + 2.0 * obj.rng) * (1.2 - height_progress/2.0) * delta
	obj.position.z = (0.25 + 10.0 * height_progress/2.0) * sin(1.5 * (1.0 + obj.rng) * (obj.position.y + (2*PI*obj.rng)))
	obj.position.x = (0.25 + 10.0 * height_progress/2.0) * cos(1.5 * (1.0 + obj.rng) * (obj.position.y + (2*PI*obj.rng)))

func spiral_participant(obj: Node3D, delta:float, origin_pos: Vector3):
	obj.position.y += 2.0 * delta
	obj.position.z = origin_pos.z + sin(0.5 * ((obj.position.y - origin_pos.y)))
	obj.position.x = origin_pos.x + cos(1.25 * ((obj.position.y - origin_pos.y)))
