extends Node2D

@onready var pause_box: Panel = $Pause/PauseLayer/Control/PauseBox
@onready var pause_button: Button = $Pause/PauseLayer/Control/Pause
@onready var bg_blur: ColorRect = $Pause/PauseLayer/Control/BGBlur

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
