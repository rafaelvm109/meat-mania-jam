extends Node2D

@onready var oven_button: Area2D = $OvenButton
@onready var press_machine: Node2D = $"../PressMachine"
@onready var mangler_machine: Node2D = $"../mangler_machine"
@onready var deliver_machine: Node2D = $"../deliver_machine"
@onready var chicken: Node2D = $"../../Specimen/Chicken"
@onready var specimen_collision: CollisionShape2D = $SpecimenArea/SpecimenCollision
@onready var specimen_area: Area2D = $SpecimenArea
@onready var game_manager: Node = $"../../GameManager"
@onready var button_sprite: Sprite2D = $OvenButton/ButtonSprite

var mouse_over_button: bool = false
var is_dragging_oven: bool = false
var clicks_to_burn: int = 0
var total_clicks_to_burn: int = 10
var snap_oven_subject: bool = false
var can_drag_chicken_oven: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	# on mouse event
	if event is InputEventMouseButton:
		# if player click LMB
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			# and the mouse is over the oven button
			if mouse_over_button:
				# and player hasnt clicked the button enough times
				clicks_to_burn += 1
				# cheap and lazy way to give feedback to the button
				button_sprite.position += Vector2(2, 2)
				await get_tree().create_timer(0.1).timeout
				button_sprite.position -= Vector2(2, 2)
				if clicks_to_burn < total_clicks_to_burn:
					# add fire particles here
					print("click ", total_clicks_to_burn - clicks_to_burn, " more times to cook the chicken")
				# on the last click needed allow player to drag chicken
				elif clicks_to_burn == total_clicks_to_burn:
					can_drag_chicken_oven = true
					chicken.burn()
					game_manager.append_machine_order(2)
					# add animation for burned chicken
					print("the chicken is burned")
		# on LMB relesase
		elif event.button_index == MOUSE_BUTTON_LEFT:
			# if the subject is not in a machine already
			if !press_machine.is_chicken_draggable() or !mangler_machine.is_chicken_draggable():
				pass
			# if subject is over the oven 
			elif snap_oven_subject:
				# snap subject into place
				chicken.position = specimen_collision.global_position + Vector2(0, 60)
				# subject not draggable while condition met
				if clicks_to_burn < total_clicks_to_burn:
					can_drag_chicken_oven = false
			# if not in another machine and not in this machine snap back into the inventory
			else: 
				# snap logic here
				pass
			
			


func _on_oven_button_mouse_entered() -> void:
	mouse_over_button = true

func _on_oven_button_mouse_exited() -> void:
	mouse_over_button = false

func _on_specimen_area_entered(area: Area2D) -> void:
	snap_oven_subject = true

func _on_specimen_area_exited(area: Area2D) -> void:
	snap_oven_subject = false

func is_chicken_draggable() -> bool:
	return can_drag_chicken_oven
