extends Node3D

@onready var particles: CPUParticles3D = $CPUParticles3D

func _ready():
	particles.emitting = true

func _process(delta):
	if particles.emitting == false:
		queue_free()
