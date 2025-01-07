extends Node2D

var is_dragging: bool = false
var offset: Vector2
@onready var chicken_collision: CollisionShape2D = $Subject/StaticBody2D/CollisionShape2D


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


func _process(delta: float) -> void:
	# updates chicken pos based on mouse move
	if is_dragging:
		global_position = get_global_mouse_position() + offset
