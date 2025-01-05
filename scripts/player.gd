extends CharacterBody2D


# character speed
@export var speed = 250

# character destination
var target_position = Vector2()


func _ready() -> void:
	# start by setting target position to be the starting position
	target_position = global_position
	

func _process(delta: float) -> void:
	# checks position and moves accordingly
	if(global_position != target_position):
		global_position = global_position.move_toward(target_position, speed * delta)

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("leftMouseClick"):
		target_position = get_global_mouse_position()
