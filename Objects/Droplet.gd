extends Node3D

var starting_position = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= 15.0 * delta
	if position.y <= -10.0:
		position = starting_position + Vector3.ONE * 3.0 * randf()
