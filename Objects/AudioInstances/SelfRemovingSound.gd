extends Node3D

class_name SelfRemovingSound

enum Sound { NONE, ZAP }
var sound: Sound = Sound.NONE

var player: AudioStreamPlayer3D = null

func _ready():
	player = get_player()
	if player == null:
		queue_free()
		return

	player.play()

func _process(delta):
	if player == null:
		queue_free()
		return

	if not player.playing:
		queue_free()

func get_player():
	match(sound):
		Sound.ZAP:
			return $Zap
		_:
			return null
