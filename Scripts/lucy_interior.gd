extends Node2D

signal world_changed(world_name)
var entered = false 

@export var world_name: String = "world"
func _process(delta: float) -> void:
	if entered == true:
		if Input.is_action_just_pressed("ui_accept"):
			emit_signal("world_changed", world_name)

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	entered = true
func _on_area_2d_body_exited(body:  CharacterBody2D) -> void:
	entered = false




func _on_inventory_gui_closed() -> void:
	get_tree().paused = false


func _on_inventory_gui_opened() -> void:
	get_tree().paused = true
