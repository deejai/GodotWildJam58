extends Node2D

var self_removing_sound_scene: PackedScene = load("res://Objects/AudioInstances/SelfRemovingSound.tscn")

var VOICE_CD: float = 3.0
var voice_line_timer: float = 0.0

@onready var kill_rabbit_player: AudioStreamPlayer = $KillRabbitPlayer
@onready var player_hurt_player: AudioStreamPlayer = $PlayerHurtPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	voice_line_timer = max(0.0, voice_line_timer - delta)

func start_rain_sound():
	$RainLoop.play()

func play_at_position(root: Node3D, position: Vector3, sound: SelfRemovingSound.Sound):
	var sound_instance: SelfRemovingSound = self_removing_sound_scene.instantiate()
	sound_instance.sound = sound
	sound_instance.position = position
	root.add_child(sound_instance)

func play_kill_rabit_voice():
	if voice_line_timer > 0.0:
		return
	
	voice_line_timer = VOICE_CD
	kill_rabbit_player.play()

func play_player_hurt_voice():
	if voice_line_timer > 0.0:
		return

	voice_line_timer = VOICE_CD
	player_hurt_player.play()
