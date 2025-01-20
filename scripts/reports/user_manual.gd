extends Sprite2D

@onready var close_area: Area2D = $Area2D
@onready var user_manual_paper: Sprite2D = $"."
@onready var bg_blur_manual: ColorRect = $"../BGBlurManual"

var mouse_over_close: bool = false

func _ready() -> void:
	close_area.connect("mouse_entered", Callable(self, "_on_close_area_mouse_entered"))
	close_area.connect("mouse_exited", Callable(self, "_on_close_area_mouse_exited"))


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if user_manual_paper.visible:
			if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				if mouse_over_close:
					user_manual_paper.visible = false
					bg_blur_manual.visible = false
					
					
					
func _on_close_area_mouse_entered() -> void:
	mouse_over_close = true


func _on_close_area_mouse_exited() -> void:
	mouse_over_close = false
