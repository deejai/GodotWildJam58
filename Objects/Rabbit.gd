extends Node3D


var timer: float = randf() * 6.0

enum State { HOPPING, WAITING }
var state: State = State.WAITING

var start_height: float = 0.0
const HOP_VELOCITY: Vector2 = Vector2(2.0, 3.0)
var current_hop_velocity: Vector2 = HOP_VELOCITY
const GRAVITY_FACTOR: float = 9.8
var yspeed: float = 0.0

@export var direction: float = -1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	start_height = position.y
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
		State.HOPPING:
			current_hop_velocity = HOP_VELOCITY * Vector2.ONE * (0.8 + 0.4 * randf())
			position.x += HOP_VELOCITY.x * delta * direction
			var start_yspeed = yspeed
			yspeed -= GRAVITY_FACTOR * delta
			var avg_yspeed = (start_yspeed + yspeed) / 2.0
			position.y += avg_yspeed * delta
			if position.y <= start_height:
				position.y = start_height
				state = State.WAITING
				timer = 2.0 + 8.0 * randf()
