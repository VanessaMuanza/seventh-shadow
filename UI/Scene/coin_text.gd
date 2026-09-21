extends Label

func _ready() -> void:
	print("CoinText ready, coins = ", GameManager.coins)
	print("Ma position globale : ", global_position)
	GameManager.coins_changed.connect(_on_coins_changed)
	text = str(GameManager.coins)

func _on_coins_changed(new_amount: int) -> void:
	text = str(new_amount)
