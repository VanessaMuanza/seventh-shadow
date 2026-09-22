extends Label

func _ready() -> void:
	GameManager.coins_changed.connect(_on_coins_changed)
	text = format_coins(GameManager.coins)

func _on_coins_changed(new_amount: int) -> void:
	text = format_coins(new_amount)

func format_coins(amount: int) -> String:
	if amount >= 1_000_000:
		return "%.1fM" % (amount / 1_000_000.0)
	elif amount >= 1_000:
		return "%.1fK" % (amount / 1_000.0)
	else:
		return str(amount)
