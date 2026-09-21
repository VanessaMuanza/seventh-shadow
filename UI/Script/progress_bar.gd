extends ProgressBar

@onready var progress_bar: Control = $"."


func _ready() -> void:
	QuestManager.trust_updated.connect(_on_trust_updated)
	progress_bar.value = QuestManager.trust_level
	
func _on_trust_updated(new_trust: int) -> void:
	progress_bar.value = new_trust
