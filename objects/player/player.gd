class_name Player
extends CharacterBody3D

@onready var neck = $Neck
@onready var camera = $Neck/Camera
@onready var pickup_timer = $PickupTimer

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const THROW_STRENGTH = 10.0

@export var ball_scene: PackedScene
var ball: Ball

var has_ball: bool = false

var can_double_jump: bool = false

func _ready() -> void:
	$Hurtbox.connect("touched_ball", _on_hurtbox_touched_ball)

func _on_hurtbox_touched_ball(ball: Hitbox) -> void:
	if not is_on_floor():
		can_double_jump = true
	has_ball = true
	ball.notify_player_touched(self)

func _throw_ball() -> void:
	has_ball = false
	pickup_timer.start()
	ball = ball_scene.instantiate()
	ball.position = position
	
	# -global_basis.z is the forward direction, like Vector3.FORWARD
	ball.linear_velocity = -camera.global_basis.z * THROW_STRENGTH
	get_tree().current_scene.add_child(ball)

func _handle_movement(delta: float) -> void:
	# double jump is granted elsewhere
	if is_on_floor():
		can_double_jump = false
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("jump"):
		_handle_jump()
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction: Vector3 = (neck.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * 2 * delta)
		velocity.z = move_toward(velocity.z, 0, SPEED * 2 * delta)
	
	move_and_slide()

func _handle_jump() -> void:
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
	else:
		var overlaps = $Hurtbox.get_overlapping_areas()
		for overlap in overlaps:
			if overlap is BallHitbox:
				_on_hurtbox_touched_ball(overlap)
				velocity.y = JUMP_VELOCITY

func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	
	if Input.is_action_just_released("attack") and has_ball:
		_throw_ball()
