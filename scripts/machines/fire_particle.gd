extends Node2D

@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var fire_1: CPUParticles2D = $Fire1
@onready var fire_2: CPUParticles2D = $Fire2
@onready var fire_3: CPUParticles2D = $Fire3

var emitting_on: bool = false

func _process(delta: float) -> void:
	if emitting_on:
		fire_1.emitting = true
		fire_2.emitting = true
		fire_3.emitting = true

func play_fire_particles() -> void:
	fire_1.emitting = true
	fire_2.emitting = true
	fire_3.emitting = true

func stop_fire_particles() -> void:
	emitting_on = false
