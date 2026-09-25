extends CanvasLayer


func _ready():
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.start("TheNewsStart")

func _on_timeline_ended():
	await FadeTransition.fade_out()
	GameState.next_scene_path = "res://Scenes/bus_station.tscn"
	get_tree().change_scene_to_file("res://Scenes/loading_scene.tscn")
