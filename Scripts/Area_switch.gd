extends Area2D

@onready var line_2d: Line2D = $Node2D/Line2D

@export var permenant: bool = false
@export var perm_ghost: bool = false
var activated: bool = false

signal entered
signal left

func _ready() -> void:
	if permenant:
		line_2d.default_color = Color.DARK_ORANGE
	if perm_ghost:
		line_2d.default_color = Color.DARK_MAGENTA

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.name == "Ghost":
		if not activated:
			activated = true
			line_2d.default_color = Color.GREEN
			entered.emit()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		if not permenant:
			line_2d.default_color = Color.CRIMSON
			activated = false
			left.emit()
			activated = false
			left.emit()
	if body.name == "Ghost":
		if permenant:
			return
		if not perm_ghost:
			line_2d.default_color = Color.CRIMSON
			activated = false
			left.emit()

func reset_state() -> void:
	if perm_ghost:
		line_2d.default_color = Color.DARK_MAGENTA
	elif permenant:
		line_2d.default_color = Color.DARK_ORANGE
	else:
		line_2d.default_color = Color.CRIMSON
