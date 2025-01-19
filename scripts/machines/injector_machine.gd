extends Node2D

@onready var press_machine: Node2D = $"../PressMachine"
@onready var mangler_machine: Node2D = $"../mangler_machine"
@onready var oven_machine: Node2D = $"../oven_machine"
@onready var deliver_machine: Node2D = $"../deliver_machine"
@onready var chicken: Node2D = $"../../Specimen/Chicken"


@onready var needle: Sprite2D = $Needle
@onready var numpad_container: GridContainer = $Numpad/NumpadContainer
@onready var one_area: Area2D = $Numpad/NumpadContainer/OneArea
@onready var two_area: Area2D = $Numpad/NumpadContainer/TwoArea
@onready var three_area: Area2D = $Numpad/NumpadContainer/ThreeArea
@onready var four_area: Area2D = $Numpad/NumpadContainer/FourArea
@onready var five_area: Area2D = $Numpad/NumpadContainer/FiveArea
@onready var six_area: Area2D = $Numpad/NumpadContainer/SixArea
@onready var seven_area: Area2D = $Numpad/NumpadContainer/SevenArea
@onready var eight_area: Area2D = $Numpad/NumpadContainer/EightArea
@onready var nine_area: Area2D = $Numpad/NumpadContainer/NineArea
@onready var green_light_1: Sprite2D = $Numpad/NumpadContainer/OneArea/GreenLight1
@onready var green_light_2: Sprite2D = $Numpad/NumpadContainer/TwoArea/GreenLight2
@onready var green_light_3: Sprite2D = $Numpad/NumpadContainer/ThreeArea/GreenLight3
@onready var green_light_4: Sprite2D = $Numpad/NumpadContainer/FourArea/GreenLight4
@onready var green_light_5: Sprite2D = $Numpad/NumpadContainer/FiveArea/GreenLight5
@onready var green_light_6: Sprite2D = $Numpad/NumpadContainer/SixArea/GreenLight6
@onready var green_light_7: Sprite2D = $Numpad/NumpadContainer/SevenArea/GreenLight7
@onready var green_light_8: Sprite2D = $Numpad/NumpadContainer/EightArea/GreenLight8
@onready var green_light_9: Sprite2D = $Numpad/NumpadContainer/NineArea/GreenLight9
@onready var specimen_area: Area2D = $SpecimenArea
@onready var specimen_collision: CollisionShape2D = $SpecimenArea/CollisionShape2D
@onready var red_light: Sprite2D = $InProgressLight/RedLight
@onready var green_light: Sprite2D = $InProgressLight/GreenLight
@onready var game_manager: Node = $"../../GameManager"
@onready var specimen: Node = $"../../Specimen"
@onready var user_manual: Area2D = $UserManual
@onready var user_manual_paper: Sprite2D = $UserManualLayer/UserManualPaper
@onready var bg_blur_manual: ColorRect = $UserManualLayer/BGBlurManual


var needle_start_pos: Vector2
var needle_end_pos: Vector2
var needle_travel_distance: int = 75
var mouse_over_numpad: bool = false
var mouse_over_one: bool = false
var mouse_over_two: bool = false
var mouse_over_three: bool = false
var mouse_over_four: bool = false
var mouse_over_five: bool = false
var mouse_over_six: bool = false
var mouse_over_seven: bool = false
var mouse_over_eight: bool = false
var mouse_over_nine: bool = false
var snap_injector_specimen: bool = false
var can_drag_chicken_injector: bool = true
var has_been_injected: bool = false
var mitosis_flag: bool = false
var growth_flag: bool = false
var current_specimen = null
var mouse_over_manual: bool = false
var input_list = []
var injector_codes = {
	"reverse": [7, 8, 9], # reseta a galinha pro estado original
	"mitosis": [7, 4, 6], # flag, se passar no mangler separa em 2 (so pra ovelha)
	"growth": [4, 5, 2], #  flag, output porco gordo e bacon no mangler (so pro porco)
	"explosion": [9, 1, 3], # flag de specimen inutil
	"test": [1, 2, 3]
}

