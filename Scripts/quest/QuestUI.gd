extends Control

@onready var nine_patch_rect: NinePatchRect = $CanvasLayer/NinePatchRect
@onready var nine_patch_rect_2: NinePatchRect = $CanvasLayer/NinePatchRect2
@onready var quest_list: VBoxContainer = $CanvasLayer/Contents/Details/QuestList
@onready var quest_title: Label = $CanvasLayer/Contents/Details/QuestDetails/QuestTitle
@onready var quest_decription: Label = $CanvasLayer/Contents/Details/QuestDetails/QuestDecription
@onready var quest_objectives: VBoxContainer = $CanvasLayer/Contents/Details/QuestDetails/QuestObjectives
@onready var quest_rewards: VBoxContainer = $CanvasLayer/Contents/Details/QuestDetails/QuestRewards
@onready var book_cover: NinePatchRect = $CanvasLayer/BookCover
@onready var quest_log: Button = $CanvasLayer/QuestLog
@onready var marker_2: Button = $CanvasLayer/marker2
@onready var pause_menu: Button = $CanvasLayer/PauseMenu
@onready var quest_icon: Button = $CanvasLayer/QuestIcon
@onready var tl_icon: Button = $CanvasLayer/TLIcon

const PauseMenuScene := preload("res://UI/pause_menu.tscn")
var pause_menu_instance: Control = null

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	$CanvasLayer.hide()

	pause_menu_instance = PauseMenuScene.instantiate()
	get_tree().root.add_child.call_deferred(pause_menu_instance)
	pause_menu_instance.call_deferred("hide_menu")

	QuestManager.quest_list_updated.connect(_on_quest_list_updated)
	QuestManager.quest_updated.connect(_on_quest_updated)
	_on_quest_list_updated()

func _input(event):
	if event.is_action_pressed("toggle_quest_log"):
		if $CanvasLayer.visible or pause_menu_instance.get_node("CanvasLayer").visible:
			_close_book()
		else:
			_open_book_to_quests()

func _open_book_to_quests() -> void:
	$CanvasLayer.show()
	pause_menu_instance.hide_menu()
	get_tree().paused = true

func _close_book() -> void:
	$CanvasLayer.hide()
	pause_menu_instance.hide_menu()
	get_tree().paused = false

func _on_pause_menu_pressed() -> void:
	$CanvasLayer.hide()
	pause_menu_instance.show_menu()

func _on_quest_list_updated():
	print("quest list updated")
	for child in quest_list.get_children():
		child.queue_free()

	for quest_id in QuestManager.quests:
		var quest = QuestManager.quests[quest_id]
		if quest.state == "in_progress":
			var quest_button = Button.new()
			quest_button.text = quest.quest_name
			quest_button.pressed.connect(_on_quest_selected.bind(quest))
			quest_list.add_child(quest_button)

func _on_quest_updated(quest_id: String):
	_on_quest_list_updated()

func _on_quest_selected(quest):
	quest_title.text = quest.quest_name
	quest_decription.text = quest.quest_description

	for child in quest_objectives.get_children():
		child.queue_free()

	for objective in quest.objectives:
		var label = Label.new()
		label.text = objective.description
		label.add_theme_color_override("font_color", Color("#430000"))
		quest_objectives.add_child(label)

func _on_quest_log_pressed() -> void:
	print("QUEST LOG PRESSED")
	$CanvasLayer.show()
