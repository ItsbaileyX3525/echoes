extends Node2D

@onready var player = $Player
@onready var ghost = $Ghost
@onready var timer = $Timer
@onready var label = $TimerLabel

var waiting_for_restart: bool = false

func _ready() -> void:
	ghost.hide()
	timer.start()

func _process(delta: float) -> void:
	if not waiting_for_restart:
		label.text = str(int(timer.time_left))
	else:
		label.text = "Press R to restart"

	if timer.is_stopped() and not waiting_for_restart:
		# stop auto-restart, wait for player input
		waiting_for_restart = true
		player.is_recording = false

	if waiting_for_restart and Input.is_action_just_pressed("restart"):
		_start_new_loop()

func _start_new_loop() -> void:
	ghost.start_replay(player.recording)
	player.global_position = Vector2.ZERO
	player.velocity = Vector2.ZERO
	player.recording.clear()
	player.is_recording = true
	timer.start()
	waiting_for_restart = false
