extends CharacterBody2D

var playback: Array[Vector2] = []
var frame: int = 0
var active: bool = false
@onready var timer_label: Label = $"../Player/Camera2D/ColorRect/TimerLabel"

signal finished_recording

func start_replay(recording: Array[Vector2]) -> void:
	if recording.is_empty():
		return
	playback = recording.duplicate()
	frame = 0
	active = true
	show()
	global_position = playback[0]

func _physics_process(delta: float) -> void:
	if active:
		if frame < playback.size():
			var y_offset: float = -24.0  # adjust until aligned
			global_position = playback[frame] + Vector2(0, y_offset)
			frame += 1
			timer_label.text = "Replaying: %s / %s" % [frame, playback.size()]
		else:
			active = false
			finished_recording.emit()
