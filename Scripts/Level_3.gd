extends Node2D

@onready var moving_plat_anim: AnimationPlayer = $MovingPlat/AnimationPlayer
@onready var door: Line2D = $Door/Node2D/Line2D
@onready var main: Node2D = $"../.."
@onready var border_1: StaticBody2D = $Border1

var stored_bodies: Array = []
var check_list: int = 0
var max_check_list: int = 4
var beat_level_3: bool = false

func update_checklist(update) -> void:
	if update:
		check_list += 1
	else: 
		check_list -= 1
		
	if check_list >= max_check_list:
		door.default_color = Color.from_rgba8(50, 205, 50, 255)
		if len(stored_bodies) > 0 and not beat_level_3:
			for e in stored_bodies:
				if e.name == "Player":
					beat_level_3 = true
					main.on_level += 1
					border_1.position.y = 99999
	else:
		door.default_color = Color.from_rgba8(173, 10, 45, 255)

func _on_area_switch_entered() -> void:
	moving_plat_anim.play("move")

func _on_area_switch_left() -> void:
	moving_plat_anim.pause()

func _on_area_switch_2_entered() -> void:
	update_checklist(true)

func _on_area_switch_3_entered() -> void:
	update_checklist(true)

func _on_area_switch_3_left() -> void:
	update_checklist(false)

func _on_area_switch_4_entered() -> void:
	update_checklist(true)

func _on_area_switch_4_left() -> void:
	update_checklist(false)

func _on_area_switch_5_entered() -> void:
	update_checklist(true)

func _on_area_switch_5_left() -> void:
	update_checklist(false)

func _on_door_body_entered(body: Node2D) -> void:
	stored_bodies.append(body)
	if body.name == "Player" and not beat_level_3:
		if check_list >= max_check_list:
			beat_level_3 = true
			main.on_level += 1
			border_1.position.y = 99999
			pass

func _on_door_body_exited(body: Node2D) -> void:
	stored_bodies.erase(body)
