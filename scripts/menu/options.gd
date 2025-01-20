extends Control

@onready var h_slider: HSlider = $VBoxContainer/HSlider

const MENU = "res://scenes/menu/menu.tscn"

func _ready():
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	h_slider.value_changed.connect(_on_volume_changed)

func _on_volume_changed(value: float):
	var db_value = linear_to_db(value)
	AudioServer.set_bus_volume_db(0, db_value)

	
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(MENU)