"""
1. clickable numpad - DONE
2. move needle after 3 clicks
3. list of valid clicks
4. red light affter pressing 3 buttons when chicken enter
5. green light when chicken is ready
"""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	user_manual.connect("mouse_entered", Callable(self, "_on_manual_mouse_entered"))
	user_manual.connect("mouse_exited", Callable(self, "_on_manual_mouse_exited"))
	specimen_area.connect("area_entered", Callable(self, "_on_specimen_area_entered"))
	specimen_area.connect("area_exited", Callable(self, "_on_specimen_area_exited"))
	numpad_container.connect("mouse_entered", Callable(self, "_on_numpad_container_mouse_entered"))
	numpad_container.connect("mouse_exited", Callable(self, "_on_numpad_container_mouse_exited"))
	one_area.connect("mouse_entered", Callable(self, "_on_one_area_mouse_entered"))
	one_area.connect("mouse_exited", Callable(self, "_on_one_area_mouse_exited"))
	two_area.connect("mouse_entered", Callable(self, "_on_two_area_mouse_entered"))
	two_area.connect("mouse_exited", Callable(self, "_on_two_area_mouse_exited"))
	three_area.connect("mouse_entered", Callable(self, "_on_three_area_mouse_entered"))
	three_area.connect("mouse_exited", Callable(self, "_on_three_area_mouse_exited"))
	four_area.connect("mouse_entered", Callable(self, "_on_four_area_mouse_entered"))
	four_area.connect("mouse_exited", Callable(self, "_on_four_area_mouse_exited"))
	five_area.connect("mouse_entered", Callable(self, "_on_five_area_mouse_entered"))
	five_area.connect("mouse_exited", Callable(self, "_on_five_area_mouse_exited"))
	six_area.connect("mouse_entered", Callable(self, "_on_six_area_mouse_entered"))
	six_area.connect("mouse_exited", Callable(self, "_on_six_area_mouse_exited"))
	seven_area.connect("mouse_entered", Callable(self, "_on_seven_area_mouse_entered"))
	seven_area.connect("mouse_exited", Callable(self, "_on_seven_area_mouse_exited"))
	eight_area.connect("mouse_entered", Callable(self, "_on_eight_area_mouse_entered"))
	eight_area.connect("mouse_exited", Callable(self, "_on_eight_area_mouse_exited"))
	nine_area.connect("mouse_entered", Callable(self, "_on_nine_area_mouse_entered"))
	nine_area.connect("mouse_exited", Callable(self, "_on_nine_area_mouse_exited"))
	current_specimen = specimen.get_child(0)
	needle_start_pos = needle.position
	needle_end_pos = needle.position + Vector2(needle_travel_distance, 0)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			pass
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if !press_machine.is_chicken_draggable() or !mangler_machine.is_chicken_draggable() or !oven_machine.is_chicken_draggable() or !deliver_machine.is_chicken_draggable():
				pass
			elif mouse_over_manual:
				user_manual_paper.visible = true
				bg_blur_manual.visible = true
			elif snap_injector_specimen:
				# snaps specimen to the machine
				current_specimen.position = specimen_collision.global_position + Vector2(0, 60)
				if mouse_over_one:
					if input_list.size() < 3:
						input_list.append(1)
						green_light_1.visible = true
						print(input_list)
				elif mouse_over_two:
					if input_list.size() < 3:
						input_list.append(2)
						green_light_2.visible = true
						print(input_list)
				elif mouse_over_three:
					if input_list.size() < 3:
						input_list.append(3)
						green_light_3.visible = true
						print(input_list)
				elif mouse_over_four:
					if input_list.size() < 3:
						input_list.append(4)
						green_light_4.visible = true
						print(input_list)
				elif mouse_over_five:
					if input_list.size() < 3:
						input_list.append(5)
						green_light_5.visible = true
						print(input_list)
				elif mouse_over_six:
					if input_list.size() < 3:
						input_list.append(6)
						green_light_6.visible = true
						print(input_list)
				elif mouse_over_seven:
					if input_list.size() < 3:
						input_list.append(7)
						green_light_7.visible = true
						print(input_list)
				elif mouse_over_eight:
					if input_list.size() < 3:
						input_list.append(8)
						green_light_8.visible = true
						print(input_list)
				elif mouse_over_nine:
					if input_list.size() < 3:
						input_list.append(9)
						green_light_9.visible = true
						print(input_list)
					
				# move chicken 
				if input_list.size() == 3 and !has_been_injected:
					can_drag_chicken_injector = false
					print("chicken draggable injector false")
					has_been_injected = true
					red_light.visible = true
					green_light.visible = false
					
					var tween = create_tween()
					tween.tween_property(needle, "position", (needle.position + Vector2(0, 75)), 1)
					await tween.finished
					
					await get_tree().create_timer(0.5).timeout
					
					var tween2 = create_tween()
					tween2.tween_property(needle, "position", (needle.position - Vector2(0, 75)), 1)
					await tween2.finished
					
					red_light.visible = false
					green_light.visible = true
					for key in injector_codes:
						if injector_codes[key] == input_list:
							activate_injector_effect(key)
							print("that is the code for: ", key)
						else:
							print("not a valid code for: ", key)
					# reset numpad stuff
					input_list = []
					can_drag_chicken_injector = true
					print("chicken draggable injector true")
					has_been_injected = false
					reset_numpad_lights()

