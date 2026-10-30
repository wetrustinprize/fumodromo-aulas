extends Node
class_name PlayerController

@export var camera_sensibility: float = 0.001
@export var camera: Camera3D

var core: CharacterCore

func _ready() -> void:
	core = get_parent() as CharacterCore
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("crouch"):
		core.set_crouching(event.is_action_pressed("crouch"))

	if event is InputEventMouseMotion:
		core.rotate_y(-event.relative.x * camera_sensibility)

		var desired_rotation: float = clamp(
			camera.rotation.x - event.relative.y * camera_sensibility,
			deg_to_rad(-90),
			deg_to_rad(90)
		)

		camera.rotation.x = desired_rotation

	if event.is_action("escape"):
		if Input.is_action_just_pressed("escape"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED

func _physics_process(_delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	core.direction = input_dir
