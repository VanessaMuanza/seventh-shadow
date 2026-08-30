extends Control

@onready var nine_patch_rect: NinePatchRect = $CanvasLayer/NinePatchRect
@onready var dialog_speaker: Label = $CanvasLayer/NinePatchRect/DialogueBox/DialogSpeaker
@onready var dialog_text: Label = $CanvasLayer/NinePatchRect/DialogueBox/DialogText
@onready var dialog_options: HBoxContainer = $CanvasLayer/NinePatchRect/DialogueBox/DialogOptions


func _ready() -> void:
	hide_dialog()

#show dialog box
func show_dialog(speaker, text, options):
	nine_patch_rect.visible = true

	dialog_speaker.text =  speaker
	dialog_text.text = text

#remove existing options
	for option in dialog_options.get_children():
		dialog_options.remove_child(option)
		

	for option in options.keys():
		var button = Button.new()
		button.text = option
		button.add_theme_font_size_override("font_size", 20)
		button.pressed.connect(_on_option_selected.bind(option))
		dialog_options.add_child(button)

#handle response selections
func _on_option_selected(option):
	get_parent().handle_dialog_choice(option)

#hide dialog box
func hide_dialog():
	nine_patch_rect.visible = false
	GameState.player.can_move = true

#close dialog
func _on_close_button_pressed() -> void:
	hide_dialog()
