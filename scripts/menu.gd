extends Control

var credits_time: float = 0.0
var credits_speed: float = 0.5

var credits_direction: int = 0

@onready var credits = $credits
@onready var menu = $menu

var credits_positions: Array[Vector2] = [Vector2(0.0, 1080.0), Vector2(0.0, 0.0)]
var menu_positions: Array[Vector2] = [Vector2(0.0, 0.0), Vector2(0.0, -1080.0)]

var credits_control_points: Array[Vector2] = [Vector2(-250.0, 830.0), Vector2(250.0, 830.0)]
var menu_control_points: Array[Vector2] = [Vector2(-250.0, 250.0), Vector2(250.0, 250.0)]

func _on_one_player_pressed() -> void:
	Global.player_count = 1
	get_tree().change_scene_to_file("res://scenes/PlayerSelection.tscn")

func _on_two_players_pressed() -> void:
	Global.player_count = 2
	get_tree().change_scene_to_file("res://scenes/PlayerSelection.tscn")

func _on_credits_pressed() -> void:
	credits_direction = 1

func _on_back_pressed() -> void:
	credits_direction = -1

func _process(delta: float) -> void:
	if credits_direction == 0:
		return
	credits_time += delta * credits_speed
	if credits_time > 1.0:
		credits_time = 1.0
	if credits_direction == 1:
		credits.position = _cubic_bezier(credits_positions[0], credits_control_points[0], credits_control_points[1], credits_positions[1], credits_time)
		menu.position = _cubic_bezier(menu_positions[0], menu_control_points[0], menu_control_points[1], menu_positions[1], credits_time)
	if credits_direction == -1:
		credits.position = _cubic_bezier(credits_positions[1], credits_control_points[1], credits_control_points[0], credits_positions[0], credits_time)
		menu.position = _cubic_bezier(menu_positions[1], menu_control_points[1], menu_control_points[0], menu_positions[0], credits_time)
	if credits_time == 1.0:
		credits_direction = 0
		credits_time = 0.0

# https://docs.godotengine.org/en/stable/tutorials/math/beziers_and_curves.html
func _cubic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var q2 = p2.lerp(p3, t)

	var r0 = q0.lerp(q1, t)
	var r1 = q1.lerp(q2, t)

	var s = r0.lerp(r1, t)
	return s
