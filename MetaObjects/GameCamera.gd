extends Camera3D

var can_flash: bool = true
@onready var lightning_flash_1_timer: Timer = $LightningFlash1
@onready var lightning_flash_wait_timer: Timer = $LightningFlashWait
@onready var lightning_flash_2_timer: Timer = $LightningFlash2
@onready var white_flash_mesh: MeshInstance3D = $WhiteFlash

# Called when the node enters the scene tree for the first time.
func _ready():
	Main.game_camera = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func lightning_flash():
	if can_flash == false:
		return

	can_flash = true

	white_flash_mesh.visible = true
	lightning_flash_1_timer.start()

func _on_lightning_flash_1_timeout():
	white_flash_mesh.visible = false
	lightning_flash_wait_timer.start()

func _on_lightning_flash_wait_timeout():
	white_flash_mesh.visible = true
	lightning_flash_2_timer.start()

func _on_lightning_flash_2_timeout():
	white_flash_mesh.visible = false
	can_flash = true
