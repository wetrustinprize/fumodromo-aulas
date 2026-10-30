extends CharacterBody3D
class_name CharacterCore

@export_group("Movement")
@export var max_speed: float = 5.0
@export var acceleration: float = 15.0
@export var deceleration: float = 20.0

var _gravity: float

var direction: Vector2 = Vector2.ZERO

@export_group("Crouching")
@export var crouching_upper: CollisionShape3D
@export var crouch_duration: float = 1.0
@export var crouch_amount: float = 10.0

var _crouching_tween: Tween
var _crouching: bool = false
var _crouching_upper_default_position: Vector3

func _ready() -> void:
	_gravity = get_gravity().y
	_crouching_upper_default_position = crouching_upper.position

func _physics_process(delta: float) -> void:
	var is_stopping = direction == Vector2.ZERO

	# transforma a direção no mundo 3D
	# para uma direção referente ao
	# objeto local

	var real_direction: Vector2 = direction.rotated(-rotation.y)
	if not is_on_floor():
		velocity.y += _gravity * delta

	if not is_stopping:
		velocity.x = move_toward(velocity.x, real_direction.x * max_speed, delta * acceleration)
		velocity.z = move_toward(velocity.z, real_direction.y * max_speed, delta * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, delta * deceleration)
		velocity.z = move_toward(velocity.z, 0, delta * deceleration)

	move_and_slide()

func set_crouching(crouching: bool) -> void:
	if crouching == _crouching:
		return
	_crouching = crouching

	if _crouching_tween:
		_crouching_tween.kill()

	_crouching_tween = get_tree().create_tween()

	var desired_position: Vector3
	if crouching:
		desired_position = _crouching_upper_default_position - Vector3(0, -crouch_amount, 0)
	else:
		desired_position = _crouching_upper_default_position

	_crouching_tween.tween_property(
		crouching_upper,
		"position",
		desired_position,
		crouch_duration
	)
