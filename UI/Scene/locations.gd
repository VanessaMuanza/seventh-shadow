extends Control


func _on_village_pressed() -> void:
	await FadeTransition.fade_out()
	GameState.next_scene_path = "res://Scenes/bus_station.tscn"
	get_tree().change_scene_to_file("res://Scenes/loading_scene.tscn")

func _on_office_pressed() -> void:
	await FadeTransition.fade_out()
	GameState.next_scene_path = "res://Places/post office/office.tscn"
	get_tree().change_scene_to_file("res://Scenes/loading_scene.tscn")


func _on_graveyard_pressed() -> void:
	await FadeTransition.fade_out()
	GameState.next_scene_path = "res://Places/Graveyard/graveyard.tscn"
	get_tree().change_scene_to_file("res://Scenes/loading_scene.tscn")


func _on_shelter_pressed() -> void:
	await FadeTransition.fade_out()
	GameState.next_scene_path = "res://Places/post shelter/shelter.tscn"
	get_tree().change_scene_to_file("res://Scenes/loading_scene.tscn")
