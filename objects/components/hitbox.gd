class_name Hitbox
extends Area3D

@onready var parent: Node3D = get_parent()

signal player_touched(player: Player)

func _ready():
	_verify_parent()

func notify_player_touched(player: Player) -> void:
	player_touched.emit(player)

# abstract
func _verify_parent() -> void:
	pass
