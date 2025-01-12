extends Node2D

var is_dragging: bool = false
var offset: Vector2
var is_smashed: bool = false
var is_processed: bool = false
@onready var subject: Area2D = $Subject
@onready var chicken_collision: CollisionShape2D = $Subject/CollisionShape2D
@onready var press_snap_pos: Marker2D = $"../../Machines/PressSnapPos"
@onready var press_machine: Node2D = $"../../Machines/PressMachine"
@onready var animation_player: AnimationPlayer = $Subject/AnimationPlayer
@onready var mangler_machine: Node2D = $"../../Machines/mangler_machine"


func _input(event: InputEvent) -> void:
	# checks if mouse is clicked over the collision shape and turns drag to on
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if chicken_collision.shape and get_global_mouse_position().distance_to(global_position) < 45:
				if press_machine.is_chicken_draggable() and mangler_machine.is_chicken_draggable():
					is_dragging = true
					offset = global_position - get_global_mouse_position()
		# stop dragging when MB is released
		elif event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = false


func _process(delta: float) -> void:
	# updates chicken pos based on mouse move
	if is_dragging:
		global_position = get_global_mouse_position() + offset


func smash() -> void:
	if !is_smashed:
		animation_player.play("smashed")
		is_smashed = true


func change_chicken_sprite() -> void:
	if !is_processed:
		animation_player.play("change_sprite")
		is_processed = true
