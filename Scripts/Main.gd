extends Node2D

@onready var player = $Player
@onready var ghost = $Ghost
@onready var label = $TimerLabel
@onready var initial_position: Node2D = $InitialPosition
@onready var timer: Timer = $Timer

enum State { IDLE, RECORDING, REPLAYING }
var state: State = State.IDLE

func _ready() -> void:
	ghost.hide()
	ghost.connect("finished_recording", _on_ghost_finished)
	timer.wait_time = 10.0
	timer.one_shot = true
	label.text = "Press R to record"

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		match state:
			State.IDLE:
				start_recording()
			State.RECORDING:
				stop_recording_and_replay()
			State.REPLAYING:
				pass # do nothing

	# Update timer label if recording
	if state == State.RECORDING:
		label.text = "Recording... %ss" % int(timer.time_left)

# --- State transitions ---
func start_recording() -> void:
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
	player.global_position = initial_position.global_position
	player.velocity = Vector2.ZERO

func _on_timer_timeout() -> void:
	if state == State.RECORDING:
		stop_recording_and_replay()

func _on_ghost_finished() -> void:
	state = State.IDLE
	label.text = "Replay finished! Press R to record again"
	clear_recording()

func clear_recording() -> void:
	player.recording.clear()
	player.is_recording = false
	ghost.hide()
	ghost.position.y = 99999
