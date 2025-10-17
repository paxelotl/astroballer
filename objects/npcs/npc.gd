extends Node3D

@export var dialogue: Dialogue

func _ready() -> void:
	$InteractableArea.connect("player_touched", _on_player_touched)
	$InteractableArea.connect("interacted", _on_interacted)
	$TextBox.visible = false

func _on_player_touched(player: Player) -> void:
	$TextBox.visible = true
	player.printd()

func _on_interacted() -> void:
	pass
