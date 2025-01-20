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
const CHICKEN_PASTE = preload("res://assets/sprites/specimen/chicken_paste.png")
const DICED_CHICKEN = preload("res://assets/sprites/specimen/diced_chicken.png")
const DINO_NUGGIE = preload("res://assets/sprites/specimen/dino_nuggie.png")
const PIG = preload("res://assets/sprites/specimen/pig.png")


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
	#pig_sprite.texture = CHICKEN_PASTE
	#pig_sprite.scale = Vector2(0.2, 0.2)
	pass

# chicken after mangler machine
func dice() -> void:
	if game_manager.machine_order_list == [4]:
		pig_sprite.texture = DICED_CHICKEN # TODO: add actual sprite
		pig_sprite.scale = Vector2(0.15, 0.15)
		# improve on the animation :dead:
		
		var pig_sprite_only = Sprite2D.new()
		pig_sprite_only.texture = PIG
		pig_sprite_only.scale = Vector2(0.073, 0.092)
		pig_sprite_only.position = pig_sprite.global_position
		specimen.add_child(pig_sprite_only)
		
		var tween = create_tween()
		tween.tween_property(pig_sprite_only, "position", (Vector2(1710, 334)), 1)
		await tween.finished
	else:
		pass

# chicken after oven machine
func burn() -> void:
	if game_manager.machine_order_list == [4, 1]:
		pig_sprite.texture = DINO_NUGGIE # TODO: add actual sprite
		pig_sprite.scale = Vector2(0.4, 0.4)

# chicken after being injected with mitosis
func inject_mitosis() -> void:
	# no interaction required with this machine
	pass # TODO: might delete or add sprite later

# chicken after being injected with growth
func inject_growth() -> void:
	if game_manager.machine_order_list == []:
		pass # TODO: add actual sprite
	else:
		pass

func unusable_sprite() -> void:
	pass # TODO: add sprite for unusable specimen

# chicken after deliver rejected
func reset_sprite() -> void:
	pig_sprite.texture = PIG
	pig_sprite.scale = Vector2(0.073, 0.092)
