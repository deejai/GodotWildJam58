extends Node3D

var original_rotation: float
const TOTAL_ROTATION: float = PI / 48
var progress_tracker: float = randf() * 2 * PI
const TIME_PER_CYCLE: float = 4.0

# Called when the node enters the scene tree for the first time.
func _ready():
	original_rotation = rotation.z

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress_tracker = fmod(progress_tracker + (2 * PI / TIME_PER_CYCLE) * delta, 2 * PI)
	rotation.z = original_rotation + sin(progress_tracker) * (TOTAL_ROTATION/2.0)
