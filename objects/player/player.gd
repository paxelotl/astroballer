class_name Player
extends CharacterBody3D

@onready var neck = $Neck
@onready var camera = $Neck/Camera
@onready var pickup_timer = $PickupTimer
@onready var ui = $Neck/UIElements
@onready var ui_elements = ui.get_children()

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const THROW_STRENGTH = 10.0

@export var ball_scene: PackedScene
var ball: Ball

var has_ball: bool = false
var charging_throw: bool = false

func _ready() -> void:
	$Hurtbox.connect("touched_ball", _on_hurtbox_touched_ball)
	$Hurtbox.connect("touched_npc", func (npc): npc.notify_player_touched(self))

func _on_hurtbox_touched_ball(ball_hitbox: Hitbox) -> void:
	if is_on_floor() and pickup_timer.is_stopped():
		has_ball = true
		ball_hitbox.notify_player_touched(self)

func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	
	_handle_attack(delta)
	
	_handle_ui()

func _handle_attack(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		if has_ball:
			if is_on_floor():
				charging_throw = true
			else:
				_throw_ball_air()
		elif ball:
			has_ball = true
			ball.queue_free()

	if Input.is_action_just_released("attack") and charging_throw:
		charging_throw = false
		_throw_ball("forward")
	
	if Input.is_action_just_pressed("jump") and charging_throw:
		charging_throw = false
		_throw_ball("down")

func _throw_ball(direction: String) -> void:
	has_ball = false
	pickup_timer.start()
	ball = ball_scene.instantiate()
	ball.position = position
	ball.position.y -= 0.3
	
	if direction == "forward":
		# -global_basis.z is the forward direction, like Vector3.FORWARD
		ball.linear_velocity = -camera.global_basis.z * THROW_STRENGTH
	if direction == "down":
		ball.linear_velocity = velocity * 1.4
		ball.linear_velocity.y = -THROW_STRENGTH
	
	get_tree().current_scene.add_child(ball)

func _throw_ball_air() -> void:
	print("air throw!")

func _pick_up_ball(ball_hitbox: BallHitbox) -> void:
	has_ball = true
	ball_hitbox.notify_player_touched(self)

func _handle_movement(delta: float) -> void:
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
				# double jump and pick up
				_pick_up_ball(overlap)
				velocity.y = JUMP_VELOCITY

func _handle_ui() -> void:
	for element in ui_elements:
		if element.name == "Charge":
			element.visible = charging_throw

func printd():
	print("AHHHHHHH NPC TOUCHED")
