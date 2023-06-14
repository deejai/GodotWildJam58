extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	AudioPlayer.start_rain_sound()
	print("test")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
