extends Node3D

@export var dialogue: Dialogue
var current_dialogue: int = 0
var interactable: bool = false

func _ready() -> void:
	add_to_group("npcs")
	$InteractableArea.connect("player_touched", _on_player_touched)
	$InteractableArea.connect("interacted", _on_interacted)

func _physics_process(_delta: float) -> void:
	$Vfx/Interactable.visible = interactable
	$Vfx.look_at(get_viewport().get_camera_3d().global_position)

func progress_dialogue() -> void:
	if dialogue.dialogue.size() > current_dialogue:
		$TextBox.text = dialogue.dialogue[current_dialogue]
		current_dialogue += 1
	else:
		print("finished")

func _on_player_touched(player: Player) -> void:
	player.printd()

func _on_interacted() -> void:
	pass
