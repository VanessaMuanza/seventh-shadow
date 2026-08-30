extends Resource

class_name Dialog

@export var dialogs = {}

#load dialog
func load_from_json(file_path):
	var data = FileAccess.get_file_as_string(file_path)
	var parsed_data = JSON.parse_string(data)
	if parsed_data:
		dialogs = parsed_data
	else:
		print("failed to parse", parsed_data)
		
#return individual npc dialog
func get_npc_dialog(npc_id):
	if npc_id in dialogs:
		return dialogs[npc_id]
	else:
		return []
