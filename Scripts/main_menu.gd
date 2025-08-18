extends Control
@onready var title: Label = $Title
@onready var start: Button = $Start
@onready var options: Button = $Options
@onready var quit: Button = $Quit


var move_amount: float = -10.0

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func _on_options_pressed() -> void:
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_start_button_down() -> void:
	start.position.y -= move_amount

func _on_quit_button_down() -> void:
	quit.position.y -= move_amount

func _on_options_button_down() -> void:
	options.position.y -= move_amount

func _on_start_button_up() -> void:
	start.position.y += move_amount

func _on_options_button_up() -> void:
	options.position.y += move_amount

func _on_quit_button_up() -> void:
	quit.position.y += move_amount
