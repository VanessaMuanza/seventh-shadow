extends Control

func _on_play_button_pressed() -> void:
	await FadeTransition.fade_out()
	GameState.next_scene_path = "res://Scenes/main.tscn"
	get_tree().change_scene_to_file("res://Scenes/LoadingScreen.tscn")


func _on_play_pressed() -> void:
	await FadeTransition.fade_out()
	GameState.next_scene_path = "res://Scenes/main.tscn"
	get_tree().change_scene_to_file("res://Scenes/loading_scene.tscn")
