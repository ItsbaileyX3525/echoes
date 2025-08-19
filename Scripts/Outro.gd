extends Control
@onready var node_2d: Node2D = $Node2D
@onready var quit: Button = $Node2D/Quit

var max_y: float = -1142.0
var move_amount: int = -10

func _physics_process(delta: float) -> void:
	if node_2d.position.y > max_y:
		node_2d.position.y -= 1

func _on_quit_button_down() -> void:
	quit.position.y -= move_amount

func _on_quit_button_up() -> void:
	quit.position.y += move_amount

func _on_quit_pressed() -> void:
	get_tree().quit()
