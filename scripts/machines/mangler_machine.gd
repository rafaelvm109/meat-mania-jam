extends Node2D

@onready var mangler_body: Sprite2D = $ManglerBody
@onready var slider_back: Sprite2D = $SliderBack
@onready var slider_handle: Area2D = $SliderHandle
@onready var slider_handle_collision: CollisionShape2D = $SliderHandle/CollisionShape2D
@onready var specimen_area: Area2D = $SpecimenArea
@onready var specimen_collision: CollisionShape2D = $SpecimenArea/CollisionShape2D
@onready var saw_blade: Sprite2D = $SawBlade
@onready var chicken: Node2D = $"../../Specimen/Chicken"
@onready var inv_1: Panel = $"../../Inventory/CanvasLayer/Control/Inv1"
@onready var inv_2: Panel = $"../../Inventory/CanvasLayer/Control/Inv2"
@onready var inv_3: Panel = $"../../Inventory/CanvasLayer/Control/Inv3"
@onready var inv_4: Panel = $"../../Inventory/CanvasLayer/Control/Inv4"
@onready var press_machine: Node2D = $"../PressMachine"
@onready var game_manager: Node = $"../../GameManager"
@onready var oven_machine: Node2D = $"../oven_machine"

var is_dragging_mangler: bool = false # detects lever dragging
var mouse_over_slider: bool = false # detects mouse over lever
var snap_mangler_subject: bool = false # determines when to snap 
var slider_start_pos: Vector2 
var slider_end_pos: Vector2
var saw_start_pos: Vector2
var saw_end_pos: Vector2
var slider_travel_distance: int = 98 # this should be a const later on
var saw_travel_distance: int = 158 # this should be a const later on
var mangled_count: int = 0 # determines number of times saw has passed through the specimen
var can_drag_chicken_mangler: bool = true  # Determines whether the chicken can be dragged


func _ready() -> void:
	# sets the start and end pos for the slider and saw
	slider_start_pos = slider_handle.position
	slider_end_pos = slider_handle.position + Vector2(slider_travel_distance, 0)
	saw_start_pos = saw_blade.position
	saw_end_pos = saw_blade.position + Vector2(saw_travel_distance, 0)
	
	# mannually connect mouse and area entered functions
	slider_handle.connect("mouse_entered", Callable(self, "_on_slider_handle_mouse_entered"))
	slider_handle.connect("mouse_exited", Callable(self, "_on_slider_handle_mouse_exited"))
	specimen_area.connect("area_entered", Callable(self, "_on_specimen_area_entered"))
	specimen_area.connect("area_exited", Callable(self, "_on_specimen_area_exited"))



func _input(event: InputEvent) -> void:
	# on mouse input
	if event is InputEventMouseButton:
		# if LMB is pressed
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			# abd mouse is over the slider
			if mouse_over_slider:
				is_dragging_mangler = true
		# release mouse click
		elif event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging_mangler = false
			# do nothing if chicken is in another machine
			if !press_machine.is_chicken_draggable() or !oven_machine.is_chicken_draggable():
				pass
			elif snap_mangler_subject:
				# snaps specimen to the machine
				chicken.position = specimen_collision.global_position + Vector2(0, 60)
				# if the slider reaches 90% consider mangler activated
				if slider_handle.position.x >= lerp(slider_start_pos.x, slider_end_pos.x, 0.9):
						# TODO: add particles effec around here
						mangled_count += 1
						print("chicken mangled ", mangled_count, " times")
				# does not allow specimen to be dragged while < 5
				if mangled_count < 5:
					can_drag_chicken_mangler = false
				# changes specimen sprite and appends result to the list
				elif mangled_count == 5:
					can_drag_chicken_mangler = true
					chicken.dice()
					game_manager.append_machine_order(1)
			# whenever slider is moved make it slowly return to starting position in a variable duration depending on how far it was moved
			if slider_handle.position.x >= lerp(slider_start_pos.x, slider_end_pos.x, 0):
				var duration = (slider_handle.position.x - slider_start_pos.x) / (slider_end_pos.x - slider_start_pos.x)
				var tween = create_tween()
				var tween2 = create_tween()
				tween.tween_property(slider_handle, "position", (slider_start_pos), duration)
				tween2.tween_property(saw_blade, "position", (saw_start_pos), duration)
				await tween.finished
	# calls drag_lever when mouse is dragging the lever 
	elif is_dragging_mangler and event is InputEventMouseMotion:
		drag_slider(event.relative.x)


# moves lever and presss proportionally
func drag_slider(delta_y) -> void:
	# keeps lever value in between start and end pos
	var new_slider_pos_x = clamp(
		slider_handle.position.x + delta_y,
		slider_start_pos.x,
		slider_end_pos.x
	)
	# keeps press value in between start and end pos
	var new_saw_pos_x = clamp(
		saw_blade.position.x + delta_y,
		saw_start_pos.x,
		saw_end_pos.x
	)
	
	# moves lever based on clamp val
	slider_handle.position.x = new_slider_pos_x
	
	# calculate the percentage of lever movement and applies the same to the press
	var progress = (slider_handle.position.x - slider_start_pos.x) / (slider_end_pos.x - slider_start_pos.x) # percentage of lever movement
	saw_blade.position.x = lerp(saw_start_pos.x, saw_end_pos.x, progress)


# detect mouse over lever 
func _on_slider_handle_mouse_entered() -> void:
	mouse_over_slider = true  # this doesnt work

# detect mouse off lever
func _on_slider_handle_mouse_exited() -> void:
	mouse_over_slider = false  # this doesnt work

# detects if specimen is entering press lower
func _on_specimen_area_entered(area: Area2D) -> void:
	snap_mangler_subject = true
	
# detects if specimen is exiting press lower
func _on_specimen_area_exited(area: Area2D) -> void:
	snap_mangler_subject = false


func is_chicken_draggable() -> bool:
	return can_drag_chicken_mangler
