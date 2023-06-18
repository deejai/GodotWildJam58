extends Node3D

class_name Rabbit

var timer: float = randf() * 6.0

enum State { HOPPING, WAITING, STUNNED }
var state: State = State.WAITING

var start_height: float = 0.0
var start_z: float = 0.0
const HOP_VELOCITY: Vector2 = Vector2(2.0, 3.0)
var current_hop_velocity: Vector2 = HOP_VELOCITY
const GRAVITY_FACTOR: float = 9.8
var yspeed: float = 0.0

@export var direction: float = -1.0

var blood_particles_scene: PackedScene = preload("res://Objects/Particles/BloodParticles.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	start_height = position.y
	start_z = position.z
	if direction > 0.0:
		$rabbit.flip_h = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match(state):
		State.WAITING:
			timer -= delta
			if timer <= 0.0:
				state = State.HOPPING
				yspeed = HOP_VELOCITY.y
				position.y += 0.01
			if position.y > start_height:
				yspeed -= GRAVITY_FACTOR * delta
				position.y += yspeed * delta
			if position.y <= start_height:
				yspeed = 0.0
				position.y = start_height
		State.HOPPING:
			current_hop_velocity = HOP_VELOCITY * Vector2.ONE * (0.8 + 0.4 * randf())
			position.x += current_hop_velocity.x * delta * direction
			var start_yspeed = yspeed
			yspeed -= GRAVITY_FACTOR * delta
			var avg_yspeed = (start_yspeed + yspeed) / 2.0
			position.y += avg_yspeed * delta
			if position.y < start_height:
				yspeed = 0.0
				state = State.WAITING
				position.y = start_height
				timer = 2.0 + 8.0 * randf()

		State.STUNNED:
			pass

func stun():
	yspeed = 0.0
	state = State.STUNNED

func unstun():
	state = State.WAITING
	timer = 4.0 + randf()
	position.z = start_z

func _on_area_3d_body_entered(body):
	var obj = body.get_parent()
	if obj is Cloud:
		obj.zap()
		var blood_particles = blood_particles_scene.instantiate()
		blood_particles.position = position
		get_parent().add_child(blood_particles)
		Main.rabbits_killed += 1
		AudioPlayer.play_kill_rabit_voice()
		queue_free()
