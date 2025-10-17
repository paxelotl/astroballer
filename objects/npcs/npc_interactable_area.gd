class_name NpcInteractableArea
extends InteractableArea

signal player_touched(player: Player)
signal interacted

func notify_player_touched(player: Player) -> void:
	player_touched.emit(player)

func notify_interacted() -> void:
	interacted.emit()
