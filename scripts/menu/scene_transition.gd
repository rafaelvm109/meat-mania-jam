extends CanvasLayer

func change_scene_to_file(target: String):
	await get_tree().create_timer(0.2).timeout
	$AnimationPlayer.play("In")
	get_tree().change_scene_to_file(target)
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("Out")
