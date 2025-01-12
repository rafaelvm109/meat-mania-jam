extends Node2D

@onready var pause_box: Panel = $Pause/PauseLayer/Control/PauseBox
@onready var pause_button: Button = $Pause/PauseLayer/Control/Pause
@onready var bg_blur: ColorRect = $Pause/PauseLayer/Control/BGBlur
@onready var inv_1: Panel = $Inventory/CanvasLayer/Control/Inv1
@onready var inv_2: Panel = $Inventory/CanvasLayer/Control/Inv2
@onready var inv_3: Panel = $Inventory/CanvasLayer/Control/Inv3
@onready var inv_4: Panel = $Inventory/CanvasLayer/Control/Inv4
@onready var chicken: Node2D = $Specimen/Chicken


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	chicken.position = inv_1.global_position + (inv_1.size / 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pause_pressed() -> void:
	get_tree().paused = true
	pause_box.visible = true
	pause_button.visible = false
	bg_blur.visible = true
	
	
func _on_resume_pressed() -> void:
	get_tree().paused = false
	pause_box.visible = false
	pause_button.visible = true
	bg_blur.visible = false


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	pass # Replace with function body.
