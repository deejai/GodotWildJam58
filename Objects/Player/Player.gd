extends Node3D

class_name Player

var original_y_pos: float
var resting_x_pos: float

const movespeed: float = 1.3

@onready var sprite: Sprite3D = $Sprite3D

@export var active: bool = true

@onready var cyclone_spawner_indicator: Node3D = $ClycloneSpawnerIndicator
@onready var cyclone_spawner_sprite: Sprite3D = $ClycloneSpawnerIndicator/CycloneSpawnerSprite
@onready var cyclone_cd_timer: Timer = $CycloneCD
@onready var cyclone_progress_material: Material = $ClycloneSpawnerIndicator/ProgressMesh.get_active_material(0)
var cyclone_spawner_original_pos: Vector3
var cyclone_scene: PackedScene = preload("res://MetaObjects/Cyclone.tscn")
const CYCLONE_CHARGE_COLOR: Vector3 = Vector3(0.9, 1.0, 0.75)
const CYCLONE_CHARGE_ALPHA: float = 0.45
const CYCLONE_CD_COLOR: Vector3 = Vector3(.6, .7, .65)
const CYCLONE_CD_ALPHA: float = 0.35
const CYCLONE_CHARGE_TIME: float = 1.2
var cyclone_progress: float = 0.0
var cyclone_indicator_idle_movement: float = 0.0
var cyclone_indicator_center_x: float = 0.0

var stun_timer: float = 0.0

func _ready():
	print(get_viewport().get_final_transform())
	original_y_pos = position.y
	resting_x_pos = position.x
	cyclone_spawner_original_pos = cyclone_spawner_indicator.position
	cyclone_progress_material.set_shader_parameter("color", CYCLONE_CD_COLOR)
	cyclone_progress_material.set_shader_parameter("alpha", CYCLONE_CD_ALPHA)

	$intro_line.play()

func _process(delta):
	if not active:
		cyclone_spawner_indicator.visible = false
		return

	stun_timer = max(0.0, stun_timer - delta)

	var move_dir: float = Input.get_axis("Walk Left", "Walk Right")
	if stun_timer > 0.0 or move_dir == 0.0:
		resting_x_pos = position.x
		position.y -= 1.0 * delta
		if position.y < original_y_pos:
			position.y = original_y_pos
		
		if stun_timer > 0.0:
			position.x -= 12.0 * delta
	else:
		var x_move: float = move_dir * movespeed * delta
		position.x += x_move
		position.y = original_y_pos + 0.07 * abs(sin(6.0 * (position.x - resting_x_pos)))

	position.x = clampf(position.x, Main.extent_left + 3.0, Main.extent_right - 2.5)

	# Idk why I had to add 0.9 here for it to look right, but it works
	var intersect_plane = Plane(Vector3(0, 0, 1), position.z + 0.9)

	var from = Main.game_camera.project_ray_origin(get_viewport().get_mouse_position())
	var to = from + Main.game_camera.project_ray_normal(get_viewport().get_mouse_position()) * 100
	var cursorPos = intersect_plane.intersects_ray(from, to)

	if cursorPos:
		sprite.flip_h = cursorPos.x < position.x

	cyclone_spawner_indicator.visible = true
	cyclone_indicator_idle_movement = fmod(cyclone_indicator_idle_movement + delta, 2 * PI)

	var cyclone_spawner_target_x: float = (2.0 * (-1.0 if sprite.flip_h else 1.0))
	cyclone_indicator_center_x += (cyclone_spawner_target_x - cyclone_indicator_center_x) * (1.0 - pow(0.1, delta))

	cyclone_spawner_indicator.position.x = cyclone_indicator_center_x + 0.25 * cos(cyclone_indicator_idle_movement)
	cyclone_spawner_indicator.position.y = cyclone_spawner_original_pos.y + original_y_pos-position.y + 0.125 * sin(2.0 * cyclone_indicator_idle_movement)

	if Input.is_action_pressed("Spawn Cyclone") and cyclone_cd_timer.is_stopped():
		cyclone_progress = min(1.0, cyclone_progress + delta / CYCLONE_CHARGE_TIME)

		if cyclone_progress == 1.0:
			var cyclone = cyclone_scene.instantiate()
			cyclone.position = Vector3(cyclone_spawner_indicator.global_position.x, 0.0, position.z)
			get_parent().add_child(cyclone)
			cyclone_cd_timer.start()
			cyclone_progress_material.set_shader_parameter("color", CYCLONE_CD_COLOR)
			cyclone_progress_material.set_shader_parameter("alpha", CYCLONE_CD_ALPHA)
	else:
		if cyclone_cd_timer.is_stopped():
			cyclone_progress = 0.0
		else:
			cyclone_progress = cyclone_cd_timer.time_left / cyclone_cd_timer.wait_time

	cyclone_progress_material.set_shader_parameter("progress", cyclone_progress)


func _on_cyclone_cd_timeout():
	cyclone_progress_material.set_shader_parameter("color", CYCLONE_CHARGE_COLOR)
	cyclone_progress_material.set_shader_parameter("alpha", CYCLONE_CHARGE_ALPHA)

func knockback():
	stun_timer = 0.125
	AudioPlayer.play_player_hurt_voice()

func _on_area_3d_area_entered(area):
	if area.get_parent() is Rabbit:
		knockback()
