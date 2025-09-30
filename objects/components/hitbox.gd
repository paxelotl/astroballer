class_name Hitbox
extends Area3D

var damage: int = 4

signal player_touched(player)

func notify_player_touched(player: Player) -> void:
	player_touched.emit(player)
