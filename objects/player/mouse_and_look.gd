extends Node3D

@onready var camera_pivot = $CameraPivot
@onready var mouse_on_window: bool = true

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("alt"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	# mouse must be on window to be captured, otherwise error
	if Input.is_action_just_released("alt") and mouse_on_window:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		match event.button_index:
			MouseButton.MOUSE_BUTTON_LEFT:
				if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
					Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	var mouse_movement: Vector2 = Vector2.ZERO
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouse_movement = event.screen_relative
	
	# Neck must rotate y and Camera must rotate x
	rotation.y -= mouse_movement.x * 0.01
	camera_pivot.rotation.x -= mouse_movement.y * 0.01
	camera_pivot.rotation.x = clampf(camera_pivot.rotation.x, -PI / 2, PI / 2)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_MOUSE_ENTER:
			mouse_on_window = true
		NOTIFICATION_WM_MOUSE_EXIT:
			mouse_on_window = false
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
