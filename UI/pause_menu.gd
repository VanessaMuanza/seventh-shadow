extends Control

func show_menu() -> void:
	$CanvasLayer.show()

func hide_menu() -> void:
	$CanvasLayer.hide()

func _ready() -> void:
	hide_menu()
