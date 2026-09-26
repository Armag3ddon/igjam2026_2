extends Node2D

var sky_speed: float = 5.0

var cloud_chance_per_frame: float = 0.010

var clouds: Array[TextureRect]

@onready var cloud_textures: Array[Texture2D] = [
	load("res://assets/effects/cloud1.png"),
	load("res://assets/effects/cloud2.png"),
	load("res://assets/effects/cloud3.png"),
	load("res://assets/effects/cloud4.png"),
	load("res://assets/effects/cloud5.png")
]

func _process(delta: float) -> void:
	if randf() <= cloud_chance_per_frame:
		var new_cloud: TextureRect = TextureRect.new()
		var cloud_position: Vector2 = Vector2(randf() * (1920.0+480.0) - 480.0, -780.0)
		new_cloud.texture = cloud_textures.pick_random()
		new_cloud.position = cloud_position
		add_child(new_cloud)
	for cloud: Node in get_children():
		cloud.position.y += sky_speed
		if cloud.position.y > 1080.0+780.0:
			remove_child(cloud)
			cloud.queue_free()
