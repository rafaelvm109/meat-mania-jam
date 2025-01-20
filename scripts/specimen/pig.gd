extends Node2D


@onready var subject: Area2D = $Subject
@onready var chicken_collision: CollisionShape2D = $Subject/CollisionShape2D
@onready var press_snap_pos: Marker2D = $"../../Machines/PressSnapPos"
@onready var press_machine: Node2D = $"../../Machines/PressMachine"
@onready var animation_player: AnimationPlayer = $Subject/AnimationPlayer
@onready var mangler_machine: Node2D = $"../../Machines/mangler_machine"
@onready var oven_machine: Node2D = $"../../Machines/oven_machine"
@onready var pig_sprite: Sprite2D = $Subject/Sprite2D
@onready var injector_machine: Node2D = $"../../Machines/Injector"
@onready var game_manager: Node = $"../../GameManager"
@onready var pig: Node2D = $"."
@onready var specimen: Node = $".."

var is_dragging: bool = false # tracks if chicken is being dragged
var offset: Vector2
const PIG = preload("res://assets/sprites/specimen/pig.png")
const PIG_BACON_COOKED = preload("res://assets/sprites/specimen/pig_bacon_cooked.png")
const PIG_BACON_RAW = preload("res://assets/sprites/specimen/pig_bacon_raw.png")
const PIG_CHEW = preload("res://assets/sprites/specimen/pig_chew.png")
const PIG_GROWTH = preload("res://assets/sprites/specimen/pig_growth.png")
const PIG_UNUSABLE = preload("res://assets/sprites/specimen/pig_poop.png")

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
	if game_manager.machine_order_list == [4]:
		pig_sprite.texture = PIG_BACON_RAW
		pig_sprite.scale = Vector2(0.128, 0.154)
		# improve on the animation :dead:
		
		var pig_sprite_only = Sprite2D.new()
		pig_sprite_only.texture = PIG_CHEW
		pig_sprite_only.scale = Vector2(0.146, 0.173)
		pig_sprite_only.position = pig_sprite.global_position
		specimen.add_child(pig_sprite_only)
		
		var tween = create_tween()
		tween.tween_property(pig_sprite_only, "position", (Vector2(1600, 700)), 2)
		await tween.finished
	else:
		unusable_sprite()

# chicken after oven machine
func burn() -> void:
	if game_manager.machine_order_list == [4, 1]:
		pig_sprite.texture = PIG_BACON_COOKED 
		pig_sprite.scale = Vector2(0.128, 0.154)

# chicken after being injected with mitosis
func inject_mitosis() -> void:
	# no interaction required with this machine
	unusable_sprite()

# chicken after being injected with growth
func inject_growth() -> void:
	if game_manager.machine_order_list == []:
		pig_sprite.texture = PIG_GROWTH
		pig_sprite.scale = Vector2(0.146, 0.173)
	else:
		unusable_sprite()

func unusable_sprite() -> void:
	pig_sprite.texture = PIG_UNUSABLE # TODO: add actual sprite
	pig_sprite.scale = Vector2(0.272, 0.405)

# chicken after deliver rejected
func reset_sprite() -> void:
	pig_sprite.texture = PIG
	pig_sprite.scale = Vector2(0.146, 0.173)
