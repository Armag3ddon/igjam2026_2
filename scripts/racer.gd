extends Node2D

class_name Racer

var grid_position: Vector2 = Vector2(0,0)
var origin_position_pixel: Vector2 = Vector2(0, 0)
var target_position_pixel: Vector2 = Vector2(0, 0)
var is_moving: bool = false
var movement_speed: float = 0.5
var movement_time: float = 0.0
var grid_size_pixel: Vector2 = Vector2(1920, 1080)
var grid_size: Vector2 = Vector2(5, 10)

func setNewPosition(new_pos: Vector2):
	grid_position = new_pos
	is_moving = true
	var offset: Vector2 = grid_size_pixel / grid_size / 2
	offset.y = offset.y * -1.0
	target_position_pixel.x = grid_size_pixel.x / grid_size.x * grid_position.x
	target_position_pixel.y = grid_size_pixel.y / grid_size.y * grid_position.y
	target_position_pixel += offset
	origin_position_pixel = position
	movement_time = 0.0

func startMoving() -> void:
	is_moving = true

func _process(delta: float) -> void:
	if is_moving:
		if position == target_position_pixel:
			is_moving = false
		else:
			movement_time += movement_speed * delta
			if movement_time > 1.0:
				movement_time = 1.0
			position = origin_position_pixel.lerp(target_position_pixel, movement_time)
