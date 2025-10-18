extends Node3D

@export var dialogue: Dialogue
var current_dialogue: int = 0
var interactable: bool = false

func _ready() -> void:
	$InteractableArea.connect("player_touched", _on_player_touched)
	$InteractableArea.connect("interacted", _on_interacted)

func _physics_process(_delta: float) -> void:
	$Vfx/Interactable.visible = interactable
	$Vfx.look_at(get_viewport().get_camera_3d().global_position)

func progress_dialogue() -> void:
	if dialogue.dialogue.size() > current_dialogue and interactable:
		$TextBox.text = dialogue.dialogue[current_dialogue]
		current_dialogue += 1

func _on_player_touched(player: Player) -> void:
	player.printd()

func _on_interacted() -> void:
	pass
