extends Node2D

@onready var oven_button: Area2D = $OvenButton

var mouse_over_button: bool = false
var clicks_to_burn: int = 0
var total_clicks_to_burn: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_over_button:
				if clicks_to_burn < total_clicks_to_burn:
					# add fire particles here
					clicks_to_burn += 1
					print("click ", total_clicks_to_burn - clicks_to_burn, " more times to cook the chicken")
				
				if clicks_to_burn == total_clicks_to_burn:
					# add animation for burned chicken
					print("the chicken is burned")


func _on_oven_button_mouse_entered() -> void:
	mouse_over_button = true


func _on_oven_button_mouse_exited() -> void:
	mouse_over_button = false
