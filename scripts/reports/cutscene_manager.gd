extends Node2D
@export var next_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%CutsceneManager.play("start_scene")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func change_scene():
	get_tree().change_scene_to_packedscene(next_scene)
