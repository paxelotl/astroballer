class_name DebugLabel
extends Label

@export var target: Node
@export var target_path: String
@export var prefix: String = ""

func resolve_path(node: Node, path: String):
	var path_parts = path.split(".")
	var current_object = node
	for part in path_parts:
		current_object = current_object[part]
	return current_object

func _world_to_screen():
	var camera = get_viewport().get_camera_3d()
	var screen_position = camera.unproject_position(target.global_position)
	position = screen_position

func _physics_process(_delta: float) -> void:
	_world_to_screen()
	
	var prop_val = resolve_path(target, target_path)
	if prop_val == null:
		return
	if prop_val is Callable:
		prop_val = prop_val.call()
	var prop_val_str = prefix + str(prop_val)
	
	text = prop_val_str
