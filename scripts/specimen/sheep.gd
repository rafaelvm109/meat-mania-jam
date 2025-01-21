extends Node2D


@onready var subject: Area2D = $Subject
@onready var chicken_collision: CollisionShape2D = $Subject/CollisionShape2D
@onready var press_snap_pos: Marker2D = $"../../Machines/PressSnapPos"
@onready var press_machine: Node2D = $"../../Machines/PressMachine"
@onready var animation_player: AnimationPlayer = $Subject/AnimationPlayer
@onready var mangler_machine: Node2D = $"../../Machines/mangler_machine"
@onready var oven_machine: Node2D = $"../../Machines/oven_machine"
@onready var sheep_sprite: Sprite2D = $Subject/Sprite2D
@onready var injector_machine: Node2D = $"../../Machines/Injector"
@onready var game_manager: Node = $"../../GameManager"

var is_dragging: bool = false # tracks if chicken is being dragged
var offset: Vector2
const SHEEP = preload("res://assets/sprites/specimen/sheep.png")
const SHEEP_DOUBLE = preload("res://assets/sprites/specimen/sheep_double.png")
const SHEEP_MITOSIS = preload("res://assets/sprites/specimen/sheep_mitosis.png")
const SHEEP_UNUSABLE = preload("res://assets/sprites/specimen/sheep_poop.png")

func _input(event: InputEvent) -> void:
	# checks if mouse event
	if event is InputEventMouseButton:
		# if LMB is pressed
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			# and mouse is over the chicken
			if chicken_collision.shape and get_global_mouse_position().distance_to(global_position) < 45:
				# and the chicken is not in any of the other machines
				if press_machine.is_chicken_draggable() and mangler_machine.is_chicken_draggable() and oven_machine.is_chicken_draggable() and injector_machine.is_chicken_draggable():
					is_dragging = true
					offset = global_position - get_global_mouse_position()
		# stop dragging when MB is released
		elif event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = false


func _process(delta: float) -> void:
	# updates chicken pos based on mouse move
	if is_dragging:
		global_position = get_global_mouse_position() + offset


# chicken after press machine
func smash() -> void:
	# no interaction required with this machine
	unusable_sprite()

# chicken after mangler machine
func dice() -> void:
	if game_manager.machine_order_list == [3]:
		sheep_sprite.texture = SHEEP_DOUBLE # TODO: change for final asset
		sheep_sprite.scale = Vector2(0.154, 0.164)
	else:
		unusable_sprite()

# chicken after oven machine
func burn() -> void:
	# no interaction required with this machine
	unusable_sprite()

# chicken after being injected with mitosis
func inject_mitosis() -> void:
	if game_manager.machine_order_list == []:
		sheep_sprite.texture = SHEEP_MITOSIS # TODO: change for final asset
		sheep_sprite.scale = Vector2(0.167, 0.187)
	else:
		unusable_sprite()

# chicken after being injected with growth
func inject_growth() -> void:
	# no interaction required with this machine
	unusable_sprite()

func unusable_sprite() -> void:
	sheep_sprite.texture = SHEEP_UNUSABLE # TODO: change for final asset
	sheep_sprite.scale = Vector2(0.283, 0.427)

# chicken after deliver rejected
func reset_sprite() -> void:
	sheep_sprite.texture = SHEEP
	sheep_sprite.scale = Vector2(0.181, 0.177)
