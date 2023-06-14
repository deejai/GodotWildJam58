extends Node

@onready var anchor: StaticBody3D = $Anchor
@onready var rig: RigidBody3D = $Rig

var timer: float = 0.0
var mode: Mode = Mode.WAIT
enum Mode { MOVE, WAIT }

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = randf()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= delta
	match(mode):
		Mode.MOVE:
			anchor.position.x += 0.35 * delta * (0.8 + 0.2 * randf())
			if timer <= 0.0:
				timer = 0.8 + randf() * 0.4
				mode = Mode.WAIT
		Mode.WAIT:
			if timer <= 0.0:
				timer = 2.5 + randf()
				mode = Mode.MOVE
#				rig.apply_central_impulse(Vector3.RIGHT * 2.0)
