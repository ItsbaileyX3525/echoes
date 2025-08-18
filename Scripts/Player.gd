extends CharacterBody2D

@export var speed: float = 350.0
@export var jump_velocity: float = -600.0
@export var gravity: float = 900.0

var recorded: bool = false
var recording: Array[Vector2] = []
var is_recording: bool = false
var was_on_floor: bool = false

@onready var jump_particles: CPUParticles2D = $JumpParticles
@onready var land_particles: CPUParticles2D = $LandParticles

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if velocity.y > 0:
			velocity.y = 0 

	var left_strength = float(Input.get_action_strength("walk_left") if InputMap.has_action("walk_left") else 0.0)
	var right_strength = float(Input.get_action_strength("walk_right") if InputMap.has_action("walk_right") else 0.0)
	var input_dir: float = right_strength - left_strength
	velocity.x = input_dir * speed

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		jump_particles.restart()

	move_and_slide()

	if not was_on_floor and is_on_floor():
		land_particles.restart()

	was_on_floor = is_on_floor()

	if is_recording:
		recording.append(global_position)
