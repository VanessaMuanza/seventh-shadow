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
@onready var trust_level: Button = $CanvasLayer/TrustLevel
@onready var pause_menu: Button = $CanvasLayer/PauseMenu
@onready var quest_icon: Button = $CanvasLayer/QuestIcon
@onready var tl_icon: Button = $CanvasLayer/TLIcon

#pause menu
const PauseMenuScene := preload("res://UI/pause_menu.tscn")
var pause_menu_instance: Control = null

# Trust Level
const TrustLevelScene := preload("res://UI/npc_trust_lvl.tscn")
var trust_level_instance: Control = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Le Book est fermé au démarrage
	$CanvasLayer.hide()
	
	trust_level.focus_mode = Control.FOCUS_ALL
	
	# Les éléments visuels ne doivent pas bloquer les boutons
	$CanvasLayer/NinePatchRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$CanvasLayer/NinePatchRect2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$CanvasLayer/Contents.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$CanvasLayer/BookCover.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$CanvasLayer/QuestIcon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$CanvasLayer/TLIcon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Créer le PauseMenu une seule fois au démarrage
	pause_menu_instance = PauseMenuScene.instantiate()
	pause_menu_instance.set("quest_ui", self)
	get_tree().root.add_child.call_deferred(pause_menu_instance)
	pause_menu_instance.call_deferred("hide_menu")
	
	# Créer la page Trust Level une seule fois
	trust_level_instance = TrustLevelScene.instantiate()
	get_tree().root.add_child.call_deferred(trust_level_instance)
	trust_level_instance.call_deferred("hide_menu")

	
	# Connexion aux signaux du QuestManager
	QuestManager.quest_list_updated.connect(_on_quest_list_updated)
	QuestManager.quest_updated.connect(_on_quest_updated)
	
	# Afficher la liste des quêtes
	_on_quest_list_updated()
	
	print("QUEST UI READY")
	print("BOOK VISIBLE :", $CanvasLayer.visible)


func _input(event):
	# Debug : afficher le bouton qui possède actuellement le focus
	if event.is_action_pressed("ui_accept"):
		var focus = get_viewport().gui_get_focus_owner()

	# Ouvrir ou fermer le Quest Log avec la touche configurée
	if event.is_action_pressed("toggle_quest_log"):
		var trust_visible = trust_level_instance and trust_level_instance.get_node("CanvasLayer").visible
		if $CanvasLayer.visible or pause_menu_instance.get_node("CanvasLayer").visible or trust_visible:
			_close_book()
		else:
			_open_book_to_quests()

# OUVRIR LE QUEST LOG
func _open_book_to_quests() -> void:
	$CanvasLayer.show()
	_show_quest_tab()
	pause_menu_instance.hide_menu()
	
	get_tree().paused = true
	
	quest_log.focus_mode = Control.FOCUS_ALL
	quest_log.grab_focus()



	# FERMER LE QUEST LOG
func _close_book() -> void:
	$CanvasLayer.hide()
	pause_menu_instance.hide_menu()
	if trust_level_instance:
		trust_level_instance.hide_menu()
	get_tree().paused = false

# OUVRIR LE PAUSE MENU
func _on_pause_menu_pressed() -> void:
	$CanvasLayer.hide()
	if trust_level_instance:
		trust_level_instance.hide_menu()
	pause_menu_instance.show_menu()
	
	var pause_quest_log = pause_menu_instance.get_node("CanvasLayer/QuestLog")
	pause_quest_log.focus_mode = Control.FOCUS_ALL
	pause_quest_log.grab_focus()
	
# MISE A JOUR DE LA LISTE DES QUETES
func _on_quest_list_updated():
	print("quest list updated")
	# Supprimer les anciens boutons
	for child in quest_list.get_children():
		child.queue_free()

# Créer un bouton pour chaque quête en cours
	for quest_id in QuestManager.quests:
		var quest = QuestManager.quests[quest_id]
		if quest.state == "in_progress":
			var quest_button = Button.new()
			quest_button.text = quest.quest_name
			quest_button.pressed.connect(_on_quest_selected.bind(quest))
			quest_list.add_child(quest_button)

# QUETE MODIFIEE
func _on_quest_updated(quest_id: String):
	_on_quest_list_updated()

# AFFICHER LES DETAILS D'UNE QUETE
func _on_quest_selected(quest):
	quest_title.text = quest.quest_name
	quest_decription.text = quest.quest_description

# Supprimer les anciens objectifs
	for child in quest_objectives.get_children():
		child.queue_free()

	# Afficher les objectifs de la quête
	for objective in quest.objectives:
		var label = Label.new()
		label.text = objective.description
		label.add_theme_color_override("font_color", Color("#430000"))
		quest_objectives.add_child(label)

# REVENIR AU QUEST LOG DEPUIS LE PAUSE MENU
func show_quest_log() -> void:
	print("=== RETOUR QUEST LOG ===")
	pause_menu_instance.hide_menu()
	if trust_level_instance:
		trust_level_instance.hide_menu()
	$CanvasLayer.show()
	_show_quest_tab()
	
	quest_log.focus_mode = Control.FOCUS_ALL
	quest_log.grab_focus()

	# BOUTON QUEST LOG
func _on_quest_log_pressed() -> void:
	print("QUEST LOG PRESSED")
	_show_quest_tab()
	quest_log.grab_focus()




# NAVIGATION ENTRE QUEST LOG, TRUST LEVEL ET PAUSE MENU
func _unhandled_input(event):
	if not $CanvasLayer.visible:
		return

	# Flèche droite
	if event.is_action_pressed("ui_right"):
		if quest_log.has_focus():
			trust_level.grab_focus()

		elif trust_level.has_focus():
			pause_menu.grab_focus()

		elif pause_menu.has_focus():
			quest_log.grab_focus()

		get_viewport().set_input_as_handled()

	# Flèche gauche
	elif event.is_action_pressed("ui_left"):
		if quest_log.has_focus():
			pause_menu.grab_focus()

		elif pause_menu.has_focus():
			trust_level.grab_focus()

		elif trust_level.has_focus():
			quest_log.grab_focus()

		get_viewport().set_input_as_handled()


func _on_trust_level_pressed() -> void:
	print("=== TRUST LEVEL PRESSED ===")
	_show_trust_tab()
	trust_level.grab_focus()

func _show_quest_tab() -> void:
	$CanvasLayer/Contents.show()
	if trust_level_instance:
		trust_level_instance.hide_menu()

func _show_trust_tab() -> void:
	$CanvasLayer/Contents.hide()
	if trust_level_instance:
		trust_level_instance.show_menu()
