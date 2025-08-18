extends Node2D

@onready var player = $Player
@onready var ghost = $Ghost
@onready var initial_position: Node2D = $InitialPosition
@onready var timer: Timer = $Timer
@onready var door1: Line2D = $Level/Level1/Door/Node2D/Line2D
@onready var label: Label = $Player/CanvasLayer/ColorRect/TimerLabel
@onready var moving_plat_anim: AnimationPlayer = $Level/Level1/MovingPlat/AnimationPlayer
@onready var door2: Line2D = $Level/Level1/Door2/Node2D/Line2D
@onready var door3: Line2D = $Level/Level1/Door3/Node2D/Line2D
@onready var lift3_anim: AnimationPlayer = $Level/Level1/Lift3/AnimationPlayer
@onready var kc: AudioStreamPlayer = $KC
@onready var replay_timer: Timer = $ReplayTimer

var can_continue: bool = false
var bodies_stored: Array = []

var stored_position: Vector2
enum State { IDLE, RECORDING, REPLAYING }
var state: State = State.IDLE

var tutorial_beat: bool = false

var on_level: int = 0

@onready var levels: Array = [
	$Level/Level1,
	$Level/Level2,
	$Level/Level3,
]

func _ready() -> void:
	ghost.hide()
	ghost.connect("finished_recording", _on_ghost_finished)
	timer.wait_time = 10.0
	timer.one_shot = true
	label.text = "Press R to record"

func _process(delta: float) -> void:
	print(on_level)
	if Input.is_action_just_pressed("restart"):
		match state:
			State.IDLE:
				start_recording()
			State.RECORDING:
				replay_timer.start()
				kc.play()
				state = State.REPLAYING
			State.REPLAYING:
				pass

	if state == State.RECORDING:
		label.text = "Recording... %ss" % int(timer.time_left)

func start_recording() -> void:
	stored_position = player.global_position
	state = State.RECORDING
	player.is_recording = true
	player.recording.clear()
	timer.start()
	label.text = "Recording... 10s"

func stop_recording_and_replay() -> void:
	state = State.REPLAYING
	player.is_recording = false
	ghost.start_replay(player.recording)
	label.text = "Replaying..."
	player.global_position = stored_position
	player.velocity = Vector2.ZERO

func _on_timer_timeout() -> void:
	if state == State.RECORDING:
		kc.play()
		replay_timer.start()
		state = State.REPLAYING

func _on_replay_timer_timeout() -> void:
	stop_recording_and_replay()

func _on_ghost_finished() -> void:
	state = State.IDLE
	label.text = "Replay finished! Press R to record again"
	clear_recording()

func clear_recording() -> void:
	stored_position = Vector2(0,20)
	player.recording.clear()
	player.is_recording = false
	ghost.hide()
	ghost.position.y = 99999
	for e in levels[on_level].get_children():
		if e.name.rstrip("1234567890") == "AreaSwitch":
			if e.perm_ghost:
				e.reset_state()

var lifted1: bool = false
var lifted2: bool = false

var can_enter2: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not lifted1:
		$Level/Level1/Lift/AnimationPlayer.play("move")

func _on_area_switch_entered() -> void:
	door1.default_color = Color.from_rgba8(50, 205, 50, 255)

func _on_door_2_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not lifted2 and can_enter2:
		$Level/Level1/Lift2/AnimationPlayer.play("move")

func _on_area_switch_2_entered() -> void:
	moving_plat_anim.play("move")

func _on_area_switch_2_left() -> void:
	moving_plat_anim.pause()

func _on_area_switch_4_entered() -> void:
	can_enter2 = true
	door2.default_color = Color.from_rgba8(50, 205, 50, 255)
	
func _on_area_switch_4_left() -> void:
	can_enter2 = false
	door2.default_color = Color.from_rgba8(173, 10, 45, 255)
	
func _on_door_3_body_entered(body: Node2D) -> void:
	bodies_stored.append(body)
	if body.name == "Player" and can_continue and not tutorial_beat:
		tutorial_beat = true
		on_level += 1
		$Level/Level1/Lift4/AnimationPlayer.play("move")

func _on_area_switch_3_entered() -> void:
	lift3_anim.play("move")

func _on_area_switch_3_left() -> void:
	lift3_anim.play_backwards("move")

func _on_area_switch_5_entered() -> void:
	can_continue = true
	door3.default_color = Color.from_rgba8(50, 205, 50, 255)
	if len(bodies_stored) > 0:
		for e in bodies_stored:
			if e.name == "Player" and can_continue and not tutorial_beat:
				tutorial_beat = true
				on_level += 1
				$Level/Level1/Lift4/AnimationPlayer.play("move")

func _on_area_switch_5_left() -> void:
	can_continue = false
	if not tutorial_beat:
		door3.default_color = Color.from_rgba8(173, 10, 45, 255)
