extends Node2D

class_name Racer

@export var Graphics: PackedScene
var graphics_scale: float = 0.5

var grid_position: Vector2 = Vector2(0,0)
var origin_position_pixel: Vector2 = Vector2(0, 0)
var target_position_pixel: Vector2 = Vector2(0, 0)
var grid_size_pixel: Vector2 = Vector2(1920, 1080)
var grid_size: Vector2 = Vector2(5, 10)

var is_moving: bool = false
var movement_speed: float = 0.5
var movement_time: float = 0.0

var swerve_angle: float = 0.0
var swerve_time: float = 0.2
var swerve_wait_time: float = 0.0
var swerve_max_x: float = 50.0
var swerve_max_y: float = 25.0
var swerve_position: Vector2 = Vector2(0, 0)

var was_hit: bool = false

func setGraphics(new_graphics: PackedScene) -> void:
	Graphics = new_graphics
	var child = new_graphics.instantiate()
	child.scale = Vector2(graphics_scale, graphics_scale)
	add_child(child)

func setNewPosition(new_pos: Vector2) -> void:
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

func startSwerve() -> void:
	swerve_angle = 0.0
	swerve_time = 0.0
	swerve_wait_time = randf() * 0.5

func registerHit() -> void:
	was_hit = true

func processAdvance() -> void:
	if was_hit:
		if grid_position.y < grid_size.y:
			setNewPosition(Vector2(grid_position.x, grid_position.y + 1))
	else:
		setNewPosition(Vector2(grid_position.x, grid_position.y - 1))
	was_hit = false

func _process(delta: float) -> void:
	if is_moving:
		if position == target_position_pixel:
			is_moving = false
			startSwerve()
		else:
			movement_time += movement_speed * delta
			if movement_time > 1.0:
				movement_time = 1.0
			position = origin_position_pixel.lerp(target_position_pixel, movement_time)
	else:
		if swerve_wait_time > 0.0:
			swerve_wait_time -= delta
		else:
			swerve_angle += delta * 360.0
			if swerve_angle > 360.0:
				swerve_angle -= 360.0
			swerve_position.x = sin(deg_to_rad(swerve_angle)) * swerve_max_x
			swerve_position.y = sin(deg_to_rad(swerve_angle * 2.0)) * swerve_max_y
			position = target_position_pixel + swerve_position
