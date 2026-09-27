extends Control

func _ready() -> void:
	var human_winner: bool = false
	for i: int in 5:
		if Global.winner_winner_chicken_dinner[i]:
			var new_rect: TextureRect = TextureRect.new()
			var texture: Texture2D = load(Global.getBirdPortrait(i))
			new_rect.texture = texture
			new_rect.scale = Vector2(0.5, 0.5)
			$Showcase.add_child(new_rect)
			if Global.is_player_human[i]:
				human_winner = true
	if not human_winner:
		$WinMusic.stop()
		$LoseMusic.play()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
