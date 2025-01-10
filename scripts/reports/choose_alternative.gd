extends Area2D
@export var checkmark: Sprite2D

func choose_alternative(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print ("bruh")
			if checkmark.visible == false:
				checkmark.visible = true
			elif checkmark.visible == true:
				checkmark.visible = false
