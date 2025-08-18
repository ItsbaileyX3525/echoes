extends Node2D
@onready var player: CharacterBody2D = $"../../Player"
@onready var ghost: CharacterBody2D = $"../../Ghost"
@onready var LiftAnim: AnimationPlayer = $Lift/AnimationPlayer
@onready var move_plat: AnimationPlayer = $MovingPlat/MovePlat
@onready var line_2d: Line2D = $Door/Node2D/Line2D
@onready var main: Node2D = $"../.."
@onready var border_1: StaticBody2D = $Border1
@onready var door: Area2D = $"../Level1/Door"

var stored_time: float = 0.0
var check_list: int = 0
var max_check_list: int = 3
var level_1_beat: bool = false
var pressed_perm: bool = false
var bodies_in_area: Array = []

func _on_door_body_entered(body: Node2D) -> void:
	bodies_in_area.append(body)
	if body.name == "Player":
		if check_list >= max_check_list:
			main.on_level += 1
			level_1_beat = true
			border_1.position.y += 99999

func _on_door_body_exited(body: Node2D) -> void:
	bodies_in_area.erase(body)

func update_checklist(update: bool) -> void:
	if update:
		check_list += 1
	else:
		check_list -= 1
	
	if check_list >= max_check_list and not level_1_beat:
		line_2d.default_color = Color.from_rgba8(50, 205, 50, 255)
		for e in bodies_in_area:
			if e.name == "Player":
				main.on_level += 1
				level_1_beat = true
				border_1.position.y += 99999
	else:
		if not level_1_beat:
			line_2d.default_color = Color.from_rgba8(173, 10, 45, 255)

func _on_area_switch_entered() -> void:
	LiftAnim.play("move")

func _on_area_switch_left() -> void:
	if not pressed_perm:
		LiftAnim.play_backwards("move")

func _on_area_switch_2_entered() -> void:
	move_plat.play("move")
	pressed_perm = true
	LiftAnim.play("move")
	update_checklist(true)

func _on_area_switch_3_entered() -> void:
	update_checklist(true)

func _on_area_switch_3_left() -> void:
	update_checklist(false)

func _on_area_switch_4_entered() -> void:
	update_checklist(true)

func _on_area_switch_4_left() -> void:
	update_checklist(false)
