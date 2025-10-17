class_name Hurtbox
extends Area3D

@onready var parent: Player = get_parent()

signal touched_ball(ball: Hitbox)
signal touched_npc(npc: InteractableArea)

func _ready():
	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox: Area3D) -> void:
	if hitbox != null:
		if hitbox is BallHitbox:
			touched_ball.emit(hitbox)
		if hitbox is InteractableArea:
			touched_npc.emit(hitbox)

func _verify_parent() -> void:
	if parent is not Player:
		print("WARNING: %s has an unexpected parent %s" % [self, parent])
