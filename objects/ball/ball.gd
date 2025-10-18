class_name Ball
extends RigidBody3D

func _ready() -> void:
	add_to_group("balls")
	$Hitbox.connect("player_touched", _on_player_touched)

func _on_player_touched(_player: Player) -> void:
	queue_free()
