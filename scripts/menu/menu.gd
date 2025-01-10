extends Control


const MAIN_SCENE = "res://scenes/main.tscn"
const OPTIONS = "res://scenes/menu/options.tscn"
const GAME = "res://scenes/machines/press_machine.tscn"

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_SCENE)


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file(OPTIONS)


func _on_exit_pressed() -> void:
	get_tree().quit()
