extends Node3D

@export var dialogue: Dialogue
var interactable: bool = false

func _ready() -> void:
	add_to_group("npcs")
	$InteractableArea.connect("player_touched", _on_player_touched)
	$InteractableArea.connect("interacted", _on_interacted)

func _physics_process(_delta: float) -> void:
	$Vfx/Interactable.visible = interactable
	$Vfx.look_at(get_viewport().get_camera_3d().global_position)

func _on_player_touched(player: Player) -> void:
	player.printd()

func _on_interacted() -> void:
	pass
