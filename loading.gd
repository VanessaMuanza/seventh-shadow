extends Node2D

@onready var progress_bar: ProgressBar = $ProgressBar
var progress: Array[float] = []

func _ready() -> void:
	FadeTransition.fade_in()
	ResourceLoader.load_threaded_request(GameState.next_scene_path)

func _process(delta: float) -> void:
	var status = ResourceLoader.load_threaded_get_status(GameState.next_scene_path, progress)
	
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			if progress.size() > 0:
				progress_bar.value = progress[0] * 100
		ResourceLoader.THREAD_LOAD_LOADED:
			var scene = ResourceLoader.load_threaded_get(GameState.next_scene_path)
			await FadeTransition.fade_out()
			get_tree().change_scene_to_packed(scene)
		ResourceLoader.THREAD_LOAD_FAILED:
			print("ÉCHEC DU CHARGEMENT: ", GameState.next_scene_path)
