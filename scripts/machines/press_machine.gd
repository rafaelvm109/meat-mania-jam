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
var can_drag_chicken: bool = true  # Determines whether the chicken can be dragged


# TODO: setup inventory snap (just need to set a Marker and add an if statement)
# TODO: add a counter for # of time chicken has been smashed
# TODO: alter chicken form after being smashed
# TODO: alter chicken sprite after # times
# TODO: add indications for particles later on
# TODO: Create an actual main scene

# sets start and end position for the lever and press
func _ready() -> void:
	lever_start_pos = lever_handle.position
	lever_end_pos = lever_handle.position + Vector2(0, lever_travel_distance)
	press_start_pos = press_upper.position
	press_end_pos = press_upper.position + Vector2(0, press_travel_distance)
	chicken.position = inv_1.global_position + (inv_1.size / 2)
	
	lever_handle.connect("mouse_entered", Callable(self, "_on_lever_handle_mouse_entered"))
	lever_handle.connect("mouse_exited", Callable(self, "_on_lever_handle_mouse_exited"))
	press_lower.connect("area_entered", Callable(self, "_on_press_lower_area_entered"))
	press_lower.connect("area_exited", Callable(self, "_on_press_lower_area_exited"))
	print("LeverHandle global position:", lever_handle.global_position)


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


# listen for mouse input and reacts accordingly
func _input(event: InputEvent) -> void:
	# checks mouse click on lever, turns drag to on
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_over:
				is_dragging = true
		# release mouse click
		elif event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = false
			# checks bottom position if chicken present and smash < x
				#process_subject() 
			if snap_subject:
				chicken.position = press_snap_pos.position
				if smashed_count < 3:
					can_drag_chicken = false
					if lever_handle.position.y >= lerp(lever_start_pos.y, lever_end_pos.y, 0.9):
						# add particles effec around here
						chicken.smash()
						smashed_count += 1
						print("chicken smashed ", smashed_count, " times")
				else:
					can_drag_chicken = true
				if smashed_count == 3:
					chicken.change_chicken_sprite()
			else:
				chicken.position = inv_1.global_position + (inv_1.size / 2)
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


# TODO: use this function for changing chicken sprite
func process_subject() -> void:
	if subject and !is_processing:
		is_processing = true
		output_processed_subject()


# TODO: might merge with above function
func output_processed_subject() -> void:
	pass
	#if subject:
		## substitute subject for the output
		##subject.queue_free() # remove original to replace with new sprite
		##var altered_subject = PackedScene.new().instance()
		#altered_subject.position = output_pos.global_position
		#add_child(altered_subject)
		#is_processing = false


func is_chicken_draggable() -> bool:
	return can_drag_chicken
