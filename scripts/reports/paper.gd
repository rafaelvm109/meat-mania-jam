extends Sprite2D

@export_group("Page Turner")
@export var previous_page: Node
@export var next_page: Node

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func turn_previous(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print ("bruh")
			previous_page.visible = true
			previous_page.set_process_input(true)
			set_process_input(false)
			visible = false

func turn_next(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print ("bruh")
			next_page.visible = true
			next_page.set_process_input(true)
			set_process_input(false)
			visible = false
