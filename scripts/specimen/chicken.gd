extends Node2D


@onready var subject: Area2D = $Subject
@onready var chicken_collision: CollisionShape2D = $Subject/CollisionShape2D
@onready var press_snap_pos: Marker2D = $"../../Machines/PressSnapPos"
@onready var press_machine: Node2D = $"../../Machines/PressMachine"
@onready var animation_player: AnimationPlayer = $Subject/AnimationPlayer
@onready var mangler_machine: Node2D = $"../../Machines/mangler_machine"
@onready var oven_machine: Node2D = $"../../Machines/oven_machine"
@onready var chicken_sprite: Sprite2D = $Subject/Sprite2D
@onready var injector_machine: Node2D = $"../../Machines/Injector"
@onready var game_manager: Node = $"../../GameManager"

var is_dragging: bool = false # tracks if chicken is being dragged
var offset: Vector2
const CHICKEN_PASTE = preload("res://assets/sprites/specimen/chick_paste.png")
const DICED_CHICKEN = preload("res://assets/sprites/specimen/chick_nugget_raw.png")
const DINO_NUGGIE = preload("res://assets/sprites/specimen/chick_nugget_cooked.png")
const CHICKEN = preload("res://assets/sprites/specimen/chick.png")
const CHICKEN_UNUSABLE = preload("res://assets/sprites/specimen/chick_poop.png")


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
	if game_manager.machine_order_list == []:
		chicken_sprite.texture = CHICKEN_PASTE
		chicken_sprite.scale = Vector2(0.131, 0.154)
	else:
		unusable_sprite()

# chicken after mangler machine
func dice() -> void:
	if game_manager.machine_order_list == [0]:
		chicken_sprite.texture = DICED_CHICKEN
		chicken_sprite.scale = Vector2(0.212, 0.281)
	else:
		unusable_sprite()

# chicken after oven machine
func burn() -> void:
	if game_manager.machine_order_list == [0, 1]:
		chicken_sprite.texture = DINO_NUGGIE
		chicken_sprite.scale = Vector2(0.213, 0.246)
	else:
		unusable_sprite()

# chicken after being injected with mitosis
func inject_mitosis() -> void:
	unusable_sprite()

# chicken after being injected with growth
func inject_growth() -> void:
	unusable_sprite()

func unusable_sprite() -> void:
	chicken_sprite.texture = CHICKEN_UNUSABLE
	chicken_sprite.scale = Vector2(0.272, 0.318)

# chicken after deliver rejected
func reset_sprite() -> void:
	chicken_sprite.texture = CHICKEN
	chicken_sprite.scale = Vector2(0.258, 0.229)
