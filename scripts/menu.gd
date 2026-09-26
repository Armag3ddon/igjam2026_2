extends Control



func _on_one_player_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/OnePlayerSelection.tscn")

func _on_two_players_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/TwoPlayerSelection.tscn")
