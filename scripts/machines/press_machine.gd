extends Node2D

# VARIABLES
@onready var lever_handle: Area2D = $LeverHandle
@onready var lever_back: Sprite2D = $LeverBack
@onready var press_upper: Sprite2D = $PressUpper
@onready var press_lower: Area2D = $PressLower
@onready var chicken: Node2D = $"../../Specimen/Chicken"
@onready var press_snap_pos: Marker2D = $"../PressSnapPos"
@onready var inv_1: Panel = $"../../Inventory/CanvasLayer/Control/Inv1"
@onready var inv_2: Panel = $"../../Inventory/CanvasLayer/Control/Inv2"
@onready var inv_3: Panel = $"../../Inventory/CanvasLayer/Control/Inv3"
@onready var inv_4: Panel = $"../../Inventory/CanvasLayer/Control/Inv4"
@onready var collision_shape_2d: CollisionShape2D = $LeverHandle/CollisionShape2D
@onready var chicken_collison: CollisionShape2D = $Subject/CollisionShape2D
@onready var invi_colli: CollisionShape2D = $"../../Specimen/CollisionShape2D"
@onready var chicken_sprite: Sprite2D = $Subject/Sprite2D
@onready var chicken_animation_player: AnimationPlayer = $Subject/AnimationPlayer
@onready var press_lower_collision: CollisionShape2D = $PressLower/CollisionShape2D
@onready var mangler_machine: Node2D = $"../mangler_machine"
@onready var game_manager: Node = $"../../GameManager"
@onready var oven_machine: Node2D = $"../oven_machine"


var subject: Node2D = null # might delete later
var is_processing: bool = false # might use when transforming chicken state
var is_dragging: bool = false # detects lever dragging
var mouse_over: bool = false # detects mouse over lever
var snap_subject: bool = false # determines when to snap 
var lever_start_pos: Vector2 
var lever_end_pos: Vector2
var press_start_pos: Vector2
var press_end_pos: Vector2
var lever_travel_distance: int = 74 # this should be a const later on
var press_travel_distance: int = 100 # this should be a const later on
var smashed_count: int = 0
var can_drag_chicken_press: bool = true  # Determines whether the chicken can be dragged


# sets start and end position for the lever and press
func _ready() -> void:
	lever_start_pos = lever_handle.position
	lever_end_pos = lever_handle.position + Vector2(0, lever_travel_distance)
	press_start_pos = press_upper.position
	press_end_pos = press_upper.position + Vector2(0, press_travel_distance)
	
	lever_handle.connect("mouse_entered", Callable(self, "_on_lever_handle_mouse_entered"))
	lever_handle.connect("mouse_exited", Callable(self, "_on_lever_handle_mouse_exited"))
	press_lower.connect("area_entered", Callable(self, "_on_press_lower_area_entered"))
	press_lower.connect("area_exited", Callable(self, "_on_press_lower_area_exited"))
	print("LeverHandle global position:", lever_handle.global_position)


# listen for mouse input and reacts accordingly
func _input(event: InputEvent) -> void:
	# on mouse event
	if event is InputEventMouseButton:
		# if LMB pressed
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			# and mouse is over the machine
			if mouse_over:
				is_dragging = true
		# release mouse click
		elif event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = false
			# if specimen is in another machine pass
			if !mangler_machine.is_chicken_draggable() or !oven_machine.is_chicken_draggable():
				pass
			# if specimen over press snap it into place
			elif snap_subject:
				chicken.position = press_lower_collision.global_position + Vector2(0, 60)
				# if lever is moved 90% of the way register it as specimen smashed +1
				if lever_handle.position.y >= lerp(lever_start_pos.y, lever_end_pos.y, 0.9):
						# TODO: add particles effec around here
						smashed_count += 1
						print("chicken smashed ", smashed_count, " times")
				# dont let specimen be moved while counter < 3
				if smashed_count < 3:
					can_drag_chicken_press = false
				# allow specimen movemnt, change sprite, and add result to the list
				elif smashed_count == 3:
					can_drag_chicken_press = true
					chicken.smash()
					game_manager.append_machine_order(0)
			else:
				# will always listen for specimen dropped and snap it to the inventory
				# TODO: I could probbably move this to someplace cleaner
				game_manager.snap_chicken_to_inv()
			# if lever is moved slowly return it back to its starting position alongside the press
			if lever_handle.position.y >= lerp(lever_start_pos.y, lever_end_pos.y, 0):
				var duration = (lever_handle.position.y - lever_start_pos.y) / (lever_end_pos.y - lever_start_pos.y)
				var tween = create_tween()
				var tween2 = create_tween()
				tween.tween_property(lever_handle, "position", (lever_start_pos), duration)
				tween2.tween_property(press_upper, "position", (press_start_pos), duration)
				await tween.finished
	# calls drag_lever when mouse is dragging the lever 
	elif is_dragging and event is InputEventMouseMotion:
		drag_lever(event.relative.y)

# moves lever and presss proportionally
func drag_lever(delta_y) -> void:
	# keeps lever value in between start and end pos
	var new_lever_pos_y = clamp(
		lever_handle.position.y + delta_y,
		lever_start_pos.y,
		lever_end_pos.y
	)
	# keeps press value in between start and end pos
	var new_press_pos_y = clamp(
		press_upper.position.y + delta_y,
		press_start_pos.y,
		press_end_pos.y
	)
	
	# moves lever based on clamp val
	lever_handle.position.y = new_lever_pos_y
	
	# calculate the percentage of lever movement and applies the same to the press
	var progress = (lever_handle.position.y - lever_start_pos.y) / (lever_end_pos.y - lever_start_pos.y) # percentage of lever movement
	press_upper.position.y = lerp(press_start_pos.y, press_end_pos.y, progress)


# detect mouse over lever 
func _on_lever_handle_mouse_entered() -> void:
	mouse_over = true  # this doesnt work

# detect mouse off lever
func _on_lever_handle_mouse_exited() -> void:
	mouse_over = false  # this doesnt work

# detects if specimen is entering press lower
func _on_press_lower_area_entered(area: Area2D) -> void:
	snap_subject = true
	
# detects if specimen is exiting press lower
func _on_press_lower_area_exited(area: Area2D) -> void:
	snap_subject = false

func is_chicken_draggable() -> bool:
	return can_drag_chicken_press
