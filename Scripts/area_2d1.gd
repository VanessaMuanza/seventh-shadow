extends Area2D


var entered = false
var can_interact = true


func  _on_body_entered(body):
	if body is NPC:
		return
	if body is CharacterBody2D:
		entered = true

func _on_body_exited(body):
	if body is NPC:
		return
	if body is CharacterBody2D:
		entered = false
	
func _physics_process (_delta):
	if entered == true:
		if Input.is_action_just_pressed("ui_accept"):
			print("PLAYER HOUSE SCRIPT TRIGGERED")
			get_tree().change_scene_to_file("res://Scenes/LucyInterior.tscn")

func _ready():
	set_deferred("monitoring", false)
	await get_tree().physics_frame
	await get_tree().physics_frame
	set_deferred("monitoring", true)
