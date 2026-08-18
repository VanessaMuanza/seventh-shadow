extends Control

@onready var nine_patch_rect: NinePatchRect = $CanvasLayer/NinePatchRect
@onready var nine_patch_rect_2: NinePatchRect = $CanvasLayer/NinePatchRect2
@onready var quest_list: VBoxContainer = $CanvasLayer/Contents/Details/QuestList
@onready var ques_title: Label = $CanvasLayer/Contents/Details/QuestDetails/QuesTitle
@onready var quest_decription: Label = $CanvasLayer/Contents/Details/QuestDetails/QuestDecription
@onready var quest_objectives: VBoxContainer = $CanvasLayer/Contents/Details/QuestDetails/QuestObjectives
@onready var quest_rewards: VBoxContainer = $CanvasLayer/Contents/Details/QuestDetails/QuestRewards
