extends Node

@onready var specimen: Node = $Specimen


func get_current_specimen():
	var current_specimen = specimen.get_child(0).name.to_lower()
	return current_specimen
