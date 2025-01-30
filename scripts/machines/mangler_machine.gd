extends Node2D

@onready var mangler_body: Sprite2D = $ManglerBody
@onready var slider_back: Sprite2D = $SliderBack
@onready var slider_handle: Area2D = $SliderHandle
@onready var slider_handle_collision: CollisionShape2D = $SliderHandle/CollisionShape2D
@onready var specimen_area: Area2D = $SpecimenArea
@onready var specimen_collision: CollisionShape2D = $SpecimenArea/CollisionShape2D
@onready var saw_blade: Sprite2D = $SawBlade
@onready var saw_static_body_2d: StaticBody2D = $SawBlade/StaticBody2D
@onready var chicken: Node2D = $"../../Specimen/Chicken"
@onready var inv_1: Panel = $"../../Inventory/CanvasLayer/Control/Inv1"
@onready var inv_2: Panel = $"../../Inventory/CanvasLayer/Control/Inv2"
@onready var inv_3: Panel = $"../../Inventory/CanvasLayer/Control/Inv3"
@onready var inv_4: Panel = $"../../Inventory/CanvasLayer/Control/Inv4"
@onready var press_machine: Node2D = $"../PressMachine"
@onready var game_manager: Node = $"../../GameManager"
@onready var oven_machine: Node2D = $"../oven_machine"
@onready var injector_machine: Node2D = $"../Injector"
@onready var deliver_machine: Node2D = $"../deliver_machine"
@onready var specimen: Node = $"../../Specimen"
@onready var blood_particle: Node2D = $BloodParticle
'''@onready var mangler_lights = [
	$ManglerLights1,
	$ManglerLights2,
	$ManglerLights3,
	$ManglerLights4,
	$ManglerLights5,
	$ManglerLights6

]'''
@onready var mangler_lights = [
	$Light1,
	$Light2,
	$Light3,
	$Light4,
	$Light5,
	$Light6	
]

var is_dragging_mangler: bool = false # detects lever dragging
var mouse_over_slider: bool = false # detects mouse over lever
var snap_mangler_subject: bool = false # determines when to snap 
var slider_start_pos: Vector2 
var slider_end_pos: Vector2
var saw_start_pos: Vector2
var saw_end_pos: Vector2
var slider_travel_distance: int = 155 # this should be a const later on
var saw_travel_distance: int = 220 # this should be a const later on
var mangled_count: int = 0 # determines number of times saw has passed through the specimen
var can_drag_chicken_mangler: bool = true  # Determines whether the chicken can be dragged
var is_contacting: bool = true
var saw_coming_back: bool = false
var current_specimen = null
var light_bool = false

func _ready() -> void:
	current_specimen = specimen.get_child(0)
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
		

func _process(delta: float) -> void:	
	if snap_mangler_subject:
		if mangled_count < 5:
			can_drag_chicken_mangler = false
	else:
		can_drag_chicken_mangler = true


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
			if !press_machine.is_chicken_draggable() or !oven_machine.is_chicken_draggable() or !injector_machine.is_chicken_draggable() or !deliver_machine.is_chicken_draggable():
				pass
			elif snap_mangler_subject:
				# snaps specimen to the machine
				current_specimen.position = specimen_collision.global_position + Vector2(0, 60)
			# whenever slider is moved make it slowly return to starting position in a variable duration depending on how far it was moved
			if slider_handle.position.x >= lerp(slider_start_pos.x, slider_end_pos.x, 0):
				var duration = (slider_handle.position.x - slider_start_pos.x) / (slider_end_pos.x - slider_start_pos.x)
				var tween = create_tween()
				var tween2 = create_tween()
				saw_coming_back = true
				tween.tween_property(slider_handle, "position", (slider_start_pos), duration)
				tween2.tween_property(saw_blade, "position", (saw_start_pos), duration)
				await tween.finished
				saw_coming_back = false
				
			
	# calls drag_lever when mouse is dragging the lever 
	elif is_dragging_mangler and event is InputEventMouseMotion:
		drag_slider(event.relative.x)
	
	if event is InputEventMouseMotion:
		if is_contacting and snap_mangler_subject:
			if slider_handle.position.x >= lerp(slider_start_pos.x, slider_end_pos.x, 0.4) and slider_handle.position.x <= lerp(slider_start_pos.x, slider_end_pos.x, 0.6):
				if !saw_coming_back:
					# TODO: add particles effec around here
					blood_particle.start_blood_particles()
					mangled_count += 1
					print("chicken mangled ", mangled_count, " times")
					if mangled_count < 7:
						mangler_lights[mangled_count-1].visible = true
					if mangled_count == 6:
						can_drag_chicken_mangler = true
						current_specimen.dice()
						game_manager.append_machine_order(1)
					elif mangled_count == 12:
						game_manager.unusable_specimen = true
						current_specimen.unusable_sprite()
						print("unusable specimen")
						game_manager.append_machine_order(1)
					is_contacting = false
		if slider_handle.position.x <= lerp(slider_start_pos.x, slider_end_pos.x, 0.1) or slider_handle.position.x >= lerp(slider_start_pos.x, slider_end_pos.x, 0.9):
			blood_particle.stop_blood_particles()
			is_contacting = true
		
		
			
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
	for i in range (6):
		mangler_lights[i].visible = false
		await get_tree().create_timer(0.04).timeout

func is_chicken_draggable() -> bool:
	return can_drag_chicken_mangler

func round_first_decimal(num, places):
	return (round(num * pow(10, places)) / pow(10, places))
