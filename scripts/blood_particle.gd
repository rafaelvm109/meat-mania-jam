extends Node2D

@onready var blood: CPUParticles2D = $Blood
@onready var blood_2: CPUParticles2D = $Blood2
@onready var blood_3: CPUParticles2D = $Blood3
@onready var blood_4: CPUParticles2D = $Blood4
@onready var meat: CPUParticles2D = $meat

var emitting_on: bool = false

func _process(delta: float) -> void:
	if emitting_on:
		blood.emitting = true
		blood_2.emitting = true
		blood_3.emitting = true
		blood_4.emitting = true
		meat.emitting = true

func start_blood_particles() -> void:
	emitting_on = true

func stop_blood_particles() -> void:
	emitting_on = false
