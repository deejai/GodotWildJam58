extends Node3D

class_name Cloud

@onready var anchor: StaticBody3D = $Anchor
@onready var rig: RigidBody3D = $Rig

var timer: float
var mode: Mode = Mode.WAIT
enum Mode { MOVE, WAIT }

@onready var zap_sprite: Sprite3D = $Rig/ZapSprite
var zap_timer: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = 2.0 * randf()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= delta
	match(mode):
		Mode.MOVE:
			anchor.position.x += 0.25 * delta * (0.8 + 0.4 * randf())
			if timer <= 0.0:
				timer = 1.0 + randf() * 1.0
				mode = Mode.WAIT
		Mode.WAIT:
			if timer <= 0.0:
				timer = 2.5 + randf()
				mode = Mode.MOVE

	if anchor.global_position.x > Main.extent_right + 2.0:
		anchor.global_position.x = Main.extent_left - 2.0
		rig.global_position.x = Main.extent_left - 2.0
		rig.linear_velocity = Vector3.ZERO
		rig.angular_velocity = Vector3.ZERO

	zap_timer -= delta
	if zap_timer <= 0.0:
		zap_sprite.visible = false

func zap():
	zap_timer = 1.0
	zap_sprite.visible = true
	AudioPlayer.play_at_position(get_parent(), position, SelfRemovingSound.Sound.ZAP)
	Main.game_camera.lightning_flash()
