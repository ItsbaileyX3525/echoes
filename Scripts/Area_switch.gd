extends Area2D

@onready var line_2d: Line2D = $Node2D/Line2D

@export var permenant: bool = false
@export var perm_ghost: bool = false
var activated: bool = false
var ghost_priority: bool = false

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
		if body.name == "Ghost":
			ghost_priority = true

func _on_body_exited(body: Node2D) -> void:
	if activated:
		if body.name == "Player":
			if not ghost_priority:
				if not permenant:
					if perm_ghost:
						line_2d.default_color = Color.DARK_MAGENTA
					else:
						line_2d.default_color = Color.CRIMSON
					
					activated = false
					left.emit()
		elif body.name == "Ghost":
			if permenant:
				return
			if not perm_ghost:
				line_2d.default_color = Color.CRIMSON
				activated = false
				ghost_priority = false
				left.emit()

func reset_state() -> void:
	if activated:
		activated = false 
		ghost_priority = false
		left.emit()
		if perm_ghost:
			line_2d.default_color = Color.DARK_MAGENTA
		elif permenant:
			line_2d.default_color = Color.DARK_ORANGE
		else:
			line_2d.default_color = Color.CRIMSON
