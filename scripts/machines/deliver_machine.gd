extends Node2D


@onready var deliver_belt: Area2D = $DeliverBelt
@onready var specimen_collision: CollisionShape2D = $DeliverBelt/SpecimenCollision
@onready var press_machine: Node2D = $"../PressMachine"
@onready var mangler_machine: Node2D = $"../mangler_machine"
@onready var oven_machine: Node2D = $"../oven_machine"
@onready var chicken: Node2D = $"../../Specimen/Chicken"
@onready var game_manager: Node = $"../../GameManager"
@onready var game: Node2D = $"../.."

var snap_deliver_subject: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deliver_belt.connect("area_entered", Callable(self, "_on_deliver_belt_area_entered"))
	deliver_belt.connect("area_exited", Callable(self, "_on_deliver_belt_area_exited"))


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		#if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			#pass
		if event.button_index == MOUSE_BUTTON_LEFT:
			if !press_machine.is_chicken_draggable() or !mangler_machine.is_chicken_draggable() or !oven_machine.is_chicken_draggable():
				pass
			elif snap_deliver_subject: 
				chicken.position = specimen_collision.global_position + Vector2(-100, 5)
				await get_tree().create_timer(1).timeout
				var tween = create_tween()
				tween.tween_property(chicken, "position", (chicken.global_position + Vector2(300, 0)), 2)
				await tween.finished
				check_subject_deliver()
			else:
				pass


func check_subject_deliver() -> void:
	game.check_solution()
	
func _on_deliver_belt_area_entered(area: Area2D) -> void:
	snap_deliver_subject = true

func _on_deliver_belt_area_exited(area: Area2D) -> void:
	snap_deliver_subject = false
