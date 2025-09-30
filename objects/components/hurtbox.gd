class_name Hurtbox
extends Area3D

signal touched_ball(damage: int)

@onready var pickup_timer = $"../PickupTimer"
@onready var player = get_parent()

func _ready():
	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox: Hitbox) -> void:
	if hitbox != null:
		if hitbox is BallHitbox and pickup_timer.is_stopped():
			touched_ball.emit(hitbox.damage)
			hitbox.notify_player_touched(player)
