extends Node

var next_world

@onready var current_world = $main
@onready var anim =$AnimationPlayer


func _ready() -> void:
	current_world.world_changed.connect(handle_world_changed)
	
func handle_world_changed(current_world_name: String):
	var next_world_name: String
	
	match current_world_name:
		"main":
			next_world_name = "LucyInterior"
		"LucyInterior":
			next_world_name = "main"
		_:
			return
	print("Chargement de : ", next_world_name)
	next_world = load("res://Scenes/" + next_world_name + ".tscn").instantiate()
	next_world.z_index = -4
	add_child(next_world)
	anim.play("fade_in")
	next_world.world_changed.connect(handle_world_changed)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print("Animation terminée : ", anim_name)
	match anim_name:
		"fade_in":
			current_world.queue_free()
			current_world = next_world
			current_world.z_index = 0
			next_world = null
			anim.play("fade_out")