func activate_injector_effect(key) -> void:
	if key == "reverse":
		game_manager.clear_list()
		game_manager.clear_machine_counter()
		current_specimen.reset_sprite()
		print("reverse applied")
	elif key == "mitosis":
		if mitosis_flag:
			# change sprite to unusable
			game_manager.unusable_specimen = true
			print("unusable specimen")
		else:
			mitosis_flag = true
			# change sprite to mitosis sprite
			game_manager.append_machine_order(3)
			print("mitosis applied")
	elif key == "growth":
		if mitosis_flag:
			# change sprite to unusable
			game_manager.unusable_specimen = true
			print("unusable specimen")
		else:
			growth_flag = true
			# change sprite to tumor growth
			game_manager.append_machine_order(4)
			print("growth applied")
	elif key == "explosion":
		# change sprite to unusable specimen
		game_manager.unusable_specimen = true
		print("explosion applied")

func _on_specimen_area_entered(area: Area2D) -> void:
	snap_injector_specimen = true

func _on_specimen_area_exited(area: Area2D) -> void:
	snap_injector_specimen = false
	red_light.visible = false
	green_light.visible = false

func _on_numpad_container_mouse_entered() -> void:
	mouse_over_numpad = true

func _on_numpad_container_mouse_exited() -> void:
	mouse_over_numpad = false

func _on_one_area_mouse_entered() -> void:
	mouse_over_one = true

func _on_one_area_mouse_exited() -> void:
	mouse_over_one = false

func _on_two_area_mouse_entered() -> void:
	mouse_over_two = true

func _on_two_area_mouse_exited() -> void:
	mouse_over_two = false

func _on_three_area_mouse_entered() -> void:
	mouse_over_three = true

func _on_three_area_mouse_exited() -> void:
	mouse_over_three = false

func _on_four_area_mouse_entered() -> void:
	mouse_over_four = true

func _on_four_area_mouse_exited() -> void:
	mouse_over_four = false

func _on_five_area_mouse_entered() -> void:
	mouse_over_five = true

func _on_five_area_mouse_exited() -> void:
	mouse_over_five = false

func _on_six_area_mouse_entered() -> void:
	mouse_over_six = true

func _on_six_area_mouse_exited() -> void:
	mouse_over_six = false

func _on_seven_area_mouse_entered() -> void:
	mouse_over_seven = true

func _on_seven_area_mouse_exited() -> void:
	mouse_over_seven = false

func _on_eight_area_mouse_entered() -> void:
	mouse_over_eight = true

func _on_eight_area_mouse_exited() -> void:
	mouse_over_eight = false

func _on_nine_area_mouse_entered() -> void:
	mouse_over_nine = true

func _on_nine_area_mouse_exited() -> void:
	mouse_over_nine = false

func _on_manual_mouse_entered() -> void:
	mouse_over_manual = true

func _on_manual_mouse_exited() -> void:
	mouse_over_manual = false

func is_chicken_draggable() -> bool:
	return can_drag_chicken_injector

func reset_numpad_lights() -> void:
	green_light_1.visible = false
	green_light_2.visible = false
	green_light_3.visible = false
	green_light_4.visible = false
	green_light_5.visible = false
	green_light_6.visible = false
	green_light_7.visible = false
	green_light_8.visible = false
	green_light_9.visible = false
