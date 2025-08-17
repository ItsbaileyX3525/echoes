extends CharacterBody2D

var playback: Array[Vector2] = []
var frame: int = 0
var active: bool = false

func start_replay(recording: Array[Vector2]) -> void:
	if recording.is_empty():
		return
	playback = recording.duplicate()
	frame = 0
	active = true
	show()
	global_position = playback[0]

func _physics_process(delta: float) -> void:
	if active and frame < playback.size():
		global_position = playback[frame]
		frame += 1
