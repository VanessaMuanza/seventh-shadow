extends Control
#inutile pour l'instant
var quest_ui: Control = null

# S'exécute automatiquement quand le node apparaît dans la scène
func _ready() -> void:
	
	# Le menu continue de marcher même si le jeu est en pause
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# On met la barre à jour dès le début avec le niveau de confiance actuel
	$CanvasLayer/TextureProgressBar.value = QuestManager.trust_level
	
	# Dès que le niveau de confiance change ailleurs, on est prévenu ici
	QuestManager.trust_updated.connect(_on_trust_updated)

# Cette fonction se lance à chaque fois que le niveau de confiance change
func _on_trust_updated(trust_level: int) -> void:
	
	# On met à jour la barre avec la nouvelle valeur
	$CanvasLayer/TextureProgressBar.value = trust_level
	#teste pour voir que tout fonctionne 
	print("BAR VALUE :", $CanvasLayer/TextureProgressBar.value)
	print("BAR MAX :", $CanvasLayer/TextureProgressBar.max_value)
	print("BAR VISIBLE :", $CanvasLayer/TextureProgressBar.visible)

# Affiche le menu de confiance à l'écran
func show_menu() -> void:
	# Passe le menu au-dessus de tout le reste
	$CanvasLayer.layer = 10
	$CanvasLayer.show()
	$CanvasLayer/TextureProgressBar.show()
	$CanvasLayer/RitaPixelPortrait.show()

# Cache le menu de confiance
func hide_menu() -> void:
	$CanvasLayer.hide()
