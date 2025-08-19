extends Node2D
@onready var lift1_anim: AnimationPlayer = $Lift1/AnimationPlayer
@onready var moving_plat_anim: AnimationPlayer = $AnimatableBody2D/AnimationPlayer
@onready var static_remove_anim: AnimationPlayer = $StaticBody2D3/AnimationPlayer
@onready var moving_plat_anim2: AnimationPlayer = $AnimatableBody2D2/AnimationPlayer
@onready var lift2_anim: AnimationPlayer = $Lift2/AnimationPlayer
@onready var door: Line2D = $Door/Node2D/Line2D
@onready var main: Node2D = $"../.."

var check_list: int = 0
var max_check_list: int = 5
var beat_level_5: bool = false
var stored_bodies: Array = []

func update_checklist(update: bool) -> void:
	if update:
		check_list += 1
	else:
		check_list -= 1
		
	if check_list >= max_check_list:
		beat_level_5 = true
		door.default_color = Color.from_rgba8(50, 205, 50, 255)
		if len(stored_bodies) > 0 and not beat_level_5:
			for e in stored_bodies:
				if e.name == "Player":
					beat_level_5 = true
					main.on_level += 0
					get_tree().change_scene_to_file("res://Scenes/Complete.tscn")
	else:
		door.default_color = Color.from_rgba8(173, 10, 45, 255)
		beat_level_5 = false

func _on_door_body_entered(body: Node2D) -> void:
	stored_bodies.append(body)
	if body.name == "Player" and beat_level_5:
		door.default_color = Color.from_rgba8(50, 205, 50, 255)
		main.on_level += 0
		get_tree().change_scene_to_file("res://Scenes/Complete.tscn")

func _on_door_body_exited(body: Node2D) -> void:
	stored_bodies.erase(body)

func _on_area_switch_entered() -> void:
	lift1_anim.play("move")
	update_checklist(true)

func _on_area_switch_3_entered() -> void:
	moving_plat_anim.play("move")

func _on_area_switch_3_left() -> void:
	moving_plat_anim.pause()

func _on_area_switch_2_entered() -> void:
	static_remove_anim.play("Move")

func _on_area_switch_2_left() -> void:
	static_remove_anim.play_backwards("Move")

func _on_area_switch_5_entered() -> void:
	update_checklist(true)

func _on_area_switch_4_entered() -> void:
	update_checklist(true)

func _on_area_switch_6_entered() -> void:
	moving_plat_anim2.play("move")

func _on_area_switch_6_left() -> void:
	moving_plat_anim2.pause()

func _on_area_switch_7_entered() -> void:
	lift2_anim.play("move")

func _on_area_switch_7_left() -> void:
	lift2_anim.play_backwards("move")


func _on_area_switch_8_entered() -> void:
	update_checklist(true)


func _on_area_switch_9_entered() -> void:
	update_checklist(true)


func _on_area_switch_9_left() -> void:
	update_checklist(false)
