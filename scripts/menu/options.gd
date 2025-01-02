extends Control


const MENU ="res://scenes/menu/menu.tscn"


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(MENU)
