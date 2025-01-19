extends Node2D


@onready var deliver_belt: Area2D = $DeliverBelt
@onready var specimen_collision: CollisionShape2D = $DeliverBelt/SpecimenCollision
@onready var press_machine: Node2D = $"../PressMachine"
@onready var mangler_machine: Node2D = $"../mangler_machine"
@onready var oven_machine: Node2D = $"../oven_machine"
@onready var chicken: Node2D = $"../../Specimen/Chicken"
@onready var game_manager: Node = $"../../GameManager"
@onready var game: Node2D = $"../.."
@onready var injector_machine: Node2D = $"../Injector"
@onready var specimen: Node = $"../../Specimen"

var snap_deliver_subject: bool = false # tracks if specimen is over the machine
var can_drag_chicken_injector: bool = true
var current_specimen


func _ready() -> void:
	deliver_belt.connect("area_entered", Callable(self, "_on_deliver_belt_area_entered"))
	deliver_belt.connect("area_exited", Callable(self, "_on_deliver_belt_area_exited"))
	current_specimen = specimen.get_child(0)


func _input(event: InputEvent) -> void:
	# on mouse event
	if event is InputEventMouseButton:
		# if LMB is pressed
		if event.button_index == MOUSE_BUTTON_LEFT:
			# and specimen not in another machine
			if !press_machine.is_chicken_draggable() or !mangler_machine.is_chicken_draggable() or !oven_machine.is_chicken_draggable() or !injector_machine.is_chicken_draggable():
				pass
			# and specimen over deliver machine
			elif snap_deliver_subject: 
				# set the specimen position at the start of the belt
				can_drag_chicken_injector = false
				current_specimen.position = specimen_collision.global_position + Vector2(-100, 5)
				await get_tree().create_timer(1).timeout
				var tween = create_tween()
				# move specimen right 300px over 2sec
				tween.tween_property(current_specimen, "position", (current_specimen.global_position + Vector2(300, 0)), 2)
				await tween.finished
				# verifies state of solution
				can_drag_chicken_injector = true
				game.check_solution()


func _on_deliver_belt_area_entered(area: Area2D) -> void:
	snap_deliver_subject = true

func _on_deliver_belt_area_exited(area: Area2D) -> void:
	snap_deliver_subject = false

func is_chicken_draggable() -> bool:
	return can_drag_chicken_injector
