class_name BallHitbox
extends Hitbox

func _verify_parent():
	if parent is not Ball:
		print("WARNING: %s has an unexpected parent %s" % [self, parent])
