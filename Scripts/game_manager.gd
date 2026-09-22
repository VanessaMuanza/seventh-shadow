extends Node

signal coins_changed(new_amount: int)

var coins := 1000:
	set(value):
		coins = value
		coins_changed.emit(coins)
