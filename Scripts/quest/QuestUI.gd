extends Control

@onready var nine_patch_rect: NinePatchRect = $CanvasLayer/NinePatchRect
@onready var nine_patch_rect_2: NinePatchRect = $CanvasLayer/NinePatchRect2
@onready var quest_list: VBoxContainer = $CanvasLayer/Contents/Details/QuestList
@onready var quest_title: Label = $CanvasLayer/Contents/Details/QuestDetails/QuestTitle
@onready var quest_decription: Label = $CanvasLayer/Contents/Details/QuestDetails/QuestDecription
@onready var quest_objectives: VBoxContainer = $CanvasLayer/Contents/Details/QuestDetails/QuestObjectives
@onready var quest_rewards: VBoxContainer = $CanvasLayer/Contents/Details/QuestDetails/QuestRewards
@onready var book_cover: NinePatchRect = $CanvasLayer/BookCover
@onready var marker: NinePatchRect = $CanvasLayer/marker
@onready var marker_2: NinePatchRect = $CanvasLayer/marker2
@onready var quest_icon: TextureRect = $CanvasLayer/QuestIcon
@onready var tl_icon: TextureRect = $CanvasLayer/TLIcon


func _ready():
	$CanvasLayer.hide()
	
	QuestManager.quest_list_updated.connect(_on_quest_list_updated)
	QuestManager.quest_updated.connect(_on_quest_updated)
	_on_quest_list_updated()
	
func _input(event):
	if event.is_action_pressed("toggle_quest_log"):
		$CanvasLayer.visible = !$CanvasLayer.visible
		
func _on_quest_list_updated():  #is called when QuestManager send a quest change siganl
	print("quest list updated")

	for child in quest_list.get_children():# c'est mon vbox container qui contien mes quêtes
		child.queue_free() #sert à vider la liste sinon on aura des doublons voir plus

	for quest_id in QuestManager.quests: #va parcourir toute mes quêtes qui sont dans QM
		var quest = QuestManager.quests[quest_id] #récupere la quête et la met dans var quest
		#verifie l'état de la quête
		if quest.state == "in_progress":
			var quest_button = Button.new()#nouveau button
			quest_button.text = quest.quest_name #on donne le nom de la quête à notre button
			
			#le bind sert a savoir de quel quête on parle
			quest_button.pressed.connect(_on_quest_selected.bind(quest))
			quest_list.add_child(quest_button)



func _on_quest_updated(quest_id: String):
	_on_quest_list_updated()
#on affiche le titre de la quête
func _on_quest_selected(quest):
	quest_title.text = quest.quest_name

#on affiche la descripion de la quête
	quest_decription.text = quest.quest_description

	for child in quest_objectives.get_children():#on efface les ancien objective si on a des nouveau
		child.queue_free()
		
	for objective in quest.objectives:
		var label = Label.new()
		label.text = objective.description
		label.add_theme_color_override("font_color", Color("#430000"))
		quest_objectives.add_child(label)
