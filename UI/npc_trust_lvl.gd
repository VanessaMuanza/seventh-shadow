class_name NpcTrustLvl
extends Control

var quest_ui: Control = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	$CanvasLayer/ProgressBar.value =  QuestManager.trust_level
	QuestManager.trust_updated.connect(_on_trust_updated)


func _on_trust_updated(trust_level: int) -> void:

	$CanvasLayer/ProgressBar.value = trust_level


func show_menu() -> void:
	$CanvasLayer.layer = 10
	$CanvasLayer.show()
	$CanvasLayer/ProgressBar.show()
	$CanvasLayer/RitaPixelPortrait.show()
	
func hide_menu() -> void:
	$CanvasLayer.hide()
	
	
