extends Node2D

@onready var lever: Sprite2D = $Lever
@onready var press: Sprite2D = $Press
@onready var input_pos: Marker2D = $InputPos
@onready var output_pos: Marker2D = $OutputPos

var subject: Node2D = null
var is_processing: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process_subject() -> void:
	if subject and !is_processing:
		# Add press down animation
		# await animation_finished()
		output_processed_subject()
		

func output_processed_subject() -> void:
	if subject:
		# substitute subject for the output
		subject.queue_free()
		var paste = PackedScene.new().instance()
		paste.position = output_pos.global_position
		add_child(paste)
		is_processing = false
	
