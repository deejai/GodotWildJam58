extends Node3D

var level_finish_timer: float = 3.0
var finished: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Main.rabbits_killed = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if finished:
		level_finish_timer -= delta
		if level_finish_timer <= 0.0:
			Main.thanks_for_playing()

	elif Main.rabbits_killed >= 10:
		finished = true
