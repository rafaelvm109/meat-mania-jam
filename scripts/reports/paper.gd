extends Sprite2D

@export_group("Page Turner")
@export var previous_page: Node
@export var next_page: Node
@export var animator: Node

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
			set_process_input(false)
			animator.play("turn_previous")
			await get_tree().create_timer(1.5).timeout
			visible = false
			previous_page.set_process_input(true)

func turn_next(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print ("bruh")
			set_process_input(false)
			next_page.visible = true
			next_page.set_process(true)
			animator.play("turn_next")
			await get_tree().create_timer(1.5).timeout
			visible = false
