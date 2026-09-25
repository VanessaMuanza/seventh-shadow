extends CanvasLayer

@onready var label: Label = $TextureRect/Label
@onready var description_label: Label = $TextureRect/DescriptionLabel


func _ready() -> void:
	visible = false
	QuestManager.quest_added.connect(_on_quest_added)

func _on_quest_added(quest: Quest):
	label.text = quest.quest_name
	description_label.text = quest.quest_description
	visible = true
	await get_tree().create_timer(5.0).timeout
	visible = false
