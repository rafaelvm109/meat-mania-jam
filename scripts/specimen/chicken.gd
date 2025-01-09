extends Node2D

var is_dragging: bool = false
var offset: Vector2
@onready var subject: Area2D = $Subject
@onready var chicken_collision: CollisionShape2D = $Subject/CollisionShape2D


func _input(event: InputEvent) -> void:
	# checks if mouse is clicked over the collision shape and turns drag to on
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if chicken_collision.shape and get_global_mouse_position().distance_to(global_position) < 45:
				is_dragging = true
				offset = global_position - get_global_mouse_position()
		# stop dragging when MB is released
		elif event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = false
			# TODO: add Marker2D to the inventory and make the chicken snap into place if released outside of machine range


func _process(delta: float) -> void:
	# updates chicken pos based on mouse move
	if is_dragging:
		global_position = get_global_mouse_position() + offset
