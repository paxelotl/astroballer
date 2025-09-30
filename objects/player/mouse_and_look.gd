extends Node3D

@onready var camera = $Camera

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	var mouse_movement: Vector2 = Vector2.ZERO
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouse_movement = event.screen_relative
	
	# Neck must rotate y and Camera must rotate x
	rotation.y -= mouse_movement.x * 0.01
	camera.rotation.x -= mouse_movement.y * 0.01
	camera.rotation.x = clampf(camera.rotation.x, -PI / 2, PI / 2)
