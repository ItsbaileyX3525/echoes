extends Node2D

@onready var player = $Player
@onready var ghost = $Ghost
@onready var initial_position: Node2D = $InitialPosition
@onready var timer: Timer = $Timer
@onready var level: Node2D = $Level
@onready var line_2d: Line2D = $Level/Door/Node2D/Line2D
@onready var label: Label = $Player/Camera2D/ColorRect/TimerLabel

enum State { IDLE, RECORDING, REPLAYING }
var state: State = State.IDLE

var max_check_list = 3
var check_list = 0

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
				pass

	if state == State.RECORDING:
		label.text = "Recording... %ss" % int(timer.time_left)

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
	for e in level.get_children():
		if e.name.rstrip("1234567890") == "AreaSwitch":
			if e.perm_ghost:
				e.reset_state()

func update_checklist(update: bool) -> void:
	print("Update")
	if update:
		check_list += 1
	else:
		check_list -= 1 

	print(check_list)

	if check_list >= max_check_list:
		line_2d.default_color = Color.from_rgba8(50, 205, 50, 255)
	else:
		line_2d.default_color = Color.from_rgba8(173, 10, 45, 255)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if check_list >= max_check_list:
			print("Entered with full")
		else:
			print("Not time")

func _on_area_switch_entered() -> void:
	update_checklist(true)

func _on_area_switch_2_entered() -> void:
	update_checklist(true)

func _on_area_switch_3_entered() -> void:
	update_checklist(true)

func _on_area_switch_3_left() -> void:
	update_checklist(false)

func _on_area_switch_2_left() -> void:
	update_checklist(false)

func _on_area_switch_left() -> void:
	update_checklist(false)
