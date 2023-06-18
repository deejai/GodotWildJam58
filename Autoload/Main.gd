extends Node

var game_camera: Camera3D = null

var extent_left: float = -16
var extent_right: float = 16

var rabbits_killed: int = 0

var level1: PackedScene = load("res://Views/Levels/Level1.tscn")
var main_menu: PackedScene = load("res://Views/MainMenu/MainMenu.tscn")
var thanks: PackedScene = load("res://Views/ThanksForPlaying/Thanks.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioPlayer.start_rain_sound()
	print("test")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_game():
	get_tree().change_scene_to_packed(level1)

func thanks_for_playing():
	get_tree().change_scene_to_packed(thanks)

func to_main_menu():
	get_tree().change_scene_to_packed(main_menu)
