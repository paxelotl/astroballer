extends Node3D

@onready var player: Player = get_parent()
@onready var npcs: Array[Node]
var closest_npc: Node

func _ready() -> void:
	npcs = get_tree().get_nodes_in_group("npcs")
	if npcs:
		closest_npc = npcs[0]

func _physics_process(_delta: float) -> void:
	_handle_npcs()
	
	if Input.is_action_just_pressed("interact"):
		closest_npc.progress_dialogue()

func _handle_npcs() -> void:
	if npcs:
		var dist
		var closest_dist
		for npc in npcs:
			dist = npc.position.distance_squared_to(player.position)
			closest_dist = closest_npc.position.distance_squared_to(player.position)
			if dist < closest_dist:
				closest_npc.interactable = false
				closest_npc = npc
		closest_npc.interactable = closest_npc.position.distance_to(player.position) < 3
