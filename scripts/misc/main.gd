extends Node2D

@onready var pause_box: Panel = $Pause/PauseLayer/Control/PauseBox
@onready var pause_button: Button = $Pause/PauseLayer/Control/Pause
@onready var bg_blur: ColorRect = $Pause/PauseLayer/Control/BGBlur
@onready var inv_1: Panel = $Inventory/CanvasLayer/Control/Inv1
@onready var inv_2: Panel = $Inventory/CanvasLayer/Control/Inv2
@onready var inv_3: Panel = $Inventory/CanvasLayer/Control/Inv3
@onready var inv_4: Panel = $Inventory/CanvasLayer/Control/Inv4
@onready var chicken: Node2D = $Specimen/Chicken
@onready var game_manager: Node = $GameManager
@onready var specimen: Node = $Specimen
@onready var deliver_machine: Node2D = $Machines/deliver_machine

const CHICKEN_SCENE = preload("res://scenes/specimen/chicken.tscn")
@onready var h_slider: HSlider = $Pause/PauseLayer/Control/PauseBox/PauseContainer/Label/HSlider


# starts by setting specimen position
func _ready() -> void:
	chicken.position = inv_1.global_position + (inv_1.size / 2)
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	h_slider.value_changed.connect(_on_volume_changed)


# checks if soultion result is true or false and calls every function needed to reset game state
# TODO: now that I see this is very similar to game.is_subject_acceptable() I should merge them into one
func check_solution() -> void:
	if game_manager.is_subject_acceptable():
		print("solution accepted")
		SceneTransition.change_scene_to_file("res://scenes/reports/report_chick.tscn")
		#get_tree().change_scene_to_file("res://scenes/main-sheep.tscn")
	else:
		game_manager.clear_list()
		game_manager.clear_machine_counter()
		$GameManager/Glitch.visible = true
		await get_tree().create_timer(0.2).timeoutchicken.reset_sprite()
		chicken.position = inv_1.global_position + (inv_1.size / 2)
		deliver_machine.deliver_tray_down()
		print("chicken reset")
		$GameManager/Glitch.visible = false
		

# make pause menu and blur background visible
func _on_pause_pressed() -> void:
	get_tree().paused = true
	pause_box.visible = true
	pause_button.visible = false
	bg_blur.visible = true
	

# make pause menu and blur background notvisible
func _on_resume_pressed() -> void:
	get_tree().paused = false
	pause_box.visible = false
	pause_button.visible = true
	bg_blur.visible = false

func _on_volume_changed(value: float):
	var db_value = linear_to_db(value)
	AudioServer.set_bus_volume_db(0, db_value)

func _on_exit_pressed() -> void:
	get_tree().paused = false
	SceneTransition.change_scene_to_file("res://scenes/menu/menu.tscn")
	#get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
