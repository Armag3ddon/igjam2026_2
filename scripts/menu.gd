extends Control



func _on_one_player_pressed() -> void:
	Global.player_count = 1
	get_tree().change_scene_to_file("res://scenes/PlayerSelection.tscn")

func _on_two_players_pressed() -> void:
	Global.player_count = 2
	get_tree().change_scene_to_file("res://scenes/PlayerSelection.tscn")
