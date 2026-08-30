extends Node

var coins= 100
func _process(delta: float) -> void:
	$CanvasLayer/Coins/CoinText.text =  str(coins)
