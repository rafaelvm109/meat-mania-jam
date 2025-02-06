extends Node2D

# VARIABLES
@onready var lever_handle: Area2D = $LeverHandle
@onready var lever_back: Sprite2D = $LeverBack
@onready var press_upper: Sprite2D = $PressUpper
@onready var press_lower: Area2D = $PressLower
@onready var chicken: Node2D = $"../../Specimen/Chicken"
@onready var sheep: Node2D = $"../../Specimen/Sheep"
@onready var pig: Node2D = $"../../Specimen/Pig"
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
@onready var injector_machine: Node2D = $"../Injector"
@onready var deliver_machine: Node2D = $"../deliver_machine"
@onready var specimen: Node = $"../../Specimen"
@onready var blood_particle: Node2D = $BloodParticle
@onready var press_lights: Sprite2D = $PressLights
@onready var press_lights_2: Sprite2D = $PressLights2
@onready var press_lights_3: Sprite2D = $PressLights3


var subject: Node2D = null # might delete later
var is_processing: bool = false # might use when transforming chicken state
var is_dragging: bool = false # detects lever dragging
var mouse_over: bool = false # detects mouse over lever
var snap_subject: bool = false # determines when to snap 
var lever_start_pos: Vector2 
var lever_end_pos: Vector2
var press_start_pos: Vector2
var press_end_pos: Vector2
var lever_travel_distance: int = 105 # this should be a const later on
var press_travel_distance: int = 200 # this should be a const later on
var smashed_count: int = 0
var can_drag_chicken_press: bool = true  # Determines whether the chicken can be dragged
var is_contacting: bool = true
var current_specimen = null
var lever_in_action = false

# sets start and end position for the lever and press
func _ready() -> void:
	current_specimen = specimen.get_child(0)
	
	lever_start_pos = lever_handle.position
	lever_end_pos = lever_handle.position + Vector2(0, lever_travel_distance)
	press_start_pos = press_upper.position
	press_end_pos = press_upper.position + Vector2(0, press_travel_distance)
	
	lever_handle.connect("mouse_entered", Callable(self, "_on_lever_handle_mouse_entered"))
	lever_handle.connect("mouse_exited", Callable(self, "_on_lever_handle_mouse_exited"))
	press_lower.connect("area_entered", Callable(self, "_on_press_lower_area_entered"))
	press_lower.connect("area_exited", Callable(self, "_on_press_lower_area_exited"))
	print("LeverHandle global position:", lever_handle.global_position)

func _process(delta: float) -> void:
	if snap_subject:
		if smashed_count < 3:
			can_drag_chicken_press = false
	else:
		can_drag_chicken_press = true


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
			if !mangler_machine.is_chicken_draggable() or !oven_machine.is_chicken_draggable() or !injector_machine.is_chicken_draggable() or !deliver_machine.is_chicken_draggable():
				pass
			# if specimen over press snap it into place
			elif snap_subject:
				current_specimen.position = press_lower_collision.global_position + Vector2(0, 60)
			else:
				# will always listen for specimen dropped and snap it to the inventory
				# TODO: I could probbably move this to someplace cleaner
				game_manager.snap_chicken_to_inv()
			# if lever is moved slowly return it back to its starting position alongside the press
			if lever_handle.position.y > lerp(lever_start_pos.y, lever_end_pos.y, 0):
				lever_in_action = true
				var duration = (lever_handle.position.y - lever_start_pos.y) / (lever_end_pos.y - lever_start_pos.y)
				var tween = create_tween()
				var tween2 = create_tween()
				tween.tween_property(lever_handle, "position", (lever_start_pos), duration)
				tween2.tween_property(press_upper, "position", (press_start_pos), duration)
				await tween.finished
				var lever_in_action = false
			if lever_in_action:
				$Off_SFX.playing = true
				$On_SFX.playing = false
				
	# calls drag_lever when mouse is dragging the lever 
	elif is_dragging and event is InputEventMouseMotion:
		drag_lever(event.relative.y)
		if not $On_SFX.is_playing():
			$On_SFX.playing = true
	if event is InputEventMouseMotion:
		if is_contacting and snap_subject:
			if round_first_decimal(lever_handle.position.y, 1) == lerp(lever_start_pos.y, lever_end_pos.y, 1):
				# TODO: add particles effec around here
				blood_particle.start_blood_particles()
				smashed_count += 1
				$Crush_SFX.playing = true
				print("chicken smashed ", smashed_count, " times")
				# allow specimen movemnt, change sprite, and add result to the list
				if smashed_count == 1:
					current_specimen.smash()
					game_manager.append_machine_order(0)
					$Light1.visible = true
				elif smashed_count == 2:
					$Light2.visible = true
				elif smashed_count == 3:
					$Light3.visible = true
					can_drag_chicken_press = true
				elif smashed_count == 4:
					game_manager.unusable_specimen = true
					# TODO: add unsuavble sprite function
					current_specimen.unusable_sprite()
					print("specimen unusable")
					game_manager.append_machine_order(0)
				is_contacting = false
		elif lever_handle.position.y == lerp(lever_start_pos.y, lever_end_pos.y, 0):
			blood_particle.stop_blood_particles()
			is_contacting = true
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
	$Light1.visible = false
	await get_tree().create_timer(0.04).timeout
	$Light2.visible = false
	await get_tree().create_timer(0.04).timeout
	$Light3.visible = false

func is_chicken_draggable() -> bool:
	return can_drag_chicken_press

func round_first_decimal(num, places):
	return (round(num * pow(10, places)) / pow(10, places))
