extends CanvasLayer


func _on_go_to_pressed() -> void:
	await FadeTransition.fade_out()
	GameState.next_scene_path = "res://UI/Scene/MainMenu.tscn"
	get_tree().change_scene_to_file("res://Scenes/loading_scene.tscn")
