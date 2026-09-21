extends Node

signal coins_changed(new_amount: int)

var coins := 100:
	set(value):
		coins = value
		coins_changed.emit(coins)
