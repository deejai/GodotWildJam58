extends Node2D

@onready var start_button_leaves: Node2D = $CanvasLayer/StartButtonLeaves
var start_button_leaves_original_pos: Vector2
var progress_tracker: float = 0.0
const TIME_PER_CYCLE: float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button_leaves_original_pos = start_button_leaves.position
	$AudioStreamPlayer.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress_tracker = fmod(progress_tracker + (2.0 * PI / TIME_PER_CYCLE) * delta, 2 * PI)
	start_button_leaves.position = Vector2(cos(progress_tracker), sin(progress_tracker))

	if Input.is_action_just_pressed("Continue"):
		Main.to_main_menu()

func _on_button_pressed():
	Main.to_main_menu()
