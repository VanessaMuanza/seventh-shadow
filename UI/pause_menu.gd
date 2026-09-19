extends Control

var quest_ui: Control = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide_menu()

func show_menu() -> void:
	$CanvasLayer.show()

func hide_menu() -> void:
	$CanvasLayer.hide()


func _on_quest_log_pressed() -> void:
	print("=== BOUTON QUESTLOG MENU ===")
	hide_menu()

	if quest_ui:
		quest_ui.show_quest_log()
